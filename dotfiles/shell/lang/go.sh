#!/bin/bash

# Enable goenv in the current shell
eval "$(goenv init -)"

# Versions to install
GOENV_GO_VERSIONS=("1.20.14" "1.21.8" "1.23.7")
GOENV_BASE_PATH="$HOME/.goenv/versions"
GOENV_DEFAULT_GO_VERSION="1.23.7"
GO_SHIMS_DIR="$HOME/.local/bin"

use_go() {
  local version="$1"
  local should_link="$2"
  local go_path="${GOENV_BASE_PATH}/$version"

  # Install Go version if missing
  if [ ! -x "$go_path/bin/go" ]; then
    echo -e "\nInstalling Go $version via goenv..."
    goenv install "$version"
  fi

  if [[ -n "$should_link" ]]; then
    goenv global "$version" >/dev/null

    # Create shims
    ln -sf "$go_path/bin/go" "$GO_SHIMS_DIR/go"
    ln -sf "$go_path/bin/gofmt" "$GO_SHIMS_DIR/gofmt"
    export GOROOT="${go_path}"
  fi
}

# Install versions if needed
for version in "${GOENV_GO_VERSIONS[@]}"; do
  use_go "$version"
done

# Use the default version and link it
use_go "$GOENV_DEFAULT_GO_VERSION" "link"

# Aliases for easy version switching
alias go1.20='use_go 1.20.14 link'
alias go1.21='use_go 1.21.8 link'
alias go1.23='use_go 1.23.7 link'

# Tell Go to use local version instead of auto fetching - defined in VSCode settings as well
export GOTOOLCHAIN=local
export GOPATH=${HOME}/.go
export GOBIN=${GOPATH}/bin # Used to store installed packages binaries
#export GO111MODULE="on" # on/off/auto

alias gop="cd ${GOPATH}/src/github.com"
alias tap="cd ${GOPATH}/src/github.com/wix-private/tapas"