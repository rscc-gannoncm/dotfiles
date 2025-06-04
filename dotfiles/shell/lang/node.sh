#!/bin/bash

# By using --use-on-cd, it automatically switches Node.js versions when you cd into a directory
# that contains a .node-version or .nvmrc file.
eval "$(fnm env --use-on-cd)"

# Desired Node versions
FNM_DIR="$HOME/.fnm"
FNM_NODE_VERSIONS=("16.14.0" "18.16.1" "20.11.0" "21.7.3" "22.14.0")
FNM_BASE_PATH="$FNM_DIR/node-versions"
FNM_SHIMS_DIR="$HOME/.local/bin"
FNM_DEFAULT_NODE_VER="22.14.0"
FNM_DEFAULT_TYPESCRIPT_VER="5.4.5"
FNM_DEFAULT_TYPESCRIPT_LANG_SERVER_VER="4.3.3"
FNM_DEFAULT_YARN_VER="4.4.0"

use_node() {
  local version="$1"
  local should_link="$2"
  local node_path="${FNM_BASE_PATH}/v$version/installation/bin"

  if [ ! -x "$node_path/node" ]; then
    echo -e "\nInstalling Node.js $version via fnm..."
    fnm install "$version"
    echo -e "\nInstalling Typescript ${FNM_DEFAULT_TYPESCRIPT_VER} via fnm..."
    fnm exec --using "$version" -- npm install -g typescript@"${FNM_DEFAULT_TYPESCRIPT_VER}"
    echo -e "\nInstalling Typescript Language Server ${FNM_DEFAULT_TYPESCRIPT_LANG_SERVER_VER} via fnm..."
    fnm exec --using "$version" -- npm install -g typescript-language-server@"${FNM_DEFAULT_TYPESCRIPT_LANG_SERVER_VER}"
    fnm exec --using "$version" -- npm install -g corepack
    fnm exec --using "$version" -- npm install -g yarn@"${FNM_DEFAULT_YARN_VER}"
    fnm exec --using "$version" -- npm install -g dlx
  fi

  if [[ -n "$should_link" ]]; then
    # Those symlinks are used by Cursor, otherwise it won't identify the node binary
    ln -sf "$node_path/node" "${FNM_SHIMS_DIR}/node"
    ln -sf "$node_path/npm" "${FNM_SHIMS_DIR}/npm"
    ln -sf "$node_path/npx" "${FNM_SHIMS_DIR}/npx"
    # This is needed to defining the global node version using fnm
    fnm use $version --log-level=quiet && corepack enable &>/dev/null
  fi
}

# Install missing versions
for version in "${FNM_NODE_VERSIONS[@]}"; do
  use_node "$version"
done

# Create shims in ~/.local/bin for node, npm, npx
#  - Portable and works in scripts
#  - Need to switch Node versions manually using alias
use_node $FNM_DEFAULT_NODE_VER "link"

# Aliases for Python version selection
alias node18='fnm use 18.16.1 && corepack enable'
alias node20='fnm use 20.11.0 && corepack enable'
alias node21='fnm use 21.7.3 && corepack enable'
alias node22='fnm use 22.14.0 && corepack enable'
