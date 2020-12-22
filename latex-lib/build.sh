#!/bin/bash
#
# WARNING: This script is being replaced by latexmk (and it's init file .latexmkrc). This script still works but
#          is no longer supported and not used in Github Actions workflows.
#
# Build all content using a docker container or using your local LaTeX (Texlive/MacTex) installation (if you provide
# the --local option).
#
# Usage: ./build.sh [--local] [--draft] [--final] [--skip-pandoc] <name of main doc without extension>
#
# This script assumes that your main doc is in a sub directory of the same name,
# for instance "./ekg-mm/ekg-mm.tex"
#
# The --draft option is the default option but if you want to build both the final and the draft version of a doc
# you need to specify both --draft and --final.
#
SCRIPT_DIR="$(cd $(dirname "${BASH_SOURCE[0]}") && pwd -P)"

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

function runLaTex() {

  local -r mode="$1"
  local -r run="$2"
  local -r customerCode="$3"
  local -r file="$4.tex"
  local skipGeneratingPdf="--draftmode" # this is NOT the same as draft mode inside the doc itself
  local latexCommand="\def\customerCode{${customerCode}}"

  if [[ ${run} -eq 4 ]] ; then
    skipGeneratingPdf=""
  fi

  if [[ "${mode}" == "draft" ]] ; then
    latexCommand+="\def\DocumentClassOptions{} \input{"${file}'}'
  elif [[ "${mode}" == "final" ]] ; then
    latexCommand+="\def\DocumentClassOptions{final} \input{"${file}'}'
  else
    echo "ERROR: Unknown draft/final mode"
    return 1
  fi

  echo "*******************"
  echo "******************* lualatex run ${run} ${mode} ${customerCode} ${file}"
  echo "*******************"

  if ((run == 1)) ; then
    lualatex \
      --output-format=pdf \
      --file-line-error \
      --shell-escape \
      --halt-on-error \
      --recorder \
      --interaction=nonstopmode \
      ${skipGeneratingPdf} ${latexCommand} | \
      grep -v "LaTeX Warning: Reference .* on page .* undefined on input line .*" | \
      grep -v "LaTeX Warning: Citation .* on page .* undefined on input line .*" | \
      grep -v "^$"
  else
    lualatex \
      --output-format=pdf \
      --file-line-error \
      --shell-escape \
      --halt-on-error \
      --recorder \
      --interaction=nonstopmode \
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

  local -r file="$1"

  echo "*******************"
  echo "******************* biber ${file}"
  echo "*******************"
  if [[ ! -f "${file}.bcf" ]] ; then
    echo "Not running Biber because there's no ${file}.bcf file"
    echo "******************* biber did not run on ${file}"
  else
    biber --debug --noconf ${file}
    local rc=$?
    echo "******************* biber rc=${rc} ${file}"
  fi
  return ${rc}
}

function runMakeGlossaries() {

  local -r file="$1"
  local rc=0

  echo "*******************"
  echo "******************* makeglossaries ${file}"
  echo "*******************"

#  if head -n 1 "${file}.aux" | grep -q "relax" ; then
#    echo "No need to run makeglossaries"
#    echo "******************* makeglossaries did not need to run on ${file}"
#  else
    makeglossaries ${file}
    rc=$?
    echo "******************* makeglossaries rc=${rc} ${file}"
#  fi

  return ${rc}
}

function runMakeIndex() {
  local file="$1"
  echo "*******************"
  echo "******************* makeindex ${file}"
  echo "*******************"
  makeindex ${file}
  local rc=$?
  echo "******************* makeindex rc=${rc} ${file}"
  return ${rc}
}

function runPandoc() {

  local -r mode="$1"
  local -r customerCode="$2"
  local -r file="$3.tex"
  local -r texFile="${file}"
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

  local -r docName="$1"

  (
    cd "${SCRIPT_DIR}/${docName}" || return 1

    rm *.{acn,acr,alg,aux,bbl,bcf,blg,fdb_latexmk,fls,glg,glo,gls,glsdefs,glsdef,idx,labelTags,log,odn,old,olg,pdf,run.xml,synctex.gz,tdn,tld,tlg,tex.bbl,tex.blg,ilg,ind,ist,tdo,log,out,sta,toc,pdf} >/dev/null 2>&1
    rm -rf .texpadtmp/ >/dev/null 2>&1
  )

  return $?
}

