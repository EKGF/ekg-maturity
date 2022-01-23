#!/usr/bin/env bash
#
# WARNING: This script is being replaced by latexmk (and it's init file .latexmkrc). This script still works but
#          is no longer supported and not used in Github Actions workflows.
#
# Build all content using a docker container or using your local LaTeX (Texlive/MacTex) installation (if you provide
# the --local option).
#
# Usage: ./build.sh [--local] [--editors-version] [--release-version] [--skip-pandoc] <name of main doc without extension>
#
# This script assumes that your main doc is in a sub directory of the same name,
# for instance "./ekg-mm/ekg-mm.tex"
#
# The --editors-version option is the default option but if you want both the release-version and the editors-version
# of a doc you need to specify both --editors-version and --release-version.
#
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"

#
# Global vars that are exported into environment of subshells
#
export max_print_line=2000
export error_line=254
export half_error_line=238
#
# Other global vars
#
skip_pandoc=0

function documentName() {

  basename "$1" ".tex"
}

function jobName() {

  local -r customerCode="$1"
  local -r mode="$2"
  local -r documentName="$3"
  local -r version="${4//./-}"

  echo -n "${customerCode}-${documentName}"

  [[ "${mode}" == "draft" ]] && echo -n "-draft"

  echo -n "-${version}"
}

function version() {

  local -r file="$1"
  local -r dir=$(dirname "${file}")
  local version=''

  if [[ -f "${dir}/VERSION" ]] ; then
    version="$(head -n1 "${dir}/VERSION")"
  elif [[ -f "../VERSION" ]] ; then
    version="$(head -n1 "../VERSION")"
  elif [[ -f "VERSION" ]] ; then
    version="$(head -n1 "VERSION")"
  else
    echo "0.1" > "VERSION"
    version="0.1"
  fi

  if [[ -z "${GITHUB_RUN_NUMBER}" ]] ; then
    version+=".${USER}"
  else
    version+=".${GITHUB_RUN_NUMBER}"
  fi
  echo "${version//[$'\t\r\n']}"
}

function runLaTex() {

  local -r mode="$1"
  local -r run="$2"
  local -r customerCode="$3"
  local -r file="$4.tex"
  local -r documentName="$(documentName "${file}")"
  local -r version="$(version "${file}")"
  local -r jobName=$(jobName "${customerCode}" "${mode}" "${documentName}" "${version}")
  local skipGeneratingPdf="--draftmode" # this is NOT the same as editors-version inside the doc itself
  local latexCommand="\def\customerCode{${customerCode}}"

  echo "Document Version: ${version}" >&2

  latexCommand+=" \def\documentName{${documentName}}"
  latexCommand+=" \def\documentVersion{${version}}"

  if [[ ${run} -eq 4 ]] ; then
    skipGeneratingPdf=""
  fi

  latexCommand+="\def\documentMode{${mode}}"
  latexCommand+="\input{"${file}'}'

  echo "*******************"
  echo "******************* lualatex run ${run} ${mode} ${customerCode} ${file}"
  echo "*******************"

  if ((run == 1)) ; then
    lualatex \
      --synctex=1 \
      --output-format=pdf \
      --shell-escape \
      --halt-on-error \
      --file-line-error \
      --file-line-error \
      --interaction=nonstopmode \
      --recorder \
      --jobname "${jobName}" \
      ${skipGeneratingPdf} ${latexCommand} | \
      grep -v "LaTeX Warning: Reference .* on page .* undefined on input line .*" | \
      grep -v "LaTeX Warning: Citation .* on page .* undefined on input line .*" | \
      grep -v "^$"
  else
    lualatex \
      --synctex=1 \
      --output-format=pdf \
      --shell-escape \
      --halt-on-error \
      --file-line-error \
      --file-line-error \
      --interaction=nonstopmode \
      --recorder \
      --jobname "${jobName}" \
      ${skipGeneratingPdf} ${latexCommand}
  fi
#  | \
#    sed "s/Undefined control sequence/ERROR: Undefined control sequence/g" | \
#    sed "s@/usr/local/texlive/2019/texmf-dist@latex@g"
  local rc=$?
  set +x
  echo "******************* lualatex rc=${rc} ${file}"
#  return ${rc}
  return 0
}

