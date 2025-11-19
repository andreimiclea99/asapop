#!/bin/bash
# macOS Maven DNS Fix - Download dependencies manually then build offline

set -e

echo "=========================================="
echo "macOS Maven DNS Workaround"
echo "=========================================="
echo ""

# Create Maven local repository structure
MAVEN_REPO="$HOME/.m2/repository"

echo "Step 1: Downloading project dependencies manually..."
echo "----------------------------------------------"

# Download kolektoj 1.0
echo "Downloading kolektoj-1.0..."
mkdir -p "$MAVEN_REPO/net/filipvanlaenen/kolektoj/1.0"
curl -L -o "$MAVEN_REPO/net/filipvanlaenen/kolektoj/1.0/kolektoj-1.0.jar" \
  "https://storage.googleapis.com/fvl-mvn-repo/repo/net/filipvanlaenen/kolektoj/1.0/kolektoj-1.0.jar"
curl -L -o "$MAVEN_REPO/net/filipvanlaenen/kolektoj/1.0/kolektoj-1.0.pom" \
  "https://storage.googleapis.com/fvl-mvn-repo/repo/net/filipvanlaenen/kolektoj/1.0/kolektoj-1.0.pom"

# Download nombrajkolektoj 1.0
echo "Downloading nombrajkolektoj-1.0..."
mkdir -p "$MAVEN_REPO/net/filipvanlaenen/nombrajkolektoj/1.0"
curl -L -o "$MAVEN_REPO/net/filipvanlaenen/nombrajkolektoj/1.0/nombrajkolektoj-1.0.jar" \
  "https://storage.googleapis.com/fvl-mvn-repo/repo/net/filipvanlaenen/nombrajkolektoj/1.0/nombrajkolektoj-1.0.jar"
curl -L -o "$MAVEN_REPO/net/filipvanlaenen/nombrajkolektoj/1.0/nombrajkolektoj-1.0.pom" \
  "https://storage.googleapis.com/fvl-mvn-repo/repo/net/filipvanlaenen/nombrajkolektoj/1.0/nombrajkolektoj-1.0.pom"

# Download laconic 1.2.0
echo "Downloading laconic-1.2.0..."
mkdir -p "$MAVEN_REPO/net/filipvanlaenen/laconic/1.2.0"
curl -L -o "$MAVEN_REPO/net/filipvanlaenen/laconic/1.2.0/laconic-1.2.0.jar" \
  "https://storage.googleapis.com/fvl-mvn-repo/repo/net/filipvanlaenen/laconic/1.2.0/laconic-1.2.0.jar"
curl -L -o "$MAVEN_REPO/net/filipvanlaenen/laconic/1.2.0/laconic-1.2.0.pom" \
  "https://storage.googleapis.com/fvl-mvn-repo/repo/net/filipvanlaenen/laconic/1.2.0/laconic-1.2.0.pom"

# Download tsvgj 1.0.0
echo "Downloading tsvgj-1.0.0..."
mkdir -p "$MAVEN_REPO/net/filipvanlaenen/tsvgj/1.0.0"
curl -L -o "$MAVEN_REPO/net/filipvanlaenen/tsvgj/1.0.0/tsvgj-1.0.0.jar" \
  "https://storage.googleapis.com/fvl-mvn-repo/repo/net/filipvanlaenen/tsvgj/1.0.0/tsvgj-1.0.0.jar"
curl -L -o "$MAVEN_REPO/net/filipvanlaenen/tsvgj/1.0.0/tsvgj-1.0.0.pom" \
  "https://storage.googleapis.com/fvl-mvn-repo/repo/net/filipvanlaenen/tsvgj/1.0.0/tsvgj-1.0.0.pom"

# Download txhtmlj 1.0.0
echo "Downloading txhtmlj-1.0.0..."
mkdir -p "$MAVEN_REPO/net/filipvanlaenen/txhtmlj/1.0.0"
curl -L -o "$MAVEN_REPO/net/filipvanlaenen/txhtmlj/1.0.0/txhtmlj-1.0.0.jar" \
  "https://storage.googleapis.com/fvl-mvn-repo/repo/net/filipvanlaenen/txhtmlj/1.0.0/txhtmlj-1.0.0.jar"
curl -L -o "$MAVEN_REPO/net/filipvanlaenen/txhtmlj/1.0.0/txhtmlj-1.0.0.pom" \
  "https://storage.googleapis.com/fvl-mvn-repo/repo/net/filipvanlaenen/txhtmlj/1.0.0/txhtmlj-1.0.0.pom"

# Download jackson-dataformat-yaml 2.13.1
echo "Downloading jackson-dataformat-yaml-2.13.1..."
mkdir -p "$MAVEN_REPO/com/fasterxml/jackson/dataformat/jackson-dataformat-yaml/2.13.1"
curl -L -o "$MAVEN_REPO/com/fasterxml/jackson/dataformat/jackson-dataformat-yaml/2.13.1/jackson-dataformat-yaml-2.13.1.jar" \
  "https://repo1.maven.org/maven2/com/fasterxml/jackson/dataformat/jackson-dataformat-yaml/2.13.1/jackson-dataformat-yaml-2.13.1.jar" 2>/dev/null || \
curl -L -o "$MAVEN_REPO/com/fasterxml/jackson/dataformat/jackson-dataformat-yaml/2.13.1/jackson-dataformat-yaml-2.13.1.jar" \
  "https://repo.maven.apache.org/maven2/com/fasterxml/jackson/dataformat/jackson-dataformat-yaml/2.13.1/jackson-dataformat-yaml-2.13.1.jar"

echo ""
echo "Step 2: Building project OFFLINE (using downloaded dependencies)..."
echo "----------------------------------------------"

# Try to build offline
mvn clean compile assembly:single -o -DskipTests

echo ""
echo "=========================================="
echo "Build Complete!"
echo "=========================================="
echo ""
echo "JAR file location:"
ls -lh target/asapop-1.0-SNAPSHOT-jar-with-dependencies.jar
echo ""
echo "Next steps:"
echo "  ./build-romania-website.sh"
echo ""
