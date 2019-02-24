#!/bin/bash

echo $HOME
ASEPRITE_DIR="$HOME/Library/Application Support/Aseprite/scripts/"
SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
echo "Linking directory \"$SCRIPTS_DIR\" to \"$ASEPRITE_DIR\""
ln -s "$SCRIPTS_DIR" "$ASEPRITE_DIR"
