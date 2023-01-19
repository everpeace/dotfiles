#! /usr/bin/env zsh

export _BACKUP_FILE_DIR=$(realpath "$(dirname "$(echo ${(%):-%N})")/..")
export _KREW_PLUGIN_BACKUP_TXT="${_BACKUP_FILE_DIR}/krew_plugin_backup.txt"
export _ASDF_PLUGIN_BACKUP_TXT="${_BACKUP_FILE_DIR}/asdf_plugin_backup.txt"

function krew_plugin_backup() {
    echo "Backing up krew plugin list to ${_KREW_PLUGIN_BACKUP_TXT}"
    kubectl krew list | tee "${_KREW_PLUGIN_BACKUP_TXT}"
}

function krew_plugin_restore() {
    log "Restoring krew plugin list from ${_KREW_PLUGIN_BACKUP_TXT}"
    if [ -f ${_KREW_PLUGIN_BACKUP_TXT} ]; then
        kubectl krew install < "${_KREW_PLUGIN_BACKUP_TXT}"
    else
        log "Backup file not found: ${_ASDF_PLUGIN_BACKUP_TXT}"
    fi
}

function asdf_plugin_backup() {
    log "Backing up asdf plugin list to ${_ASDF_PLUGIN_BACKUP_TXT}"
    asdf plugin list --urls | tee "${_ASDF_PLUGIN_BACKUP_TXT}"
}

function asdf_plugin_restore() {
    log "Restoring asdf plugin list from ${_ASDF_PLUGIN_BACKUP_TXT}"
    if [ -f ${_ASDF_PLUGIN_BACKUP_TXT} ]; then
        cat "${_ASDF_PLUGIN_BACKUP_TXT}" | xargs -n 2 bash -c 'asdf plugin add $0 $1'
    else 
        log "Backup file not found: ${_ASDF_PLUGIN_BACKUP_TXT}"
    fi
}
