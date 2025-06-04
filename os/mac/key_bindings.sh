#!/bin/bash

# Title        macOS customized key binding
# Description  Personalized custom key binding
# Author       Zachi Nachshon <zachi.nachshon@gmail.com>
#==============================================================================

CONFIG_FOLDER_PATH="${HOME}/.config"
MAC_KEYS_LIBRARY_CONFIG_FOLDER="${HOME}/Library/KeyBindings"
MAC_KEYS_CONFIG_FILE_NAME="DefaultKeyBinding.dict"
DOTFILES_REPO_LOCAL_PATH=${DOTFILES_REPO_LOCAL_PATH:-"${CONFIG_FOLDER_PATH}/dotfiles"}

{
  if [[ ! -d "${MAC_KEYS_LIBRARY_CONFIG_FOLDER}" ]]; then
    mkdir -p "${MAC_KEYS_LIBRARY_CONFIG_FOLDER}"
  fi

  cp "${DOTFILES_REPO_LOCAL_PATH}/os/mac/mac_key_bindings/${MAC_KEYS_CONFIG_FILE_NAME}" "${MAC_KEYS_LIBRARY_CONFIG_FOLDER}/${MAC_KEYS_CONFIG_FILE_NAME}"
}
