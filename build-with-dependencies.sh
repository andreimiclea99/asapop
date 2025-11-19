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
# Checkout commit before the breaking API change (Nov 7, 2025)
# Commit 924f412 added OrderedCollection getValues() which conflicts with nombrajkolektoj
git checkout d92a3b9
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
