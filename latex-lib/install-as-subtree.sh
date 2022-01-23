#!/usr/bin/env bash
#
# Installs this repo (latex-lib) as a "git subtree" repo into your own
# LaTeX documentation project repo.
#
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"

prefer_ssh=1
git_bin=""

function checkGit() {

  if ! command -v git >/dev/null 2>&1 ; then
    echo "ERROR: You don't have git in your PATH" >&2
    return 1
  fi
  if [[ ! -f .git/config ]] ; then
    echo "ERROR: You're not in the root directory of your git repo" >&2
    return 1
  fi
  git_bin="$(command -v git 2>/dev/null)"
  #
  # TODO: Add more checks, right git version?
  #
  return 0
}

function _git() {
  (
    set -x
    "${git_bin}" $@
  )
  return $?
}

function getRemoteUrl() {

  local -r remote_name="$1"

  "${git_bin}" remote get-url "${remote_name}" 2>/dev/null
}

function getGithubUrl() {

  local -r remote_org="$1"
  local -r remote_name="$2"
  local -r github_repo="${remote_org}/${remote_name}"

  if ((prefer_ssh)) ; then
    echo "git@github.com:${github_repo}.git"
  else
    echo "https://github.com/${github_repo}.git"
  fi
}

function checkGitRemote() {

  local -r remote_org="$1"
  local -r remote_name="$2"
  local -r remote_url="$3"
  local -r github_url="$(getGithubUrl "${remote_org}" "${remote_name}")"

  [[ "${remote_url}" == "${github_url}" ]] && return 0

  echo "ERROR: Registered url is ${remote_url} whilst preferred url is ${github_url}" >&2

  return 1
}

function addGitRemote() {

  local -r remote_org="$1"
  local -r remote_name="$2"
  local -r github_url="$(getGithubUrl "${remote_org}" "${remote_name}")"

  echo "Add git remote ${remote_name} at ${github_url}" >&2

  _git remote add -f "${remote_name}" "${github_url}" 2>/dev/null || true

  local -r remote_url="$(getRemoteUrl "${remote_name}")"

  if [[ -z "${remote_url}" ]] ; then
    echo "ERROR: Could not fetch the remote url for ${remote_name}"
    return 1
  fi

  echo "Actual remote url registered: ${remote_url}" >&2

  checkGitRemote "${remote_org}" "${remote_name}" "${remote_url}"
}

function getSubTrees() {
  "${git_bin}" log | grep git-subtree-dir | tr -d ' ' | cut -d ":" -f2 | sort | uniq
}

function addSubtree() {

  local -r remote_org="$1"
  local -r remote_name="$2"
  local -r mount_point="$3"
  local -r remote_branch="$4"

  local -r remote_url="$(getRemoteUrl "${remote_name}")"

  if ! checkGitRemote "${remote_org}" "${remote_name}" "${remote_url}" ; then
    addGitRemote "${remote_org}" "${remote_name}" || return $?
  fi

  if getSubTrees | grep -q "${mount_point}" ; then
    echo "Subtree ${mount_point} has already been installed" >&2
    return 0
  fi

  echo "Add subtree ${remote_name}/${remote_branch} at mount point ${mount_point}" >&2

  _git subtree add --prefix="${mount_point}" --squash "${remote_name}/${remote_branch}"
}

function pullLatest() {

  local -r remote_org="$1"
  local -r remote_name="$2"
  local -r mount_point="$3"
  local -r remote_branch="$4"

  addSubtree "$1" "$2" "$3" "$4" || return $?

  echo "Pull Latest ${remote_org}/${remote_name} and mount at ${mount_point}" >&2

  _git fetch "${remote_name}" || return $?
  _git subtree pull --prefix="${mount_point}" "${remote_name}" "${remote_branch}" --squash

  if [[ "${remote_name}" == "latex-lib" ]] ; then
    createSymlinks || return $?
  fi

  return 0
}