function runBiber() {

  local -r mode="$1"
  local -r customerCode="$2"
  local -r file="$3.tex"
  local -r documentName="$(documentName "${file}")"
  local -r version="$(version "${file}")"
  local -r jobName=$(jobName "${customerCode}" "${mode}" "${documentName}" "${version}")

  echo "*******************"
  echo "******************* biber ${jobName}"
  echo "*******************"
  if [[ ! -f "${jobName}.bcf" ]] ; then
    echo "Not running Biber because there's no ${jobName}.bcf file"
    echo "******************* biber did not run on ${jobName}"
  else
    (
      biber --debug --noconf ${jobName}
    )
    local rc=$?
    echo "******************* biber rc=${rc} ${jobName}"
  fi
  return ${rc}
}

function runMakeGlossaries() {

  local -r mode="$1"
  local -r customerCode="$2"
  local -r file="$3.tex"
  local -r documentName="$(documentName "${file}")"
  local -r version="$(version "${file}")"
  local -r jobName=$(jobName "${customerCode}" "${mode}" "${documentName}" "${version}")

  local rc=0

  echo "*******************"
  echo "******************* makeglossaries \"${jobName}\""
  echo "*******************"

#  if head -n 1 "${file}.aux" | grep -q "relax" ; then
#    echo "No need to run makeglossaries"
#    echo "******************* makeglossaries did not need to run on ${file}"
#  else
    makeglossaries "${jobName}"
    rc=$?
    echo "******************* makeglossaries rc=${rc} ${jobName}"
#  fi

  return ${rc}
}

function runMakeIndex() {

  local -r mode="$1"
  local -r customerCode="$2"
  local -r file="$3.tex"
  local -r documentName="$(documentName "${file}")"
  local -r version="$(version "${file}")"
  local -r jobName=$(jobName "${customerCode}" "${mode}" "${documentName}" "${version}")

  echo "*******************"
  echo "******************* makeindex ${jobName}"
  echo "*******************"
  (
    makeindex -t ${jobName}.ilg -o ${jobName}.ind ${jobName}.idx
  )
  local rc=$?
  echo "******************* makeindex rc=${rc} ${jobName}"
  return ${rc}
}

function runPandoc() {

# local -r mode="$1"
  local -r customerCode="$2"
  local -r file="$3.tex"
  local -r texFile="${file}"
# local -r documentName="$(documentName "${file}")"
# local -r version="$(version "${file}")"
# local -r jobName=$(jobName "${customerCode}" "${mode}" "${documentName}" "${version}")
  local -r docxFile="${file/.tex/.pandoc.docx}"

  rm -f "${docxFile}" >/dev/null 2>&1

  ((skip_pandoc)) && return 0

  if ! which pandoc >/dev/null 2>&1 ; then
    echo "WARNING: pandoc not installed, skipping generation of Word version"
    echo "NOTE: on Mac OS X you can install pandoc with 'brew install pandoc'"
    return 0
  fi

  echo "Pandoc is installed, generating the Word version of your document now"

  echo "Generating ${docxFile}"

  #
  # pandoc is a haskell program so you can specify heap size etc via +RTS ... -RTS
  # see https://downloads.haskell.org/~ghc/latest/docs/html/users_guide/runtime_control.html#rts-opts-cmdline
  # for more info
  #

  pandoc \
    +RTS -M2g -RTS \
    --resource-path="../images:../customer-assets/${customerCode}" \
    --table-of-contents \
    --toc-depth=3 \
    --from=latex+latex_macros \
    --standalone \
    "${texFile}" \
    -o "${docxFile}"
  local -r rc=$?

  if ((rc > 0)) ; then
    echo "ERROR: pandoc failed with error code ${rc}"
  fi

  return ${rc}
}

function cleanTopLevelDocDirectory() {

  rm *.{acn,acr,alg,aux,bbl,bcf,blg,fdb_latexmk,fls,glg,glo,gls,glsdefs,glsdef,idx,labelTags,log,odn,old,olg,pdf,run.xml,synctex.gz,tdn,tld,tlg,tex.bbl,tex.blg,ilg,ind,ist,tdo,log,out,sta,toc,pdf} >/dev/null 2>&1
  rm -rf .texpadtmp/ >/dev/null 2>&1

  return $?
}

