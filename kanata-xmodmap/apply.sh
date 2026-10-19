#!/bin/sh
# Apply the symbol layer xmodmap config.
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
xmodmap "$SCRIPT_DIR/.Xmodmap"
