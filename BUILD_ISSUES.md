# Build Issues & Solutions

## ⚠️ Current Issue: No Internet Connectivity

The Maven build is failing because the environment has no internet access, which is required to download:

1. **Maven plugins** from Maven Central (repo.maven.apache.org)
2. **Custom dependencies** from the project's repository (storage.googleapis.com/fvl-mvn-repo)

### Error Details

```
Could not resolve dependencies:
- net.filipvanlaenen:kolektoj:jar:1.0-SNAPSHOT
- net.filipvanlaenen:nombrajkolektoj:jar:1.0-SNAPSHOT
- Various Maven plugins

Cause: repo.maven.apache.org: Temporary failure in name resolution
```

## ✅ Solutions

### Option 1: Build on a Machine with Internet

**On your local machine or a server with internet:**

```bash
# Clone the repository
git clone https://github.com/andreimiclea99/asapop.git
cd asapop

# Build the project (will download all dependencies)
mvn clean compile assembly:single

# The JAR will be in target/
ls -lh target/asapop-1.0-SNAPSHOT-jar-with-dependencies.jar
```

### Option 2: Download Pre-built JAR

If the original author provides releases, download the pre-built JAR from:
- GitHub Releases page
- Project website
- CI/CD artifacts

### Option 3: Use Pre-populated Maven Cache

If you have built this project before on another machine:

```bash
# Copy the entire .m2 directory from a machine where it built successfully
# From machine with successful build:
tar -czf maven-cache.tar.gz ~/.m2/repository

# To this machine:
tar -xzf maven-cache.tar.gz -C ~/
```

### Option 4: Offline Mode (If Dependencies Already Cached)

If dependencies were previously downloaded:

```bash
# Try building in offline mode
mvn clean compile assembly:single -o
```

This only works if all dependencies were previously downloaded.

## 🔍 What You Can Do NOW (Without Building)

Even though you can't build the project right now, **all the code and documentation are ready**:

### 1. Review the Code

```bash
# Explore the analysis engine
cat src/main/java/net/filipvanlaenen/asapop/analysis/AnalysisEngine.java

# Explore graph generation
cat src/main/java/net/filipvanlaenen/asapop/website/PieChart.java

# Explore table building
cat src/main/java/net/filipvanlaenen/asapop/website/WidgetsBuilder.java
```

### 2. Understand the Configuration

```bash
# Website configuration
cat romania-website-config.yaml

# Poll data format
cat ropf-files/ro.ropf

# Styling
cat custom.css
```

### 3. Read the Documentation

```bash
# Quick start guide for graphs
cat GRAPHS_QUICK_START.md

# Complete website building guide
cat WEBSITE_AND_GRAPHS_GUIDE.md

# Analysis logic explanation
cat ANALYSIS_LOGIC_EXPLAINED.md

# General usage
cat README.md
```

### 4. Review Build Scripts

```bash
# Website build script
cat build-romania-website.sh

# Analysis script
cat run-romania-analysis.sh
```

### 5. Study the ROPF Format

```bash
# Example opinion poll data
cat romania-example.ropf

# Shows:
# - Poll metadata (firm, dates, sample size)
# - Results per party
# - Electoral list definitions
```

## 🚀 When You Have Internet Access

### Complete Build & Run Workflow

```bash
# 1. Build the project
mvn clean compile assembly:single

# 2. Verify the JAR was created
ls -lh target/asapop-1.0-SNAPSHOT-jar-with-dependencies.jar

# 3. Generate the website with graphs
./build-romania-website.sh

# 4. View the results locally
python3 -m http.server --directory romania-website 8000

# 5. Open browser to:
#    http://localhost:8000/statistics.html  (Pie charts)
#    http://localhost:8000/ro.html          (Poll tables)
```

### Run Analysis

```bash
# Analyze opinion polls
./run-romania-analysis.sh

# View results
cat romania-results.yaml
```

## 📦 Project Dependencies

These will be automatically downloaded when you build with internet:

### From Maven Central
- jackson-dataformat-yaml (YAML parsing)
- junit (testing)

### From Custom Repository (storage.googleapis.com/fvl-mvn-repo)
- **kolektoj** - Collection utilities
- **nombrajkolektoj** - Numerical collection utilities
- **laconic** - Logging framework
- **tsvgj** - SVG generation library
- **txhtmlj** - HTML generation library

## 🔧 Troubleshooting

### If Build Fails After Getting Internet

**Clear Maven cache and retry:**

```bash
# Remove cached failures
rm -rf ~/.m2/repository/net/filipvanlaenen/kolektoj
rm -rf ~/.m2/repository/net/filipvanlaenen/nombrajkolektoj

# Force update
mvn clean compile assembly:single -U
```

### If Custom Repository Dependencies Not Found

The dependencies are SNAPSHOT versions, which may not always be available. Options:

1. **Contact the project author** for stable release versions
2. **Build dependencies from source** (if repositories are public)
3. **Use a cached version** if you've built before

## 📋 Summary

**Current Status:**
- ✅ All code is ready
- ✅ All configuration files created
- ✅ All documentation written
- ✅ All scripts prepared
- ❌ Can't build due to no internet

**What Works NOW:**
- Reading and understanding the code
- Reviewing configurations
- Studying the documentation
- Planning your implementation

**What Needs Internet:**
- Building the JAR file
- Generating the website
- Running the analysis
- Creating the graphs

## 💡 Recommendation

**Transfer this repository to a machine with internet access**, then:

1. Build the project: `mvn clean compile assembly:single`
2. Generate website: `./build-romania-website.sh`
3. View the graphs in your browser

Everything is ready - you just need internet to download Maven dependencies!

## 📞 Need Help?

1. **Check original repository:** https://github.com/filipvanlaenen/asapop
2. **Review documentation** in the repo
3. **Contact project maintainer** if dependencies are unavailable

---

**Note:** All the work I did (configuration, documentation, scripts) is complete and committed. The only blocker is downloading dependencies to build the JAR file.
