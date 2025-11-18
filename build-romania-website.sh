#!/bin/bash
# Script to build the Romania opinion polls website with graphs and visualizations

set -e  # Exit on error

echo "=========================================="
echo "ASAPOP - Build Romania Website"
echo "=========================================="
echo ""

# Define directories
SITE_DIR="./romania-website"
ROPF_DIR="./ropf-files"
CONFIG_FILE="./romania-website-config.yaml"
CUSTOM_CSS="./custom.css"
JAR_FILE="./target/asapop-1.0-SNAPSHOT-jar-with-dependencies.jar"

# Check if JAR exists
if [ ! -f "$JAR_FILE" ]; then
    echo "JAR file not found. Building project first..."
    mvn clean compile assembly:single
    echo ""
fi

# Create site directory
echo "Creating website directory: $SITE_DIR"
mkdir -p "$SITE_DIR"
echo ""

# Build the website
echo "Building website with graphs and visualizations..."
echo "Command:"
echo "  java -jar $JAR_FILE \\"
echo "    build $SITE_DIR $CONFIG_FILE $ROPF_DIR $CUSTOM_CSS"
echo ""

java -jar "$JAR_FILE" \
  build \
  "$SITE_DIR" \
  "$CONFIG_FILE" \
  "$ROPF_DIR" \
  "$CUSTOM_CSS"

echo ""
echo "=========================================="
echo "Website built successfully!"
echo "=========================================="
echo ""
echo "Output directory: $SITE_DIR"
echo ""
echo "Generated files:"
echo "  - index.html              (Main index page)"
echo "  - calendar.html           (Electoral calendar)"
echo "  - statistics.html         (Statistics with pie charts)"
echo "  - csv.html                (CSV files listing)"
echo "  - ro.html                 (Romania opinion polls page)"
echo "  - ro.csv                  (Romania polls data in CSV)"
echo "  - _widgets/               (Embeddable widgets)"
echo "  - *.js, *.css             (Scripts and styles)"
echo ""
echo "To view the website:"
echo "  1. Open $SITE_DIR/index.html in a browser"
echo "  2. Or serve with: python3 -m http.server --directory $SITE_DIR 8000"
echo "     Then visit: http://localhost:8000"
echo ""
echo "Charts and graphs are in:"
echo "  - statistics.html (pie charts showing poll statistics)"
echo "  - ro.html (tables with poll results)"
echo ""
