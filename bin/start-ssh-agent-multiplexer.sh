#! /usr/bin/env bash
set -euo pipefail
VERSION=v0.0.2

(
    cd "${HOME}/bin"
    if [ ! -e ssh-agent-multiplexer ]; then
        echo "Downloading ssh-agent-multiplexer to ${HOME}/bin/ssh-agent-multiplexer" 1>&2
        curl -sL "https://github.com/everpeace/ssh-agent-multiplexer/releases/download/${VERSION}/ssh-agent-multiplexer_${VERSION#v}_darwin_arm64.tar.gz" | \
            tar zfx - ssh-agent-multiplexer
    fi
)

gpg-agent || (
    gpgconf --launch gpg-agent && gpg-agent
)
gpg_agent_sock=$(gpgconf --list-dirs agent-ssh-socket)
secretive_sock="${HOME}/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh"
multiplexer_sock="${1}"

mkdir -p "$(dirname "${multiplexer_sock}")"
if [ -e "${multiplexer_sock}" ]; then
    kill "$(pgrep ssh-agent-multiplexer)" >/dev/null 2>&1 || true
    rm "${multiplexer_sock}"
fi

ssh-agent-multiplexer --debug \
    --listen="${multiplexer_sock}" \
    --add-target="${gpg_agent_sock}" \
    --target="${secretive_sock}"
