#!/bin/bash
# Build ASAPOP dependencies from source then build main project

set -e

echo "=========================================="
echo "Building ASAPOP Dependencies from Source"
echo "=========================================="
echo ""

TEMP_DIR=$(mktemp -d)
echo "Working in: $TEMP_DIR"
cd "$TEMP_DIR"

# Build kolektoj
echo "Step 1: Building kolektoj..."
echo "-------------------------------"
git clone https://github.com/filipvanlaenen/kolektoj.git
cd kolektoj
# Checkout commit from Sept 23, 2025 (compatible with nombrajkolektoj from Sept 26)
# Later commits in Nov 2025 have breaking API changes
git checkout 657cc5c
mvn clean install -DskipTests
cd ..

# Build nombrajkolektoj
echo ""
echo "Step 2: Building nombrajkolektoj..."
echo "------------------------------------"
git clone https://github.com/filipvanlaenen/nombrajkolektoj.git
cd nombrajkolektoj
mvn clean install -DskipTests
cd ..

echo ""
echo "Step 3: Dependencies built and installed to ~/.m2/repository"
echo "=============================================================="
echo ""

# Now build asapop
echo "Step 4: Building asapop..."
echo "---------------------------"
cd ~/Desktop/asapop  # Adjust this path to your actual asapop location
mvn clean compile assembly:single

echo ""
echo "=========================================="
echo "Build Complete!"
echo "=========================================="
echo ""
echo "JAR file location:"
ls -lh target/asapop-1.0-SNAPSHOT-jar-with-dependencies.jar
echo ""
echo "Cleanup temporary directory:"
echo "  rm -rf $TEMP_DIR"
echo ""
