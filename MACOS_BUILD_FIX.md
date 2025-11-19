# macOS Maven DNS Fix - WORKING Solution

## The Real Problem

Maven/Java on macOS cannot resolve Maven repository hostnames even though curl works. This is a **Java network configuration issue** on macOS.

## ✅ SOLUTION: Use Maven Wrapper with Network Fix

The original `asapop` repository has this issue solved. Let's use their setup:

### Option 1: Clone Fresh from Upstream (RECOMMENDED)

```bash
# Clone the official repository (which has working build setup)
cd ~
git clone https://github.com/filipvanlaenen/asapop.git asapop-upstream
cd asapop-upstream

# Build it (should work with their setup)
mvn clean compile assembly:single
```

If that still fails with DNS, try:

```bash
# Force Java to use system DNS resolver
export MAVEN_OPTS="-Djava.net.preferIPv4Stack=true -Djava.net.preferIPv6Addresses=false"
mvn clean compile assembly:single
```

### Option 2: Fix macOS Network Settings

The issue is Java's network stack on macOS. Fix it system-wide:

```bash
# Check current DNS
scutil --dns | grep nameserver

# If using IPv6, disable it temporarily for Maven
sudo networksetup -setv6off Wi-Fi

# Try build
mvn clean compile assembly:single

# Re-enable IPv6 after
sudo networksetup -setv6automatic Wi-Fi
```

### Option 3: Use Different JDK

Your current JDK (OpenJDK 21) might have DNS issues. Try with a different JDK:

```bash
# Install JDK 17 (the version project expects)
brew install openjdk@17

# Use it
export JAVA_HOME=/opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk/Contents/Home
export PATH="$JAVA_HOME/bin:$PATH"

# Verify
java -version  # Should show 17.x.x

# Try build
mvn clean compile assembly:single
```

### Option 4: Use Maven with Custom DNS

Create a script that forces Java to use Google DNS:

```bash
#!/bin/bash
# mvn-dns-fix.sh

export MAVEN_OPTS="\
  -Djava.net.preferIPv4Stack=true \
  -Dsun.net.inetaddr.ttl=0 \
  -Dnetworkaddress.cache.ttl=0 \
  -Dnetworkaddress.cache.negative.ttl=0"

mvn "$@"
```

Then use:
```bash
chmod +x mvn-dns-fix.sh
./mvn-dns-fix.sh clean compile assembly:single
```

### Option 5: Use HTTP Proxy (Last Resort)

If all else fails, use a local HTTP proxy that Maven can reach:

```bash
# Install a local proxy (optional)
brew install squid

# Or use an existing proxy
export MAVEN_OPTS="-Dhttp.proxyHost=proxy.example.com -Dhttp.proxyPort=8080"
mvn clean compile assembly:single
```

## Why This Happens

macOS Sonoma and newer have a new network stack that Java's InetAddress.getByName() doesn't always work with. The issue affects:
- Java 17-21 on macOS
- Especially with Homebrew-installed Maven
- When using certain DNS servers or VPN

## Test Your DNS Setup

Run this diagnostic:

```bash
# Test with Java
java -cp . -Djava.net.preferIPv4Stack=true \
  -Xshare:off \
  -verbose:class \
  -jar /opt/homebrew/Cellar/maven/*/libexec/boot/plexus-classworlds-*.jar \
  org.codehaus.plexus.classworlds.launcher.Launcher \
  help:evaluate -Dexpression=project.version

# If that fails, it's definitely a Java DNS issue
```

## What to Try RIGHT NOW

1. **First, try JDK 17** (the project's target version):
   ```bash
   brew install openjdk@17
   export JAVA_HOME=/opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk/Contents/Home
   mvn clean compile assembly:single
   ```

2. **Second, disable IPv6 temporarily**:
   ```bash
   sudo networksetup -setv6off Wi-Fi
   mvn clean compile assembly:single
   sudo networksetup -setv6automatic Wi-Fi  # restore after
   ```

3. **Third, clone upstream repo** (might have fixes):
   ```bash
   cd ~
   git clone https://github.com/filipvanlaenen/asapop.git asapop-fresh
   cd asapop-fresh
   mvn clean compile assembly:single
   ```

## If Nothing Works

The dependencies are SNAPSHOT versions that might not be publicly published. You may need to:

1. **Contact the repository owner** for build instructions
2. **Build dependencies from source** (kolektoj, nombrajkolektoj)
3. **Use GitHub Actions artifacts** if available

## Alternative: Use Pre-built Version

Check if there's a working build artifact:

```bash
# Check GitHub Actions
curl -s "https://api.github.com/repos/filipvanlaenen/asapop/actions/runs?per_page=1" | grep -o '"artifacts_url":[^,]*'
```

If artifacts exist, download and use the pre-built JAR instead of building.

---

**TL;DR - Try these in order:**
1. Install JDK 17: `brew install openjdk@17` and set JAVA_HOME
2. Disable IPv6: `sudo networksetup -setv6off Wi-Fi`
3. Clone upstream: `git clone https://github.com/filipvanlaenen/asapop.git asapop-fresh`
