#!/bin/bash

# 
# SDKMAN
# 
export SDKMAN_DIR="$HOME/.local/sdkman"

if [[ ! -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]]; then
  echo -e "\nSDKMAN not found. Installing..."
  rm -rf "$SDKMAN_DIR"
  curl -s "https://get.sdkman.io?rcupdate=false" | bash
fi
source "$SDKMAN_DIR/bin/sdkman-init.sh"

# Desired Scala version
SDKMAN_SCALA_VERSION=("2.13.12")
SDKMAN_SCALA_BASE_PATH="${SDKMAN_DIR}/candidates/scala"
SDKMAN_DEFAULT_SCALA_VER="2.13.12"
SCALA_SHIMS_DIR="$HOME/.local/bin"

use_scala() {
  local version="$1"
  local should_link="$2"
  local scala_path="${SDKMAN_SCALA_BASE_PATH}/$version"

  if [ ! -x "$scala_path/bin/scala" ]; then
    echo -e "\nInstalling Scala $version via SDKMAN!..."
    sdk install scala "$version"
  fi

  if [[ -n "$should_link" ]]; then
    sdk use scala "$version" >/dev/null

    local scala_bin_path="${scala_path}/bin"
    ln -sf "$scala_bin_path/scala" "$SCALA_SHIMS_DIR/scala"
    ln -sf "$scala_bin_path/scalac" "$SCALA_SHIMS_DIR/scalac"
  fi
}

# Install all desired Scala versions if missing
for version in "${SDKMAN_SCALA_VERSION[@]}"; do
  use_scala "$version"
done

# Setup Scala
use_scala "$SDKMAN_DEFAULT_SCALA_VER" "link"

# Aliases for version switching
alias scala213='use_scala 2.13.12 link'
