#!/bin/bash

echo "=========================================="
echo "Running SAPOR Analysis"
echo "=========================================="
echo ""

SAPOR_DIR="./sapor-romania"

if [ ! -d "$SAPOR_DIR" ]; then
    echo "ERROR: SAPOR directory not found: $SAPOR_DIR"
    echo "Please run ./generate-sapor-files.sh first"
    exit 1
fi

echo "Processing $(ls -1 $SAPOR_DIR/*.poll 2>/dev/null | wc -l) poll files..."
echo ""

# Find where gem binaries are installed
GEM_BIN_DIR=$(gem environment | grep "EXECUTABLE DIRECTORY" | cut -d: -f2 | xargs)

if [ -x "$GEM_BIN_DIR/sapor" ]; then
    echo "Found SAPOR at: $GEM_BIN_DIR/sapor"
    echo ""
    "$GEM_BIN_DIR/sapor" "$SAPOR_DIR"
else
    echo "Trying to find SAPOR executable..."
    SAPOR_PATH=$(find ~/.gem -name sapor -type f 2>/dev/null | grep bin | head -1)
    if [ -n "$SAPOR_PATH" ]; then
        echo "Found SAPOR at: $SAPOR_PATH"
        echo ""
        "$SAPOR_PATH" "$SAPOR_DIR"
    else
        echo "ERROR: Cannot find SAPOR executable"
        echo "Try running: gem which sapor"
        exit 1
    fi
fi

echo ""
echo "=========================================="
echo "SAPOR Analysis Complete"
echo "=========================================="