function runInkScapeOnSVGFile() {

  local -r svgFile="$(pwd)/$1"
  local -r pdfFile="${svgFile/.svg/.pdf}"

  echo -n "InkScape: Processing SVG file: ${svgFile}" >&2

  if [[ ${svgFile} -ot ${pdfFile} ]] ; then
    echo " was already done" >&2
    return 0
  fi
  echo "" >&2

  if [[ "$(uname)" == "Linux" ]] ; then
    #
    # Quick fix, run inkscape in dbus-run-session to avoid the ugly dbus messages (and it seems to speed up a little too)
    #
    if ! dbus-run-session inkscape "${svgFile}" -D --export-filename="${pdfFile}" --export-type="pdf" --export-latex ; then
      echo "ERROR: Error occurred with inkscape ${svgFile}" >&2
      return 1
    fi
  else
    if ! inkscape "${svgFile}" \
       --export-area-drawing \
       --export-filename="${pdfFile}" \
       --export-pdf-version=1.5 \
       --export-type="pdf" \
       --export-latex ; then
      echo "ERROR: Error occurred with inkscape ${svgFile}" >&2
      return 1
    fi
  fi

  return 0
}

function runInkScapeOnVSDXFile() {

  local -r vsdxFile="$1"

  echo "InkScape: Processing VSDX file: ${vsdxFile}" >&2

  if [[ "$(uname)" == "Linux" ]] ; then
    #
    # Quick fix, run inkscape in dbus-run-session to avoid the ugly dbus messages (and it seems to speed up a little too)
    #
    if ! dbus-run-session inkscape "$(pwd)/${vsdxFile}" -D --export-filename="$(pwd)/${vsdxFile/.vsdx/.pdf}" --export-type="pdf" --export-latex ; then
      echo "ERROR: Error occurred with inkscape $(pwd)/${vsdxFile}" >&2
      return 1
    fi
  else
    if ! inkscape "$(pwd)/${vsdxFile}" -D --export-filename="$(pwd)/${vsdxFile/.vsdx/.pdf}" --export-type="pdf" --export-latex ; then
      echo "ERROR: Error occurred with inkscape $(pwd)/${vsdxFile}" >&2
      return 1
    fi
  fi

  return 0
}

function runInkScapeInDir() {

  local -r directory="$1"

  (
    if ! cd "${directory}" ; then
      echo "ERROR: Could not find directory ${directory}" >&2
      return 1
    fi
    echo "InkScape: checking directory $(pwd)" >&2

    if ls -- *.svg >/dev/null 2>&1 ; then
      for svgFile in *.svg ; do
        [[ "xx${svgFile}xx" == "xx*.svgxx" ]] && continue
        runInkScapeOnSVGFile "${svgFile}" || return $?
      done
    fi
    if ls -- *.vsdx >/dev/null 2>&1 ; then
      for vsdxFile in *.vsdx ; do
        [[ "xx${vsdxFile}xx" == "xx*.vsdxxx" ]] && continue
        runInkScapeOnVSDXFile "${vsdxFile}" || return $?
      done
    fi

    for subdir in $(ls -1F  | grep '/') ; do
      runInkScapeInDir "./${subdir}" || return $?
    done

    return 0
  )

  return $?
}

function runInkScape() {

  (
    cd ..
    echo "InkScape: Running InkScape, current directory is $(pwd)" >&2

    if ! command -v inkscape >/dev/null 2>&1 ; then
      echo "WARNING: Cannot convert SVG files to PDF and pdf_tex files because inkscape is not installed" >&2
      if [[ "$(uname)" == Darwin ]] ; then
        echo "InkScape: Installing..." >&2
        brew install --cask inkscape
        if ! command -v inkscape >/dev/null 2>&1 ; then
          echo "ERROR: Could not install inkscape" >&2
          return 1
        fi
      else
        return 0
      fi
    fi

    runInkScapeInDir . || return $?
  )
  local -r rc=$?
  echo "InkScape: Done" >&2

  return ${rc}
}

function getCustomerCodeInFileName() {

  local -r customerCode="$1"

  if [[ -f "${SCRIPT_DIR}/customer-assets/${customerCode}/customer-code-in-file-names.txt" ]] ; then
    cat "${SCRIPT_DIR}/customer-assets/${customerCode}/customer-code-in-file-names.txt"
  else
    echo "${customerCode}"
  fi

  return 0
}

function stripCustomerCodeFromMainFileName() {

  local -r customerCode="$1"
  local -r mainFile="$2"

  echo -n "${mainFile}" | sed "s/${customerCode}-//g" | sed "s/-${customerCode}//g"
}

