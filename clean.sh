#!/bin/bash
#
# Clean all temporary files or generated files
#
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"

function getAllMainDocNames() {

  (
    cd "${SCRIPT_DIR}"
    echo -n "$(pwd) ./out "
    for directory in */ ; do
      directory="${directory/\//}" # strips the slash
      if [[ -f "${directory}/${directory}.tex" ]] ; then
        echo -n "${directory} "
      fi
    done
  )
}

function cleanTopLevelDocDirectory() {

  local -r directory="$1"

  (
    cd "${directory}" || return 1

    rm *.{acn,acr,alg,aux,bbl,bcf,blg,fdb_latexmk,fls,glg,glo,gls,glsdefs,glsdef,idx,labelTags,log,odn,old,olg,run.xml,synctex.gz,tdn,tld,tlg,tex.bbl,tex.blg,ilg,ind,ist,tdo,log,out,sta,toc,pdf} >/dev/null 2>&1
    rm -rf .texpadtmp/ >/dev/null 2>&1
  )

  return 0
}

function cleanAll() {

  for topLevelDocDirectory in $(getAllMainDocNames) ; do
    cleanTopLevelDocDirectory "${topLevelDocDirectory}" || return $?
  done

  return 0
}

cleanAll
exit $?



