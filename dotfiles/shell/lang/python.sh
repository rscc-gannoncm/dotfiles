#!/bin/bash

# 
# POETRY
# 
export POETRY_HOME="$HOME/.local/poetry/home"
export POETRY_CACHE_DIR="$HOME/.local/poetry/cache"
export POETRY_CONFIG_DIR="$HOME/.local/poetry/config"
export POETRY_DATA_DIR="$HOME/.local/poetry/data"

# 
# UV
# 
UV_PYTHON_VERSIONS=("3.10" "3.11" "3.12")
# UV_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/uv/venv/python"
UV_VENVS_DIR="${HOME}/.local/uv/venvs"
UV_DEFAULT_PYTHON_VER="3.11"
# UV_SHIMS_DIR="$HOME/.local/bin"

# 
# Pyenv (Global Python)
# 
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"

# Function to manage uv-specific Python versions and virtualenvs
use_python() {
  local version="$1"
  local should_link="$2"
  local venv_path="${UV_VENVS_DIR}/${version}"
  
  if [ ! -x "$venv_path/bin/python" ]; then
    echo -e "\nInstalling Python $version via uv..."
    uv venv --python "${version}" "$venv_path"
  fi

  if [ ! -x "$venv_path/bin/pip" ]; then
    echo "Bootstrapping pip for Python $version..."
    "$venv_path/bin/python" -m ensurepip --upgrade

    echo "Upgrading pip, setuptools, wheel for Python $version..."
    "$venv_path/bin/pip3" install --upgrade pip setuptools wheel
  fi
}

# Function to set pyenv global Python version
use_pyenv_python() {
  local version="$1"
  local full_version
  local pyenv_version_dir
  
  # Check if the version is shorthand (e.g., 3.11) and map to a full version
  if [[ "$version" =~ ^[0-9]+\.[0-9]+$ ]]; then
    # Check if a Python version starting with $version exists
    full_version=$(find "$PYENV_ROOT/versions" -maxdepth 1 -type d -name "$version*" | head -n 1)

    if [ -z "$full_version" ]; then
      echo -e "\nNo available Python versions starting with $version."
    fi
    version=$(basename "$full_version")  # Extract the directory name
  fi

  local pyenv_version_dir="$PYENV_ROOT/versions/$version"
  if [ ! -d "$pyenv_version_dir" ]; then
    echo -e "\nPython version $version is not installed, installing..."
    pyenv install "$version"  # Install if not already installed
  fi
  
  # Check if the version is already set globally without calling pyenv global
  if [ "$(cat "$PYENV_ROOT/version")" != "$version" ]; then
    echo -e "\nSetting global Python version to $version..."
    pyenv global "$version"  # Set the global version
  fi
}

# Pre-install missing versions using uv
for version in "${UV_PYTHON_VERSIONS[@]}"; do
  use_python "$version"
done

# Set default Python version for uv
use_python "$UV_DEFAULT_PYTHON_VER" "link"

# Create aliases for switching between local (uv) and global (pyenv) Python versions

# For `uv`-managed Python versions - relevant only for Python projects venvs, NOT GLOBALLY
alias py3.10="use_python 3.10 link && source ${UV_VENVS_DIR}/3.10/bin/activate"
alias py3.11="use_python 3.11 link && source ${UV_VENVS_DIR}/3.11/bin/activate"
alias py3.12="use_python 3.12 link && source ${UV_VENVS_DIR}/3.12/bin/activate"

# For global pyenv-managed Python versions
alias gpy3.10="use_pyenv_python 3.10 && pyenv activate 3.10"
alias gpy3.11="use_pyenv_python 3.11 && pyenv activate 3.11"
alias gpy3.12="use_pyenv_python 3.12 && pyenv activate 3.12"

# Optionally set a default pyenv Python version
use_pyenv_python "3.11"
