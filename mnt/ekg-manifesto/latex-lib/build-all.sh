#!/bin/bash
#
# Build all content using your locally installed LaTex installation.
#
SCRIPT_DIR="$(cd $(dirname "${BASH_SOURCE[0]}") && pwd -P)"

function getAllMainDocNames() {

  (
    cd "${SCRIPT_DIR}"
    for directory in */ ; do
      directory="${directory/\//}" # strips the slash
      if [[ -f "${directory}/${directory}.tex" ]] ; then
        echo -n "${directory} "
      fi
    done
  )
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

function getCustomerCodeOfCustomerSpecificDocument() {

  local -r documentName="$1"

  local -r IFS='-'
  read -ra documentNameParts <<< "${documentName}"

  for documentNamePart in "${documentNameParts[@]}" ; do
    if [[ -d "${SCRIPT_DIR}/customer-assets/${documentNamePart}" ]] ; then
      echo -n "${documentNamePart}"
      return 0
    fi
  done

  return 1
}

function stripCustomerCodeFromMainFileName() {

  local -r customerCode="$1"
  local -r mainFile="$2"

  echo -n "${mainFile}" | sed "s/${customerCode}-//g" | sed "s/-${customerCode}//g"
}

function buildThemAll() {

  local customerCodes=""
  local customerCodeInFileName

  if ! pushd ${SCRIPT_DIR}/customer-assets >/dev/null 2>&1 ; then
    echo "ERROR: Could not find directory ${SCRIPT_DIR}/customer-assets"
    return 1
  fi
  for dir in $(ls -1 -F | grep / | sed "s@/@@") ; do
    customerCodes+="${dir} "
  done

  popd >/dev/null 2>&1

  for pdf in $(getAllMainDocNames) ; do
    for customerCode in ${customerCodes} ; do
      customerCodeInFileName="$(getCustomerCodeInFileName "${customerCode}")"
      echo "Deleting ./out/${customerCodeInFileName}*${pdf}*.pdf"
      rm "./out/${customerCodeInFileName}*${pdf}*.pdf" >/dev/null 2>&1
    done
  done
  for pdf in $(getAllMainDocNames) ; do
    customerCode="$(getCustomerCodeOfCustomerSpecificDocument "${pdf}")"
    if [[ "${customerCode}" == "" ]] ; then
      for customerCode in ${customerCodes} ; do
        customerCodeInFileName="$(getCustomerCodeInFileName "${customerCode}")"
        echo "Going to build ./out/${customerCodeInFileName} - ${pdf} - *.pdf"
      done
    else
      customerCodeInFileName="$(getCustomerCodeInFileName "${customerCode}")"
      echo "Going to build ./out/${customerCodeInFileName} - $(stripCustomerCodeFromMainFileName "${customerCode}" "${pdf}") - *.pdf"
    fi
  done
  for pdf in $(getAllMainDocNames) ; do
    customerCode="$(getCustomerCodeOfCustomerSpecificDocument "${pdf}")"
    if [[ "${customerCode}" == "" ]] ; then
      for customerCode in ${customerCodes} ; do
        echo "===================================================================="
        echo "Building ${pdf}"
        bash ./build.sh ${localOption} ${draftOption} ${finalOption} --customer ${customerCode} "${pdf}" || exit $?
      done
    else
      echo "===================================================================="
      echo "Building $(stripCustomerCodeFromMainFileName "${customerCode}" "${pdf}")"
      bash ./build.sh ${localOption} ${draftOption} ${finalOption} --customer ${customerCode} "${pdf}" || exit $?
    fi
  done
}

localOption=""
draftOption=""
finalOption=""
while (($#)) ; do
  if [[ "$1" == "--local" ]] ; then
    localOption="--local"
    echo "Running the build using local TexLive installation"
    shift
  elif [[ "$1" == "--editors-version" ]] ; then
    draftOption="--editors-version"
    echo "Building the editors-version of the document"
    shift
  elif [[ "$1" == "--release-version" ]] ; then
    finalOption="--release-version"
    echo "Building the release-version of the document"
    shift
  else
    echo "ERROR: Unknown option $1"
    exit 1
  fi
done

cleanup() {
    echo "Cleaning stuff up..."
    exit
}
trap cleanup INT TERM
buildThemAll
exit $?