function mainFileStripped() {

  local -r mode="$1"
  local -r customerCode="$2"
  local -r mainFile="$3"

  stripCustomerCodeFromMainFileName "${customerCode}" "${mainFile}"
}

function pdfOutputFileName() {

  local -r mode="$1"
  local -r customerCode="$2"
  local -r mainFile="$3"
  local -r mainFileStripped="$(mainFileStripped $@)"
  local -r customerCodeInFileName="$(getCustomerCodeInFileName "${customerCode}")"

  #
  # TODO: Add version number to file name
  #
  echo -n "${customerCodeInFileName} - ${mainFileStripped} - ${mode}.pdf"
}

function docxOutputFileName() {

  local -r mode="$1"
  local -r customerCode="$2"
  local -r mainFile="$3"
  local -r mainFileStripped="$(stripCustomerCodeFromMainFileName "${customerCode}" "${mainFile}")"
  local -r customerCodeInFileName="$(getCustomerCodeInFileName "${customerCode}")"

  #
  # TODO: Add version number to file name
  #
  echo -n "${customerCodeInFileName} - ${mainFileStripped} - ${mode}.docx"
}

function googleDriveSharedDrivesRoot() {

  #
  # If we run in the docker container then this is the directory to which your local google drive will be
  # mounted
  #
  if [[ -d /var/lib/google-drive ]] ; then
    echo "/var/lib/google-drive"
    return 0
  fi
  #
  # Feel free to add your own google drive directory here with an "if [[ ${USER} == yourname ]] ; .." statement
  #
  echo "${HOME}/Google Drive File Stream/Shared drives"
}

function copyToGoogleDriveLocal() {

  local -r googleDriveFileStreamSharedDrives="$(googleDriveSharedDrivesRoot)"

  if [[ ! -d "${googleDriveFileStreamSharedDrives}" ]] ; then
    echo "You are not running Google Drive File Stream so we're not copying your PDF to that"
    return 0
  fi
  echo "Detected that you're running Google Drive File Stream, copying PDF to the appropriate location in there"

  local -r mode="$1"
  local -r customerCode="$2"
  local -r customerCodeInFileName="$(getCustomerCodeInFileName "${customerCode}")"
  local -r mainFile="$3"
  local -r mainFileStripped="$(stripCustomerCodeFromMainFileName "${customerCode}" "${mainFile}")"
  local -r pandocDocxFile="${mainFile}.pandoc.docx"

  if [[ ! -f "${mainFile}.pdf" ]] ; then
    echo "ERROR: Could not find ${mainFile}.pdf"
    return 1
  fi

  local targetDirectory="${googleDriveFileStreamSharedDrives}/service-group"

  case "${customerCode}" in
    agnos)
      case "${mainFileStripped}" in
        ekg-mm)
          targetDirectory+="/service-group/ekg-mm"
          ;;
        ekg-method)
          targetDirectory+="/service-group/ekg-method"
          ;;
        ekg-catalog)
          targetDirectory+="/service-group/ekg-catalog"
          ;;
        *)
          targetDirectory+="/service-group/generated-docs"
          ;;
      esac
      targetDirectory+="/${mode}"
      ;;
    ekgf)
      case "${mainFileStripped}" in
        ekg-mm)
          targetDirectory+="/EKGF Maturity Model"
          ;;
        *)
          targetDirectory+="/service-group/generated-docs"
          ;;
      esac
      targetDirectory+="/${mode}"
      ;;
    *)
      targetDirectory+="/04 - customers/${customerCode}/generated-docs/${mode}"
      ;;
  esac

  mkdir -p "${targetDirectory}" >/dev/null 2>&1

  if [[ ! -d "${targetDirectory}" ]] ; then
    echo "ERROR: Could not create ${targetDirectory}"
    return 1
  fi

  cp -v "${mainFile}.pdf" "${targetDirectory}/$(pdfOutputFileName $@)"

  if [[ -f "${pandocDocxFile}" ]] ; then
    cp -v "${pandocDocxFile}" "${targetDirectory}/$(docxOutputFileName $@)"
  fi
}

