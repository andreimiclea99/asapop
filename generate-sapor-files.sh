#!/bin/bash

echo "=========================================="
echo "ASAPOP - Generate SAPOR Files for Romania"
echo "=========================================="
echo ""

# Configuration
ROPF_FILE="ro.ropf"
SAPOR_DIR="./sapor-romania"
SAPOR_CONFIG="sapor-configuration.yaml"
JAR_FILE="target/asapop-1.0-SNAPSHOT-jar-with-dependencies.jar"

# Check if JAR exists
if [ ! -f "$JAR_FILE" ]; then
    echo "ERROR: JAR file not found: $JAR_FILE"
    echo "Please run: mvn clean compile assembly:single"
    exit 1
fi

# Check if ROPF file exists
if [ ! -f "$ROPF_FILE" ]; then
    echo "ERROR: ROPF file not found: $ROPF_FILE"
    exit 1
fi

# Check if SAPOR config exists
if [ ! -f "$SAPOR_CONFIG" ]; then
    echo "ERROR: SAPOR configuration not found: $SAPOR_CONFIG"
    exit 1
fi

# Create SAPOR directory if it doesn't exist
mkdir -p "$SAPOR_DIR"

echo "Generating SAPOR files..."
echo "Command:"
echo "  java -jar $JAR_FILE \\"
echo "    provide $ROPF_FILE $SAPOR_DIR $SAPOR_CONFIG"
echo ""

java -jar "$JAR_FILE" \
  provide \
  "$ROPF_FILE" \
  "$SAPOR_DIR" \
  "$SAPOR_CONFIG"

echo ""
echo "=========================================="
echo "SAPOR Files Generated!"
echo "=========================================="
echo ""
echo "Output directory: $SAPOR_DIR"
echo ""
echo "To view generated files:"
echo "  ls -la $SAPOR_DIR"
echo ""
echo "Next steps:"
echo "  1. Install SAPOR (Ruby gem): gem install sapor"
echo "  2. Run SAPOR on the generated files"
echo ""
