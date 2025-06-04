#!/bin/bash

export CARGO_HOME="$HOME/.cargo"

# Desired Rust versions
RUSTUP_RUST_VERSIONS=("1.70.0" "1.74.1")
RUSTUP_BASE_PATH="$HOME/.rustup/toolchains"
RUSTUP_DEFAULT_RUST_VERSION="1.74.1"
RUST_SHIMS_DIR="$HOME/.local/bin"

use_rust() {
  local version="$1"
  local should_link="$2"

  local os="$(uname -s | tr '[:upper:]' '[:lower:]')"
  if [[ "$os" == "darwin" ]]; then
    os="apple-darwin"
  fi
  local arch="$(uname -m)"
  if [[ "$arch" == "arm64" ]]; then
    arch="aarch64"
  fi
  local rustc_path="${RUSTUP_BASE_PATH}/${version}-${arch}-${os}/bin/rustc"

  if [ ! -x "$rustc_path" ]; then
    echo -e "\nInstalling Rust $version via rustup..."
    rustup install "$version"
  fi

  if [[ -n "$should_link" ]]; then
    rustup default "$version" >/dev/null 2>&1 

    local bin_path="${RUSTUP_BASE_PATH}/${version}-${arch}-${os}/bin"
    ln -sf "$bin_path/rustc" "$RUST_SHIMS_DIR/rustc"
    ln -sf "$bin_path/cargo" "$RUST_SHIMS_DIR/cargo"
    ln -sf "$bin_path/rustfmt" "$RUST_SHIMS_DIR/rustfmt"
    ln -sf "$bin_path/rustdoc" "$RUST_SHIMS_DIR/rustdoc"
  fi
}

# Install all desired Rust versions if missing
for version in "${RUSTUP_RUST_VERSIONS[@]}"; do
  use_rust "$version"
done

# Set default version
use_rust "$RUSTUP_DEFAULT_RUST_VERSION" "link"

# Aliases for version switching
alias rust1.70='use_rust 1.70.0 link'
alias rust1.74='use_rust 1.74.1 link'
