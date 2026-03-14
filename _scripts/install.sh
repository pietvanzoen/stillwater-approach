#!/bin/bash
set -euo pipefail

OS=$(uname -s)

if [ "$OS" = "Darwin" ]; then
  echo "Installing via Homebrew..."
  brew install lua@5.4 luarocks stylua jq
  luarocks install luacheck
  luarocks install busted

elif [ "$OS" = "Linux" ]; then
  echo "Installing via apt + luarocks..."
  apt-get install -y lua5.4 luarocks curl jq unzip
  luarocks install luacheck
  luarocks install busted

  if ! command -v stylua >/dev/null 2>&1; then
    curl -sL "https://github.com/JohnnyMorganz/StyLua/releases/download/v2.4.0/stylua-linux-x86_64.zip" \
      -o /tmp/stylua.zip
    if [ "$(id -u)" = "0" ]; then
      STYLUA_BIN=/usr/local/bin
    else
      STYLUA_BIN=$HOME/.local/bin
      mkdir -p "$STYLUA_BIN"
    fi
    unzip -o /tmp/stylua.zip -d "$STYLUA_BIN" stylua
    chmod +x "$STYLUA_BIN/stylua"
    rm /tmp/stylua.zip
    echo "stylua installed to $STYLUA_BIN — ensure it is in your PATH"
  fi

else
  echo "Unsupported OS: $OS"
  exit 1
fi
