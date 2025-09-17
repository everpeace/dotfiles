#! /usr/bin/env bash
set -xeuo pipefail
VERSION=v0.2.0

(
    cd "${HOME}/bin"
    if [ ! -e ssh-agent-multiplexer ] || ./ssh-agent-multiplexer --version | grep -v ${VERSION#v}; then
        echo "Downloading ssh-agent-multiplexer to ${HOME}/bin/ssh-agent-multiplexer" 1>&2
        curl -sL "https://github.com/everpeace/ssh-agent-multiplexer/releases/download/${VERSION}/ssh-agent-multiplexer_${VERSION#v}_darwin_arm64.tar.gz" | \
            tar zfx - ssh-agent-multiplexer ssh-agent-mux-select
    fi
)

# gpg-agent || (
#     gpgconf --launch gpg-agent && gpg-agent
# )
# gpg_agent_sock=$(gpgconf --list-dirs agent-ssh-socket)

set +u
[ -z "$SSH_AUTH_SOCK" ] && eval "$(ssh-agent)"
set -u
secretive_sock="${HOME}/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh"
bitwarden_sock="${HOME}/Library/Containers/com.bitwarden.desktop/Data/.bitwarden-ssh-agent.sock"
multiplexer_sock="${1}"

mkdir -p "$(dirname "${multiplexer_sock}")"
if [ -e "${multiplexer_sock}" ]; then
    kill "$(pgrep ssh-agent-multiplexer)" >/dev/null 2>&1 || true
    rm "${multiplexer_sock}"
fi

conf="${HOME}/Library/Application Support/ssh-agent-multiplexer/config.toml"
mkdir -p "$(dirname "${conf}")"
cat << EOF > "${conf}"
debug = true
listen = "${multiplexer_sock}"
add_targets = [
    "${SSH_AUTH_SOCK}"
]
targets = [
    "${bitwarden_sock}",
    "${secretive_sock}"
]
EOF

"${HOME}/bin/ssh-agent-multiplexer"