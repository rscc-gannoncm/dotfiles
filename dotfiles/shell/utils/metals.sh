#!/bin/bash

# Set the custom Coursier installation directory
COURSIER_HOME="$HOME/Library/Application Support/Coursier"
CS_BINARY_PATH="${COURSIER_HOME}/bin/cs"
METALS_BINARY_PATH="${COURSIER_HOME}/bin/metals"
METALS_SHIMS_DIR="$HOME/.local/bin"

install_coursier() {
  local os="$(uname -s | tr '[:upper:]' '[:lower:]')"
  if [[ "$os" == "darwin" ]]; then
    os="apple-darwin"
  fi
  local arch="$(uname -m)"
  if [[ "$arch" == "arm64" ]]; then
    arch="aarch64"
  fi

  echo -e "\n📦 Installing Coursier (Scala related)..."

  cwd=$(pwd)
  temp_dir=$(mktemp -d)
  cd "$temp_dir" || exit 1

  echo "⬇️ Downloading Coursier launcher..."
  curl -fLo cs.gz https://github.com/coursier/launchers/raw/master/cs-${arch}-${os}.gz

  echo "📂 Extracting..."
  gunzip cs.gz
  chmod +x cs

  # Set the environment variable to prevent modifying shell rc files
  export COURSIER_NO_SETUP=true

  echo "⚙️ Running setup..."
  ./cs setup

  echo "🧹 Cleaning up..."
  rm -rf "$temp_dir"
  cd "${cwd}" || exit 1
  echo "✅ Coursier installation complete. You can run it using: cs"
}

# Check if coursier is available
if [ ! -d "$COURSIER_HOME" ]; then
  install_coursier
fi

# Check if metals is already available
if [ ! -f "$METALS_BINARY_PATH" ]; then
  # Install metals via coursier
  echo -e "\nInstalling Metals..."
  "${CS_BINARY_PATH}" install metals

  if [ ! -f "${METALS_SHIMS_DIR}/metals" ]; then
    echo "Linking Metals to ~/.local/bin..."
    ln -s "${METALS_BINARY_PATH}" "$METALS_SHIMS_DIR/metals"
    echo "✅ Metals installation complete. You can run it using: metals"
  fi
fi
