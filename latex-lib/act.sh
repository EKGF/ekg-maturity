#!/usr/bin/env bash
#
# run the act utility (which runs the Github Actions in the .github directory locally)
#
# Mac OS X:
# - Install "act" with "brew install act"
#
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"

act_bin=""

function checkAct() {

  local linux_image="ghcr.io/catthehacker/ubuntu:full-latest"

  cd "${SCRIPT_DIR}" || return $?

  echo "========================== check environment"

  dockr image pull "${linux_image}"

  echo "-P ubuntu-latest=${linux_image}" > "${SCRIPT_DIR}/.actrc"

  act_bin="$(command -v act)"

  return 0
}

function execAct() {

  echo "Jobs: (use --job <job name> to select just one of these)"
  "${act_bin}" -l

  # shellcheck disable=SC2068
  set -x
  # shellcheck disable=SC2068
  exec "${act_bin}" $@

}

checkAct || exit 1
# shellcheck disable=SC2068
execAct $@
exit $?