function runInkScapeOnSVGFile() {

  local -r svgFile="$(pwd)/$1"
  local -r pdfFile="${svgFile/.svg/.pdf}"

  echo -n "Processing SVG file: ${svgFile}"

  if [[ ${svgFile} -ot ${pdfFile} ]] ; then
    echo " was already done"
    return 0
  fi
  echo ""

  if [[ "$(uname)" == "Linux" ]] ; then
    #
    # Quick fix, run inkscape in dbus-run-session to avoid the ugly dbus messages (and it seems to speed up a little too)
    #
    if ! dbus-run-session inkscape "${svgFile}" -D --export-filename="${pdfFile}" --export-type="pdf" --export-latex ; then
      echo "ERROR: Error occurred with inkscape ${svgFile}"
      return 1
    fi
  else
    if ! inkscape "${svgFile}" -D --export-filename="${pdfFile}" --export-type="pdf" --export-latex ; then
      echo "ERROR: Error occurred with inkscape ${svgFile}"
      return 1
    fi
  fi

  return 0
}

function runInkScapeOnVSDXFile() {

  local -r vsdxFile="$1"

  echo "Processing SVG file: ${vsdxFile}"
  if [[ "$(uname)" == "Linux" ]] ; then
    #
    # Quick fix, run inkscape in dbus-run-session to avoid the ugly dbus messages (and it seems to speed up a little too)
    #
    if ! dbus-run-session inkscape "$(pwd)/${vsdxFile}" -D --export-filename="$(pwd)/${vsdxFile/.vsdx/.pdf}" --export-type="pdf" --export-latex ; then
      echo "ERROR: Error occurred with inkscape $(pwd)/${vsdxFile}"
      return 1
    fi
  else
    if ! inkscape "$(pwd)/${vsdxFile}" -D --export-filename="$(pwd)/${vsdxFile/.vsdx/.pdf}" --export-type="pdf" --export-latex ; then
      echo "ERROR: Error occurred with inkscape $(pwd)/${vsdxFile}"
      return 1
    fi
  fi

  return 0
}

function runInkScape() {

  if ! command -v inkscape >/dev/null 2>&1 ; then
    echo "WARNING: Cannot convert SVG files to PDF and pdf_tex files because inkscape is not installed"
    if [[ "$(uname)" == Darwin ]] ; then
      echo "Installing Inkscape"
      brew cask install inkscape
      if ! command -v inkscape >/dev/null 2>&1 ; then
        echo "ERROR: Could not install inkscape"
        return 1
      fi
    else
      return 0
    fi
  fi

  if ! cd images ; then
    echo "ERROR: Could not find images directory"
    return 1
  fi

  if ls -- *.svg >/dev/null 2>&1 ; then
    for svgFile in *.svg ; do
      runInkScapeOnSVGFile "${svgFile}" || return $?
    done
  fi
  if ls -- *.vsdx >/dev/null 2>&1 ; then
    for vsdxFile in *.vsdx ; do
      runInkScapeOnVSDXFile "${vsdxFile}" || return $?
    done
  fi

  cd ..

  if ! cd customer-assets ; then
    echo "ERROR: Could not find customer-assets directory"
    return 1
  fi

  for customerAssetDir in $(ls -1 -F | grep / | sed "s@/@@") ; do
    pushd ${customerAssetDir} >/dev/null 2>&1
    if ls --  *.svg >/dev/null 2>&1 ; then
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
    popd >/dev/null 2>&1
  done

  cd ..

  return 0
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

function copyToOut() {

  local -r mode="$1"
  local -r customerCode="$2"
  local -r mainFile="$3"

  local -r customerCodeInFileName="$(getCustomerCodeInFileName "${customerCode}")"
  local -r pandocDocxFile="${mainFile}.pandoc.docx"

  if [[ ! -f "${mainFile}.pdf" ]] ; then
    echo "ERROR: Could not find ${mainFile}.pdf"
    return 1
  fi

  mkdir -p "${SCRIPT_DIR}/out" >/dev/null 2>&1

  if [[ ! -d "${SCRIPT_DIR}/out" ]] ; then
    echo "ERROR: Could not create ${SCRIPT_DIR}/out"
    return 1
  fi
  cp -v "${mainFile}.pdf" "${SCRIPT_DIR}/out/$(pdfOutputFileName $@)"

  if [[ -f "${pandocDocxFile}" ]] ; then
    cp -v "${pandocDocxFile}" "${SCRIPT_DIR}/out/$(docxOutputFileName $@)"
  fi
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
        kg-method)
          targetDirectory+="/service-group/kg-method"
          ;;
        kg-discover)
          targetDirectory+="/service-group/kg-discover"
          ;;
        *)
          targetDirectory+="/service-group/generated-docs"
          ;;
      esac
      targetDirectory+="/${mode}"
      ;;
    ekgf)
      case "${mainFileStripped}" in
        kg-mm)
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

  runLaTex ${mode} 1 "${customerCode}" "${mainFile}" || return $?
  runBiber ${mainFile} || return $?
  runLaTex ${mode} 2 "${customerCode}" "${mainFile}" || return $?
  runMakeGlossaries ${mainFile} || return $?
  runLaTex ${mode} 3 "${customerCode}" "${mainFile}" || return $?
