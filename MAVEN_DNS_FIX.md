# Maven DNS Resolution Issue - Solutions

## Problem

Maven cannot resolve `repo.maven.apache.org` even though curl can reach it:

```
✅ curl: HTTP 200 (working)
❌ Maven: "Temporary failure in name resolution" (failing)
```

## Root Cause

Maven (via Java) uses a different DNS resolution mechanism than curl, which can cause issues with:
- IPv6 vs IPv4
- Java's DNS caching
- Network interfaces
- VPN or firewall configurations

## Solutions (Try in Order)

### Solution 1: Force IPv4

Maven might be trying IPv6 when only IPv4 works:

```bash
export MAVEN_OPTS="-Djava.net.preferIPv4Stack=true"
mvn clean compile assembly:single
```

Or add to your shell profile (~/.zshrc or ~/.bashrc):
```bash
export MAVEN_OPTS="-Djava.net.preferIPv4Stack=true"
```

### Solution 2: Clear ALL Maven Cache

```bash
# Remove entire Maven cache
rm -rf ~/.m2/repository

# Try build again
mvn clean compile assembly:single
```

### Solution 3: Use Maven Central Mirror

Create `~/.m2/settings.xml`:

```xml
<settings>
  <mirrors>
    <mirror>
      <id>central-mirror</id>
      <mirrorOf>central</mirrorOf>
      <url>https://repo1.maven.org/maven2</url>
    </mirror>
  </mirrors>
</settings>
```

Then rebuild:
```bash
mvn clean compile assembly:single
```

### Solution 4: Check DNS

```bash
# Test DNS resolution
nslookup repo.maven.apache.org

# If fails, try Google DNS
sudo networksetup -setdnsservers Wi-Fi 8.8.8.8 8.8.4.4

# Then try Maven again
mvn clean compile assembly:single
```

### Solution 5: Disable IPv6 for Java

```bash
mvn clean compile assembly:single \
  -Djava.net.preferIPv4Stack=true \
  -Djava.net.preferIPv6Addresses=false
```

### Solution 6: Use HTTP Instead of HTTPS (Last Resort)

Edit `pom.xml` repositories section (line 67-73):

```xml
<repositories>
  <repository>
    <id>fvl-mvn-repo</id>
    <name>fvl-mvn-repo</name>
    <url>http://storage.googleapis.com/fvl-mvn-repo/repo/</url>
  </repository>
  <repository>
    <id>central</id>
    <url>http://repo1.maven.org/maven2</url>
  </repository>
</repositories>
```

### Solution 7: Bypass Maven - Download Manually

If Maven still fails, download dependencies manually:

```bash
# Create directory structure
mkdir -p ~/.m2/repository/net/filipvanlaenen/kolektoj/1.0
mkdir -p ~/.m2/repository/net/filipvanlaenen/nombrajkolektoj/1.0

# Download kolektoj
curl -o ~/.m2/repository/net/filipvanlaenen/kolektoj/1.0/kolektoj-1.0.jar \
  https://storage.googleapis.com/fvl-mvn-repo/repo/net/filipvanlaenen/kolektoj/1.0/kolektoj-1.0.jar

curl -o ~/.m2/repository/net/filipvanlaenen/kolektoj/1.0/kolektoj-1.0.pom \
  https://storage.googleapis.com/fvl-mvn-repo/repo/net/filipvanlaenen/kolektoj/1.0/kolektoj-1.0.pom

# Download nombrajkolektoj
curl -o ~/.m2/repository/net/filipvanlaenen/nombrajkolektoj/1.0/nombrajkolektoj-1.0.jar \
  https://storage.googleapis.com/fvl-mvn-repo/repo/net/filipvanlaenen/nombrajkolektoj/1.0/nombrajkolektoj-1.0.jar

curl -o ~/.m2/repository/net/filipvanlaenen/nombrajkolektoj/1.0/nombrajkolektoj-1.0.pom \
  https://storage.googleapis.com/fvl-mvn-repo/repo/net/filipvanlaenen/nombrajkolektoj/1.0/nombrajkolektoj-1.0.pom

# Now try building offline
mvn clean compile assembly:single -o
```

## Quick Diagnostic

Run this to diagnose the issue:

```bash
echo "=== DNS Test ==="
nslookup repo.maven.apache.org

echo -e "\n=== Curl Test ==="
curl -I https://repo.maven.apache.org/maven2/

echo -e "\n=== Java Network Properties ==="
java -XshowSettings:properties 2>&1 | grep -i network

echo -e "\n=== Maven Version ==="
mvn -version
```

## What I Fixed

I already fixed the POM file to use release versions instead of non-existent SNAPSHOT versions:

- ✅ Changed `kolektoj` from `1.0-SNAPSHOT` → `1.0`
- ✅ Changed `nombrajkolektoj` from `1.0-SNAPSHOT` → `1.0`

This fix is committed and pushed to your branch.

## Most Likely Solution

Based on the symptoms, **Solution 1 (Force IPv4)** is most likely to work:

```bash
export MAVEN_OPTS="-Djava.net.preferIPv4Stack=true"
mvn clean compile assembly:single
```

## If Nothing Works

The project has complex dependencies. As a last resort:

1. **Clone the original upstream repository** (if it exists publicly)
2. **Check if they have pre-built releases** on GitHub
3. **Contact the maintainer** for a working build or JAR file

## Summary

**Fixed:**
✅ POM dependencies (SNAPSHOT → Release versions)
✅ Documentation complete
✅ Configuration files ready
✅ Scripts prepared

**Remaining Issue:**
❌ Maven/Java DNS resolution for Maven Central

**Try First:**
```bash
export MAVEN_OPTS="-Djava.net.preferIPv4Stack=true"
mvn clean compile assembly:single
```

Once this builds successfully, everything else will work!
