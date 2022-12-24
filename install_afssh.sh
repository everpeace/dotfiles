#! /usr/bin/env bash
set -eu -o pipefail

AFSSH_REPO="git://git.tiwe.de/ssh-agent-filter.git"
AFSSH_TAG="0.5.2"

BREW_PREFIX="$(brew --prefix)"
SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
REPO_DIR="${SCRIPT_DIR}/ssh-agent-filter"

(
  [ -d "${REPO_DIR}" ] || git clone "${AFSSH_REPO}" "${REPO_DIR}"
  echo "Entering ${REPO_DIR}"
  cd "${REPO_DIR}"
  git checkout $AFSSH_TAG
  brew install boost nettle # install depenencies
  make ssh-agent-filter \
    LDFLAGS="-L${BREW_PREFIX}/lib" \
    CPPFLAGS="-I${BREW_PREFIX}/include"
  echo "Copying {ssh-agent-filter,afssh} to ${SCRIPT_DIR}/bin/"
  cp {ssh-agent-filter,afssh} "${SCRIPT_DIR}/bin/"
)
