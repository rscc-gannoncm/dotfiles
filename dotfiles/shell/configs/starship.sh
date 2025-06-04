#!/bin/bash

# Load Starship settings (https://github.com/starship/starship)
if [[ -e ${DOTFILES_REPO_LOCAL_PATH} ]]; then
  # DOTFILES_REPO_LOCAL_PATH is exported from reload_session.sh
  export STARSHIP_CONFIG="${DOTFILES_REPO_LOCAL_PATH}/dotfiles/configs/starship.toml"
  eval "$(starship init zsh)"
fi