function runBuildForMode() {

  local -r mode="$1"
  local -r customerCode="$2"
  local -r mainFile="$3"

  runLaTex "${mode}" 1 "${customerCode}" "${mainFile}" || return $?
  runBiber "${mode}" "${customerCode}" "${mainFile}" || return $?
  runLaTex "${mode}" 2 "${customerCode}" "${mainFile}" || return $?
  runMakeGlossaries "${mode}" "${customerCode}" "${mainFile}" || return $?
  runLaTex "${mode}" 3 "${customerCode}" "${mainFile}" || return $?
  runMakeIndex "${mode}" "${customerCode}" "${mainFile}" || return $?
  runLaTex "${mode}" 4 "${customerCode}" "${mainFile}" || return $?
  runLaTex "${mode}" 5 "${customerCode}" "${mainFile}" || return $?

#  runPandoc "${mode}" "${customerCode}" "${mainFile}" || return $?

#  copyToGoogleDriveLocal "${mode}" "${customerCode}" "${mainFile}" || return $?

  return 0
}

function defaultCustomerCode() {

  local gitRepoOrgName="$(git config --get remote.origin.url | sed 's!^.*github.com[:/]\(.*\)/.*$!\1!g')"

  gitRepoOrgName="${gitRepoOrgName,,}"

  if [[ -n "${gitRepoOrgName}" ]] ; then
    echo "${gitRepoOrgName}"
    return 0
  fi
  echo "agnos.ai"
}

