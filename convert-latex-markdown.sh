#!/bin/bash
#
# Tiny little script to convert a given latex file to markdown
#
SCRIPT_DIR="$(cd $(dirname "${BASH_SOURCE[0]}") && pwd -P)"

source="$1"
target="$2"
acronyms="${SCRIPT_DIR}/acronyms.tex"

function replace() {

  (
    set -x
    gsed -i "$1" "${target}"
  )
}

function replaceAcronyms() {

  local acronym
  local replace_with

  while read -r acronym ; do
    replace_with=$(
      gsed -n -e "s@\\\newacronym{${acronym}}{\([^}]*\)}{\([^}]*\)}@\2@p" "${acronyms}"
    )
    if [[ -z "${replace_with}" ]] ; then
      echo "WARNING: Could not find replacement for acronym ${acronym}"
      continue
    fi
    echo "replace ${acronym} with ${replace_with}"
    replace "s@\\\glsfmtlong{${acronym}}@${replace_with}@g"
  done < <(gsed -n -e "s/.*\\\glsfmtlong{\([^}]*\)}.*/\1/p" "${target}")

  while read -r acronym ; do
    replace_with=$(
      gsed -n -e "s@\\\newacronym{${acronym}}{\([^}]*\)}{\([^}]*\)}@\2@p" "${acronyms}"
    )
    if [[ -z "${replace_with}" ]] ; then
      echo "WARNING: Could not find replacement for acronym ${acronym}"
      continue
    fi
    echo "replace ${acronym} with ${replace_with}"
    replace "s@\\\glspl{${acronym}}@${replace_with}s@g"
  done < <(gsed -n -e "s/.*\\glspl{\([^}]*\)}.*/\1/p" "${target}")

  while read -r acronym ; do
    replace_with=$(
      gsed -n -e "s@\\\newacronym{${acronym}}{\([^}]*\)}{\([^}]*\)}@\2@p" "${acronyms}"
    )
    if [[ -z "${replace_with}" ]] ; then
      echo "WARNING: Could not find replacement for acronym ${acronym}"
      continue
    fi
    echo "replace ${acronym} with ${replace_with}"
    replace "s@\\\glsfmtlongpl{${acronym}}@${replace_with}s@g"
  done < <(gsed -n -e "s/.*\\glsfmtlongpl{\([^}]*\)}.*/\1/p" "${target}")

  while read -r acronym ; do
    replace_with=$(
      gsed -n -e "s@\\\newacronym{${acronym}}{\([^}]*\)}{\([^}]*\)}@\2@p" "${acronyms}"
    )
    if [[ -z "${replace_with}" ]] ; then
      echo "WARNING: Could not find replacement for acronym ${acronym}"
      continue
    fi
    echo "replace ${acronym} with ${replace_with}"
    replace "s@\\\Glsfmtlongpl{${acronym}}@${replace_with}s@g"
  done < <(gsed -n -e "s/.*\\Glsfmtlongpl{\([^}]*\)}.*/\1/p" "${target}")

  while read -r acronym ; do
    replace_with=$(
      gsed -n -e "s@\\\newacronym{${acronym}}{\([^}]*\)}{\([^}]*\)}@\2@p" "${acronyms}"
    )
    if [[ -z "${replace_with}" ]] ; then
      echo "WARNING: Could not find replacement for acronym ${acronym}"
      continue
    fi
    echo "replace ${acronym} with ${replace_with}"
    replace "s@\\\glsxtrfull{${acronym}}@${replace_with}s@g"
  done < <(gsed -n -e "s/.*\\glsxtrfull{\([^}]*\)}.*/\1/p" "${target}")

  while read -r acronym ; do
    replace_with=$(
      gsed -n -e "s@\\\newacronym{${acronym}}{\([^}]*\)}{\([^}]*\)}@\2@p" "${acronyms}"
    )
    if [[ -z "${replace_with}" ]] ; then
      echo "WARNING: Could not find replacement for acronym ${acronym}"
      continue
    fi
    echo "replace ${acronym} with ${replace_with}"
    replace "s@\\\glsfirst{${acronym}}@${replace_with}s@g"
  done < <(gsed -n -e "s/.*\\glsfirst{\([^}]*\)}.*/\1/p" "${target}")
}

function replaceStuff() {

  replaceAcronyms || return $?
  replace 's@\\'\''---\\'\''@---@g'
  replace 's@\\,---\\,@---@g'
  replace 's@\\glsfmtshort{\(.*\)}@\\gls{\1}@g'
  replace 's@\\glsfmtshort{\(.*\)}@\\gls{\1}@g'
  replace 's@\\glsxtrshort{\(.*\)}@\\gls{\1}@g'
  replace 's@\\gls{ekg}@EKG@g'
  replace 's@\\gls{ekgmm}@EKG/Maturity@g'
  replace 's@\\gls{ekgprinciples}@EKG/Principles@g'
  replace 's@\\gls{ekgmethod}@EKG/Method@g'
  replace 's@\\stardogcompany@Stardog@g'
  replace 's@\\stardog@Stardog@g'
  replace 's@\\ontotext@Ontotext@g'
  replace 's@\\dataworld@data.world@g'
  replace 's@\\cambridgesemantics@Cambridge Semantics@g'
  replace 's@\\agnos@agnos.ai@g'
  replace 's@\\eccenca@Eccenca@g'
  replace 's@\\gls{ekg:coe}@EKG Center of Excellence@g'
  replace 's@\\glsfirst{ekgmm}@EKG/Maturity@g'

  replace 's@\\chapter{\(.*\)}@# \1@g'
  replace 's@\\section{\(.*\)}@## \1@g'
  replace 's@\\section\*{\(.*\)}@## \1@g'
  replace 's@\\paragraph{\(.*\)}@### \1@g'
  replace 's@\\label{\(.*\)}@@g'
  replace 's@\\index{\(.*\)}@@g'
  replace 's@\\iindex{\(.*\)}@\1@g'
  replace 's@\\href{\([^}]*\)}{\([^}]*\)}@[\2](\1)@g'
  replace 's@\\textit{\([^}]*\)}@_\1_@g'
  replace 's@\\textbf{\([^}]*\)}@**\1**@g'
  replace 's@\\myuline{\([^}]*\)}@<ins>\1</ins>@g'
  replace 's@\\underline{\([^}]*\)}@<ins>\1</ins>@g'
  replace 's@\\enquote{\([^}]*\)}@"\1"@g'
  replace 's@\\texttt{\([^}]*\)}@\`\1\`@g'
  replace 's@\\item @- @g'
  replace '/^\(.*\)\\begin{itemize}$/d'
  replace '/^\(.*\)\\end{itemize}$/d'


}

function main() {

  if [[ ! -f "${acronyms}" ]] ; then
    echo "ERROR: ${acronyms} not found" >&2
    return 1
  fi
  if [[ ! -f "${source}" ]] ; then
    source="${source}.tex"
    if [[ ! -f "${source}" ]] ; then
      echo "ERROR: ${source} not found" >&2
      return 1
    fi
  fi

  if ! command -v gsed ; then
    echo "ERROR: GNU Sed not installed, please use 'brew install gnu-sed'"
    return 1
  fi
  if ! command -v ggrep ; then
    echo "ERROR: GNU Find not installed, please use 'brew install grep'"
    return 1
  fi


  cp -v "${source}" "${target}"

  replaceStuff
  return $?
}
main $@
exit $?