# https://unix.stackexchange.com/a/521984
bash_realpath() {
  # print the resolved path
  # @params
  # 1: the path to resolve
  # @return
  # &1: the resolved link path

  local path="${1}"
  while [[ -L ${path} && "$(ls -l "${path}")" =~ -\>\ (.*) ]]
  do
    path="${BASH_REMATCH[1]}"
  done
  echo "${path}"
}

function symlinkToDir() {

  local -r srcDir="$1"
  local -r targetDir="${remote_name}/${2:-$1}"

  if [[ -d "${srcDir}" ]] ; then
    #
    # If the directory already exists then check whether it's a link
    # to the subtree repo
    #
    if [[ -L "${srcDir}" ]] ; then
      local -r realPath="$(bash_realpath "${srcDir}")"
      if [[ "${targetDir}" == "${realPath}" ]] ; then
        echo "${srcDir}/ already links to ${targetDir}/" >&2
        return 0
      fi
      unlink "${srcDir}"
    else
      #
      # So it's not a symlink while it should be. Remove its contents
      #
      echo "Removing ${srcDir} (also from _git), replacing it with link to ${targetDir}" >&2
      _git rm -r "${srcDir}"
      rm -rf "${srcDir}"
    fi
  fi

  if [[ -d "${targetDir}" ]] ; then
    ln -s "${targetDir}" "${srcDir}"
  else
    echo "ERROR: ${targetDir} does not exist" >&2
    return 1
  fi

  return 0
}

function symlinkToFile() {

  local -r srcFile="$1"
  local -r targetFile="${remote_name}/${2:-$1}"

  if [[ -f "${srcFile}" ]] ; then
    #
    # If the file already exists then check whether it's a link
    # to the subtree repo
    #
    if [[ -L "${srcFile}" ]] ; then
      local -r realFile="$(bash_realpath "${srcFile}")"
      if [[ "${targetFile}" == "${realFile}" ]] ; then
        echo "${srcFile} already links to ${targetFile}" >&2
        return 0
      fi
      unlink "${srcFile}"
    else
      #
      # So it's not a symlink while it should be. Remove it
      #
      echo "Removing ${srcFile} (also from _git), replacing it with link to ${targetFile}" >&2
      _git rm "${srcFile}"
      rm -f "${srcFile}"
    fi
  fi

  if [[ -f "${targetFile}" ]] ; then
    ln -s "${targetFile}" "${srcFile}"
  else
    echo "ERROR: ${targetFile} does not exist" >&2
    return 1
  fi

  return 0
}

function createSymlinks() {

  echo "Create symlinks"

  symlinkToDir etc || return $?
  symlinkToFile .actrc || return $?
  symlinkToFile .env || return $?
  symlinkToFile .latexmkrc || return $?
  symlinkToFile act.sh || return $?
  symlinkToFile build.sh || return $?
  symlinkToFile build-all.sh || return $?
  symlinkToFile clean.sh || return $?
  symlinkToFile acronyms.tex || return $?
  symlinkToFile bibliography.bib || return $?
  symlinkToFile glossary-concepts.tex || return $?
  symlinkToFile glossary-main.tex || return $?
  symlinkToFile glossary-ekg.tex || return $?
  symlinkToFile glossary-ontologies.tex || return $?

  return 0
}

function main() {

  local remote_org
  local remote_name
  local remote_branch

  checkGit || return $?

  for mount_point in $(getSubTrees) ; do
    echo "sub tree: ${mount_point}" >&2
  done

  for mount_point in $(getSubTrees) ; do
    remote_name=${mount_point/mnt\//}
    remote_branch="main"
    remote_org="EKGF"
    [[ "${remote_name}" == "latex-lib" ]] && remote_org="agnos-ai"
    pullLatest "${remote_org}" "${remote_name}" "${mount_point}" "${remote_branch}" || return $?
  done

  return 0
}

main $@
exit $?