#    runMakeIndex ${mainFile} || return $?
  runLaTex ${mode} 4 "${customerCode}" "${mainFile}" || return $?

  runPandoc ${mode} "${customerCode}" "${mainFile}" || return $?

  copyToOut ${mode} "${customerCode}" "${mainFile}" || return $?
  copyToGoogleDriveLocal ${mode} "${customerCode}" "${mainFile}" || return $?

  return 0
}
function runTheBuild() {

  local customerCode="agnos"

  if [[ $# -lt 1 ]] ; then
    echo "Usage: $0 [--local] [--draft] [--final] [--skip-pandoc] [--open] [--customer <customer code>] <name of main doc>"
    echo ""
    echo "The --draft option is the default but if you want to both draft and final versions of the document then specify them both."
    echo "The default customer code is ${customerCode}."
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
    elif [[ "$1" == "--draft" ]] ; then
      buildDraftVersion=1
      draftOption="--draft"
      shift
    elif [[ "$1" == "--final" ]] ; then
      buildFinalVersion=1
      finalOption="--final"
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

  if [[ ! -f "${mainDir}/${mainFile}.tex" ]] ; then
    if [[ ! -f "${mainFile}.tex" ]] ; then
      echo "ERROR: Could not find ${mainFile}/${mainFile}.tex"
      return 1
    fi
    mainDir="$(pwd)"
  fi

  if ((useLocalLaTeX)) ; then
    if which lualatex >/dev/null 2>&1 ; then
      echo "Using your local LaTeX installation, remove the --local option from the command line if you want to use the Docker version of LaTeX"
      if [[ "$(uname)" == "Darwin" ]] ; then
        installFontsInDarwin || return $?
      fi
    else
      echo "ERROR: Could not find lualatex on your PATH"
      return 1
    fi
  elif isRunningInDockerContainer ; then
    echo "Running in the docker container"
    installFontsInLinux || return $?
  elif [[ "$(uname)" == "Darwin" ]] || [[ "$(uname)" == "Linux" ]]  ; then
    runInDocker "${customerCode}"
    return $?
  else
    echo "Running on an unknown platform"
    return 1
  fi

  runInkScape || return $?

  cleanTopLevelDocDirectory "${mainFile}" || return $?

  {
    cd "${mainDir}" || return $?

    if ((buildDraftVersion)) && ((buildFinalVersion)) ; then
      runBuildForMode draft "${customerCode}" "${mainFile}" || return $?
      runBuildForMode final "${customerCode}" "${mainFile}" || return $?
    elif ((buildFinalVersion)) ; then
      runBuildForMode final "${customerCode}" "${mainFile}" || return $?
    else
      runBuildForMode draft "${customerCode}" "${mainFile}" || return $?
    fi
  }

  if ((useLocalLaTeX)) ; then
    if ((openThePdf)) ; then
      if [[ -f "${mainFile}.pdf" ]] ; then
        open "${mainFile}.pdf"
      elif [[ -f "${mainDir}/${mainFile}.pdf" ]] ; then
        open "${mainDir}/${mainFile}.pdf"
      else
        echo "ERROR: Could not find ${mainFile}.pdf"
        echo "mainDir=${mainDir}"
        echo "mainFile=${mainFile}"
      fi
    fi
  fi
  return $?
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


