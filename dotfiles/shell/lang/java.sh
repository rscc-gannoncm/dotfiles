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

# Desired Java versions
SDKMAN_JAVA_VERSIONS=("17.0.10-tem" "21.0.2-tem")
SDKMAN_JAVA_BASE_PATH="${SDKMAN_DIR}/candidates/java"
SDKMAN_DEFAULT_JAVA_VER="21.0.2-tem"
JAVA_SHIMS_DIR="$HOME/.local/bin"

use_java() {
  local version="$1"
  local should_link="$2"
  local java_path="${SDKMAN_JAVA_BASE_PATH}/$version"

  if [ ! -x "$java_path/bin/java" ]; then
    echo -e "\nInstalling Java $version via SDKMAN!..."
    sdk install java "$version"
  fi

  if [[ -n "$should_link" ]]; then
    # echo "Switching to Java $version..."
    sdk use java "$version" >/dev/null

    # Create shims
    local java_bin_path="${SDKMAN_JAVA_BASE_PATH}/$version/bin"
    ln -sf "$java_bin_path/java" "$JAVA_SHIMS_DIR/java"
    ln -sf "$java_bin_path/javac" "$JAVA_SHIMS_DIR/javac"
    ln -sf "$java_bin_path/jar" "$JAVA_SHIMS_DIR/jar"
  fi
}

# Install all desired Java versions if missing
for version in "${SDKMAN_JAVA_VERSIONS[@]}"; do
  use_java "$version"
done

# Use the default version and set shims
use_java "$SDKMAN_DEFAULT_JAVA_VER" "link"

# Aliases for Java version selection
alias java17='use_java 17.0.10-tem link'
alias java21='use_java 21.0.2-tem link'
