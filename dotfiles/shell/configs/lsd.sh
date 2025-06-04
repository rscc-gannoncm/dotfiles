#!/bin/bash

# Load LSD settings (https://github.com/Peltoche/lsd)
if [[ -e ${DOTFILES_REPO_LOCAL_PATH} ]]; then
  # DOTFILES_REPO_LOCAL_PATH is exported from reload_session.sh
  export LSD_CONFIG_PATH="${DOTFILES_REPO_LOCAL_PATH}/dotfiles/configs/lsd_config.yaml"
  lsd --config-file "${LSD_CONFIG_PATH}" > /dev/null
  alias l="lsd --config-file "${LSD_CONFIG_PATH}" -lAhtrF --sort size --group-dirs first"
  # alias l="lsd --config-file "${LSD_CONFIG_PATH}" -lah"
fi