# ASAPOP Graphs - Quick Start Guide

## 🚀 Generate Graphs in 3 Steps

### Step 1: Build the Project
```bash
mvn clean compile assembly:single
```

### Step 2: Run Website Builder
```bash
./build-romania-website.sh
```

### Step 3: View Results
```bash
# Option A: Open in browser
open romania-website/index.html

# Option B: Start web server
python3 -m http.server --directory romania-website 8000
# Visit: http://localhost:8000
```

## 📊 What You Get

### Generated Visualizations

```
romania-website/
├── statistics.html       ← PIE CHARTS (poll statistics)
├── ro.html              ← TABLES (latest 50 polls)
├── ro.csv               ← CSV DATA (all polls)
└── _widgets/tables/
    └── ro.html          ← EMBEDDABLE TABLE WIDGET
```

### Pie Charts (statistics.html)

Interactive SVG charts showing:
- Number of polls per area
- Response scenarios count
- Result values distribution
- Poll currency (freshness)

**Features:**
- Hover for details
- Color-coded by party
- Responsive design
- Scalable vector graphics

### Tables (ro.html)

HTML tables with:
- Latest 50 opinion polls
- Fieldwork dates
- Polling firms
- Sample sizes
- Results for all parties
- Sortable columns

### CSV Export (ro.csv)

Downloadable data for:
- Excel analysis
- Python/R processing
- Database import
- Archiving

## 🎨 Customization

### Change Party Colors

Edit `custom.css`:

```css
:root {
    --psd-color: #FF0000;   /* Your color here */
    --pnl-color: #FFD700;
    --aur-color: #0066CC;
}
```

### Add More Polls

Edit `ropf-files/ro.ropf`:

```
•PF: CURS •FS: 2024-02-01 •FE: 2024-02-05 •PD: 2024-02-10 •SC: N •SS: 1000 PSD:29 PNL:22 AUR:20 USR:15 UDMR:6 •O:8
```

Rebuild:
```bash
./build-romania-website.sh
```

## 📂 Required Files

```
asapop/
├── ropf-files/
│   └── ro.ropf                     ✓ Opinion poll data
├── romania-website-config.yaml     ✓ Website configuration
├── custom.css                      ✓ Styling
└── build-romania-website.sh        ✓ Build script
```

All files already created for you! ✨

## 🔧 Manual Build (Alternative)

```bash
java -jar target/asapop-1.0-SNAPSHOT-jar-with-dependencies.jar \
  build \
  romania-website \
  romania-website-config.yaml \
  ropf-files \
  custom.css
```

## 📖 Graph Types Explained

### 1. Pie Charts (SVG)

**File:** `statistics.html`
**Code:** `PieChart.java:180-244`

```
     ╱─────────╲
   ╱ PSD  30%   ╲
  │              │
  │  PNL  22%    │
   ╲            ╱
     ╲─────────╱
```

### 2. Poll Tables (HTML)

**File:** `ro.html`
**Code:** `AreaIndexPagesBuilder.java:128-173`

```
┌──────────┬──────┬─────┬─────┬─────┐
│ Date     │ Firm │ PSD │ PNL │ AUR │
├──────────┼──────┼─────┼─────┼─────┤
│2024-01-15│ CURS │ 30% │ 22% │ 18% │
│2024-01-18│INSCOP│ 32% │ 20% │ 17% │
└──────────┴──────┴─────┴─────┴─────┘
```

### 3. Widgets (Embeddable)

**File:** `_widgets/tables/ro.html`
**Code:** `WidgetsBuilder.java:268-305`

Standalone table for embedding:
```html
<iframe src="_widgets/tables/ro.html"></iframe>
```

## 🌐 Deploy to Web

### GitHub Pages

```bash
# Add generated files to git
git add romania-website/

# Commit
git commit -m "Add Romania polls website"

# Push to gh-pages branch
git push origin main:gh-pages

# Enable in GitHub repository settings
# Website: https://username.github.io/repository/
```

## ❓ Troubleshooting

### No graphs appear
→ Check `ropf-files/ro.ropf` has poll data

### Build fails
→ Ensure ROPF filename matches `areaCode` in config (`ro.ropf` for `areaCode: "ro"`)

### Colors wrong
→ Edit party colors in `custom.css`

### Table empty
→ Verify ROPF file is in `ropf-files/` directory

## 📚 More Details

- **Full Guide:** `WEBSITE_AND_GRAPHS_GUIDE.md` (comprehensive)
- **Analysis Logic:** `ANALYSIS_LOGIC_EXPLAINED.md` (how calculations work)
- **ROPF Format:** `README.md` (data format specification)

## 🎯 Example Websites

- **Romania:** https://filipvanlaenen.github.io/romanian_polls/
- **Austria:** https://filipvanlaenen.github.io/austrian_polls/
- **Belgium:** https://filipvanlaenen.github.io/belgian_polls/

Your website will look similar with Romania-specific data!

## 🔑 Key Commands

```bash
# Build website
./build-romania-website.sh

# Serve locally
python3 -m http.server --directory romania-website 8000

# View main page
open romania-website/index.html

# View statistics (pie charts)
open romania-website/statistics.html

# View Romania page (tables)
open romania-website/ro.html
```

## ⚡ Quick Test

```bash
# One-liner to build and view
./build-romania-website.sh && python3 -m http.server --directory romania-website 8000
```

Then visit: http://localhost:8000/statistics.html for pie charts! 📊

---

**Ready?** Run: `./build-romania-website.sh` and open `romania-website/statistics.html`!