function runTheBuild() {

  local customerCode="$(defaultCustomerCode)"

  if [[ $# -lt 1 ]] ; then
    echo "Usage: $0 [--local] [--editors-version] [--release-version] [--skip-pandoc] [--open] [--customer <customer code>] <name of main doc>"
    echo ""
    echo "The --editors-version option is the default but if you want to both the editors-version and the"
    echo "release-version of the document then specify them both."
    echo "The default customer code is \"${customerCode}\"."
    return 1
  fi

  local useLocalLaTeX=0
  local draftOption=""
  local finalOption=""
  local buildDraftVersion=0
  local buildFinalVersion=0
  local openThePdf=0
  local customerOption="--customer ${customerCode}"

  while (($#)) ; do
    if [[ "$1" == "--local" ]] ; then
      useLocalLaTeX=1
      shift
    elif [[ "$1" == "--editors-version" ]] ; then
      buildDraftVersion=1
      draftOption="--editors-version"
      shift
    elif [[ "$1" == "--release-version" ]] ; then
      buildFinalVersion=1
      finalOption="--release-version"
      shift
    elif [[ "$1" == "--skip-pandoc" ]] ; then
      skip_pandoc=1
      shift
    elif [[ "$1" == "--open" ]] ; then
      openThePdf=1
      shift
    elif [[ "$1" == "--customer" ]] ; then
      customerCode="$2"
      if [[ ! -d "${SCRIPT_DIR}/customer-assets/${customerCode}" ]] ; then
        echo "ERROR: Could not find directory ./customer-assets/${customerCode}"
        exit 1
      fi
      customerOption="--customer ${customerCode}"
      shift 2
    else
      break
    fi
  done

  local -r mainFile="$1"
  local    mainDir="${mainFile}"

  if ! cd "${mainDir}" ; then
    echo "ERROR: Directory ${mainDir} does not exist" >&2
    return 1
  fi

  if [[ ! -f "${mainFile}.tex" ]] ; then
    echo "ERROR: Could not find ${mainFile}/${mainFile}.tex" >&2
    return 1
  fi

  if ((useLocalLaTeX)) ; then
    if which lualatex >/dev/null 2>&1 ; then
      echo "Using your local LaTeX installation, remove the --local option from the command line if you want to use the Docker version of LaTeX"
      if [[ "$(uname)" == "Darwin" ]] ; then
        installFontsInDarwin || return $?
      fi
    else
      echo "ERROR: Could not find lualatex on your PATH" >&2
      return 1
    fi
  elif isRunningInDockerContainer ; then
    echo "Running in the docker container" >&2
    installFontsInLinux || return $?
  elif [[ "$(uname)" == "Darwin" ]] || [[ "$(uname)" == "Linux" ]]  ; then
    runInDocker "${customerCode}"
    return $?
  else
    echo "ERROR: Running on an unknown platform" >&2
    return 1
  fi

  runInkScape || return $?

  (
    cd ..
    cleanTopLevelDocDirectory "${mainFile}" || return $?
  ) || return $?

  if ((buildDraftVersion)) && ((buildFinalVersion)) ; then
    runBuildForMode editors-version "${customerCode}" "${mainFile}" || return $?
    runBuildForMode release-version "${customerCode}" "${mainFile}" || return $?
    openPdf draft "${customerCode}" "${mainFile}"
  elif ((buildFinalVersion)) ; then
    runBuildForMode release-version "${customerCode}" "${mainFile}" || return $?
    openPdf release-version "${customerCode}" "${mainFile}"
  else
    runBuildForMode editors-version "${customerCode}" "${mainFile}" || return $?
    openPdf editors-version "${customerCode}" "${mainFile}"
  fi

  return $?
}

function openPdfForReal() {

  local -r pdf="$1"

  if [[ -d /Applications/Skim.app ]] ; then
    open -a "Skim" "${pdf}"
    return $?
  fi

  open "${pdf}"
}

function openPdf() {

  ((openThePdf)) || return 0

  if ((! useLocalLaTeX)) ; then
    echo "ERROR: Cannot open PDF when not running in local mode, use option --local"
    return 1
  fi

  local -r mode="$1"
  local -r customerCode="$2"
  local -r file="$3.tex"
  local -r documentName="$(documentName "${file}")"
  local -r version="$(version "${file}")"
  local -r jobName=$(jobName "${customerCode}" "${mode}" "${documentName}" "${version}")

  if [[ -f "../out/${jobName}.pdf" ]] ; then
    openPdfForReal "../out/${jobName}.pdf"
  elif [[ -f "${mainDir}/${jobName}.pdf" ]] ; then
    openPdfForReal "${mainDir}/${jobName}.pdf"
  elif [[ -f "../${mainDir}/${jobName}.pdf" ]] ; then
    openPdfForReal "../${mainDir}/${jobName}.pdf"
  else
    echo "ERROR: Could not find ${jobName}.pdf"
    echo "mainDir=${mainDir}"
    echo "mainFile=${mainFile}"
    echo "jobName=${jobName}"
    return 1
  fi

  return 0
}

#
# Return true if running inside a docker container.
# See https://stackoverflow.com/a/41559867/1110667
#
function isRunningInDockerContainer() {

  [[ "$(uname)" == "Linux" ]] || return 1

  grep docker /proc/1/cgroup -qa >/dev/null 2>&1
}

function runInDocker() {

  local -r customerCode="$1"
  local -r googleDrive="$(googleDriveSharedDrivesRoot)"
  local rc=0
  #
  # At the first run of lualatex inside the container it builds a font directory which takes a minute or so.
  # To speed that up on all subsequent runs of the docker container we cache that font directory in your
  # local ./out/texlive-fonts directory (which will be created automatically)
  #
  if [[ -d "${googleDrive}" ]] ; then
    docker run \
      --rm  -t \
      -v ${SCRIPT_DIR}:/home \
      -v ${SCRIPT_DIR}/out/texlive-fonts:/var/lib/texmf/luatex-cache/generic/fonts:delegated \
      -v "${googleDrive}:/var/lib/google-drive:delegated" \
      danteev/texlive \
      /bin/bash -c "/home/build.sh ${draftOption} ${finalOption} ${customerOption} ${mainFile}"
      rc=$?
  else
    docker run \
      --rm  -t \
      -v ${SCRIPT_DIR}:/home \
      -v ${SCRIPT_DIR}/out/texlive-fonts:/var/lib/texmf/luatex-cache/generic/fonts:delegated \
      danteev/texlive \
      /bin/bash -c "/home/build.sh ${draftOption} ${finalOption} ${customerOption} ${mainFile}"
      rc=$?
  fi
  echo "end of docker, rc=${rc}"
  #
  # Now that we're back in Mac OS X and not running inside a docker container we can open the default viewer
  # of the generated PDF file
  #
  if ((openThePdf)) ; then
    if ((buildDraftVersion)) ; then
      open "${SCRIPT_DIR}/out/$(pdfOutputFileName draft "${customerCode}" "${mainFile}")"
    else
      open "${SCRIPT_DIR}/out/$(pdfOutputFileName final "${customerCode}" "${mainFile}")"
    fi
  fi
  return ${rc}
}

function installFontsInLinux() {

  cp -R ${SCRIPT_DIR}/etc/fonts/*.ttf /usr/local/share/fonts

  fc-cache
}

function installFontsInDarwin() {

  cp -R ${SCRIPT_DIR}/etc/fonts/*.ttf ~/Library/Fonts/
}

runTheBuild $@
exit $?


