#!/bin/bash

# Title        Cursor settings and key-bindings
# Description  Symlink Cursor settings and key-bindings to become managed by this dotfiles repo
# Author       Zachi Nachshon <zachi.nachshon@gmail.com>
#==============================================================================

# To get a list of Cursor extension: cursor --list-extensions

CONFIG_FOLDER_PATH="${HOME}/.config"
CURSOR_AGENT_HOME="${HOME}/.cursor"
CUROSR_CONFIG_FOLDER_PATH="${HOME}/Library/Application Support/Cursor/User"
CURSOR_SETTINGS_FILE_NAME="settings.json"
CURSOR_KEYBINDINGS_FILE_NAME="keybindings.json"
CURSOR_PROJECTS_FILE_NAME="projects.json"
CURSOR_EXTENSIONS_LIST_FILE_NAME="extensions_list.txt"
DOTFILES_REPO_LOCAL_PATH=${DOTFILES_REPO_LOCAL_PATH:-"${CONFIG_FOLDER_PATH}/dotfiles"}

{
  if [[ ! -d "${CUROSR_CONFIG_FOLDER_PATH}" ]]; then
    mkdir -p "${CUROSR_CONFIG_FOLDER_PATH}"
  fi

  ln -sfn "${DOTFILES_REPO_LOCAL_PATH}/os/mac/cursor/vscode/${CURSOR_SETTINGS_FILE_NAME}" "${CUROSR_CONFIG_FOLDER_PATH}/${CURSOR_SETTINGS_FILE_NAME}"
  ln -sfn "${DOTFILES_REPO_LOCAL_PATH}/os/mac/cursor/vscode/${CURSOR_KEYBINDINGS_FILE_NAME}" "${CUROSR_CONFIG_FOLDER_PATH}/${CURSOR_KEYBINDINGS_FILE_NAME}"
  ln -sfn "${DOTFILES_REPO_LOCAL_PATH}/os/mac/cursor/vscode/alefragnani.project-manager/${CURSOR_PROJECTS_FILE_NAME}" "${CUROSR_CONFIG_FOLDER_PATH}/globalStorage/alefragnani.project-manager/${CURSOR_PROJECTS_FILE_NAME}"

  for file in "${DOTFILES_REPO_LOCAL_PATH}/os/mac/cursor/agent/"*; do
    ln -sfn "$file" "${CURSOR_AGENT_HOME}/$(basename "$file")"
  done

  # Install Cursor extensions
  cat "${DOTFILES_REPO_LOCAL_PATH}/os/mac/cursor/vscode/${CURSOR_EXTENSIONS_LIST_FILE_NAME}" | xargs -n 1 cursor --install-extension > /dev/null 2>&1
}
