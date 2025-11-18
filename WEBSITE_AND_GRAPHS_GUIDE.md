# ASAPOP Website Building & Graph Generation Guide

## Overview

ASAPOP can build a complete website with **interactive graphs, charts, and tables** similar to https://filipvanlaenen.github.io/romanian_polls/

### What Gets Generated

```
romania-website/
├── index.html                    # Main landing page
├── calendar.html                 # Electoral calendar
├── calendar.ical                 # iCalendar file
├── statistics.html               # 📊 PIE CHARTS showing poll statistics
├── csv.html                      # CSV files listing
├── ro.html                       # 📈 Romania polls page with TABLES
├── ro.csv                        # CSV export of poll data
├── _scripts/                     # JavaScript for interactivity
│   ├── navigation.js
│   ├── sorting.js
│   └── tooltip.js
├── _stylesheets/                 # CSS styling
│   ├── base.css
│   └── custom.css
└── _widgets/                     # 📊 Embeddable widgets
    └── tables/
        └── ro.html              # Standalone table widget
```

## Types of Visualizations

### 1. SVG Pie Charts (statistics.html)

**Generated in:** `statistics.html`
**Code:** `src/main/java/net/filipvanlaenen/asapop/website/PieChart.java`

Shows:
- Number of opinion polls per area
- Number of response scenarios
- Number of result values
- Poll currency (how up-to-date)

**Features:**
- Interactive tooltips on hover
- SVG-based (scalable, crisp on any screen)
- Color-coded slices
- Percentage calculations
- Embedded symbols in slices

**Example:**
```
     ┌─────────────────────────────┐
     │  Number of Opinion Polls    │
     │                             │
     │      ╱───────╲             │
     │    ╱  RO: 45  ╲            │
     │   │            │            │
     │   │   Others   │            │
     │    ╲          ╱             │
     │      ╲───────╱              │
     └─────────────────────────────┘
```

### 2. HTML Tables (ro.html)

**Generated in:** `ro.html` (per-area pages)
**Code:** `src/main/java/net/filipvanlaenen/asapop/website/AreaIndexPagesBuilder.java`

Shows:
- Latest 50 opinion polls
- Fieldwork periods
- Polling firms
- Sample sizes
- Results for each party
- Sortable columns
- Interactive tooltips

**Example:**
```
┌─────────────┬──────────┬─────┬─────┬─────┬─────┬─────┬───────┐
│ Fieldwork   │ Firm     │ PSD │ PNL │ AUR │ USR │UDMR │ Other │
├─────────────┼──────────┼─────┼─────┼─────┼─────┼─────┼───────┤
│ 2024-01-15  │ CURS     │ 30% │ 22% │ 18% │ 15% │ 5%  │ 10%   │
│ 2024-01-18  │ INSCOP   │ 32% │ 20% │ 17% │ 16% │ 6%  │ 9%    │
│ 2024-01-20  │ Avangarde│ 31% │ 21% │ 19% │ 14% │ 5%  │ 10%   │
└─────────────┴──────────┴─────┴─────┴─────┴─────┴─────┴───────┘
```

### 3. Embeddable Widgets (_widgets/tables/)

**Generated in:** `_widgets/tables/ro.html`
**Code:** `src/main/java/net/filipvanlaenen/asapop/website/WidgetsBuilder.java`

Standalone HTML tables that can be embedded in other websites via iframe:

```html
<iframe src="https://your-site.com/_widgets/tables/ro.html"
        width="100%" height="600"></iframe>
```

### 4. CSV Files (ro.csv)

**Generated in:** `ro.csv`
**Code:** `src/main/java/net/filipvanlaenen/asapop/exporter/EopaodCsvExporter.java`

Downloadable CSV format for data analysis in Excel, R, Python, etc.

## How to Build the Website

### Quick Start

```bash
# 1. Build the project (if not already done)
mvn clean compile assembly:single

# 2. Run the automated website build script
./build-romania-website.sh
```

### Manual Build

```bash
java -jar target/asapop-1.0-SNAPSHOT-jar-with-dependencies.jar \
  build \
  romania-website \
  romania-website-config.yaml \
  ropf-files \
  custom.css
```

### Command Breakdown

- `build` - Command to build website
- `romania-website` - Output directory for generated files
- `romania-website-config.yaml` - Website configuration
- `ropf-files` - Directory containing ROPF files (e.g., ro.ropf)
- `custom.css` - Custom CSS styling

## File Structure Requirements

```
asapop/
├── ropf-files/                      # ROPF files directory
│   └── ro.ropf                      # Romania polls (MUST match areaCode in config)
├── romania-website-config.yaml      # Website configuration
├── custom.css                       # Custom CSS styling
└── target/
    └── asapop-*.jar                 # Compiled JAR
```

**IMPORTANT:** The ROPF filename MUST match the `areaCode` in the configuration:
- Config has `areaCode: "ro"` → File must be `ro.ropf`
- Config has `areaCode: "at"` → File must be `at.ropf`

## Website Configuration Explained

### romania-website-config.yaml

```yaml
areaConfigurations:
- areaCode: "ro"                     # Area code (MUST match ROPF filename)

  csvConfiguration:                  # Enables CSV export
    electoralListKeys:               # Parties to include
    - "RO001"                        # PSD
    - "RO002"                        # PNL
    # ...

  elections:                         # Election dates configuration
    national:                        # National elections
      dates:
        18: "2020-12-06"            # Past election
        19: "≤2024-12-31"           # Upcoming (by December 2024)
      gitHubWebsiteUrl: "..."       # Link to detailed polls site

    european:                        # European Parliament elections
      dates:
        6: "2024-06-09"

    presidential:                    # Presidential elections
      dates:
        10: "2024-11-24+(2024-12-08)"  # First round + Second round

  translations:                      # Area name in different languages
    en: "Romania"
    ro: "România"

widgetsConfiguration:                # Widget styling
  tableFontFamily: "sans-serif"
  tableStylesheets: []
```

## How Graphs Are Generated

### SVG Pie Chart Generation (PieChart.java)

**Location:** `src/main/java/net/filipvanlaenen/asapop/website/PieChart.java`

**Algorithm:**

1. **Calculate Total Sum**
   ```java
   long sum = entries.stream().map(e -> e.value()).reduce(0L, Long::sum);
   ```

2. **For Each Entry:**
   - Calculate angle: `angle = 2π × value / sum`
   - Draw arc using SVG `<path>` element
   - Place symbol at midpoint of arc
   - Add hover events for tooltips

3. **SVG Components:**
   ```svg
   <svg viewBox="0 0 500 250">
     <text>Title</text>           <!-- Chart title -->
     <circle/>                     <!-- For 100% single value -->
     <path d="M... A... Z"/>      <!-- Arc slices -->
     <text>Symbol</text>          <!-- Party symbol in slice -->
   </svg>
   ```

4. **Interactive Features:**
   - `onmousemove`: Show tooltip with details
   - `onmouseout`: Hide tooltip
   - Tooltip shows: Label, Value, Percentage

**Code Flow:**
```
Entry[] → Sort by size → Calculate angles → Generate SVG paths → Add tooltips
```

### HTML Table Generation (AreaIndexPagesBuilder.java)

**Location:** `src/main/java/net/filipvanlaenen/asapop/website/AreaIndexPagesBuilder.java`

**Algorithm:**

1. **Get Latest 50 Polls:**
   ```java
   List<OpinionPoll> latestPolls = calculateLatestOpinionPolls(opinionPolls);
   // Sorts by fieldwork end date, takes top 50
   ```

2. **Find Largest Parties:**
   - Looks at all polls
   - Finds parties with highest max support
   - Sorts parties by max support (descending)

3. **Create Table:**
   ```html
   <table class="opinion-polls-table">
     <thead>
       <tr>
         <th>Fieldwork Period</th>
         <th>Polling Firm</th>
         <th>PSD</th>
         <th>PNL</th>
         <!-- ... more parties -->
       </tr>
     </thead>
     <tbody>
       <!-- One row per poll -->
     </tbody>
   </table>
   ```

4. **For Each Poll Row:**
   - Format dates (fieldwork start – end)
   - Add polling firm
   - Add commissioner(s)
   - Add sample size
   - Add result for each party
   - Add "Other" column
   - Add footnotes if needed

## Customizing Graphs

### Custom Colors (custom.css)

```css
:root {
    --psd-color: #FF0000;      /* Red */
    --pnl-color: #FFD700;      /* Yellow */
    --aur-color: #0066CC;      /* Blue */
}

.pie-chart-1 { fill: var(--psd-color); }
.pie-chart-2 { fill: var(--pnl-color); }
.pie-chart-3 { fill: var(--aur-color); }
```

### Custom Symbols

In your ROPF file, party symbols are shown in pie charts:

```
PSD: RO001 •A: PSD •EN: Social Democratic Party
```

The abbreviation (PSD) becomes the symbol in the pie chart slice.

### Custom Table Styling

```css
.opinion-polls-table {
    border-collapse: collapse;
    width: 100%;
}

.opinion-polls-table th {
    background-color: #f2f2f2;
    font-weight: bold;
}

.opinion-polls-table tr:hover {
    background-color: #e9e9e9;
}
```

## Viewing the Generated Website

### Option 1: Open Directly

```bash
# Open in default browser (macOS)
open romania-website/index.html

# Open in default browser (Linux)
xdg-open romania-website/index.html

# Open in default browser (Windows)
start romania-website/index.html
```

### Option 2: Local Web Server

```bash
# Python 3
python3 -m http.server --directory romania-website 8000

# Then visit: http://localhost:8000
```

### Option 3: Deploy to GitHub Pages

1. Push generated files to `gh-pages` branch
2. Enable GitHub Pages in repository settings
3. Website available at: `https://username.github.io/repository/`

## Advanced: Adding More Polls

### Step 1: Update ROPF File

Add more polls to `ropf-files/ro.ropf`:

```
•PF: NewFirm •FS: 2024-02-01 •FE: 2024-02-05 •PD: 2024-02-10 •SC: N •SS: 1500 PSD:28 PNL:23 AUR:20 USR:17 UDMR:6 •O:6
```

### Step 2: Rebuild Website

```bash
./build-romania-website.sh
```

The website automatically updates with:
- New poll in tables
- Updated statistics
- Updated CSV files
- Updated graphs

## Understanding the Output

### statistics.html

Shows **6 pie charts** in 3 sections:

1. **Number of Opinion Polls** (All time vs. Year-to-date)
2. **Number of Response Scenarios** (All time vs. Year-to-date)
3. **Number of Result Values** (All time vs. Year-to-date)

Each chart shows breakdown by area (if multiple countries configured).

### ro.html

Shows:
- **H1**: Area name (e.g., "Romania")
- **Section**: "Opinion Polls"
- **Table**: Latest 50 polls with all results
- **Footnotes**: Explanations for symbols

### _widgets/tables/ro.html

Minimal HTML with:
- Just the table
- Inline CSS
- No navigation
- Ready for iframe embedding

## Troubleshooting

### No graphs appear

**Problem:** Empty statistics.html or missing charts
**Solution:** Ensure ropf-files/ro.ropf has valid poll data

### Table shows "None"

**Problem:** No polls found
**Solution:** Check ROPF filename matches `areaCode` in config

### CSS not applied

**Problem:** Charts look unstyled
**Solution:** Verify custom.css path in build command

### Build fails

**Problem:** "Area not found" error
**Solution:** ROPF filename must be `{areaCode}.ropf` (e.g., ro.ropf for areaCode: "ro")

## Technical Details

### SVG Generation Library

**Library:** tsvgj (https://github.com/filipvanlaenen/tsvgj)
**Purpose:** Type-safe SVG generation in Java

**Key Features:**
- Fluent API for SVG elements
- Type-safe attributes
- Automatic coordinate calculations
- Path generation helpers

### HTML Generation Library

**Library:** txhtmlj (https://github.com/filipvanlaenen/txhtmlj)
**Purpose:** Type-safe HTML generation in Java

**Key Features:**
- Fluent API for HTML5 elements
- Type-safe attributes
- Automatic escaping
- Valid HTML5 output

### Why SVG for Charts?

1. **Scalable:** Looks crisp on any screen size
2. **Interactive:** Can add JavaScript events
3. **Lightweight:** Smaller than raster images
4. **Accessible:** Can add alt text and ARIA labels
5. **CSS Stylable:** Easy to theme and customize

### Chart Interaction Flow

```
User hovers over pie slice
       ↓
onmousemove event fires
       ↓
JavaScript function showPieChartTooltip()
       ↓
Tooltip div positioned near cursor
       ↓
Tooltip shows: Party name, value, percentage
       ↓
User moves away
       ↓
onmouseout event fires
       ↓
Tooltip hidden
```

## Example: Complete Workflow

```bash
# 1. Add new poll to ROPF file
echo '•PF: CURS •FS: 2024-02-10 •FE: 2024-02-15 •PD: 2024-02-20 •SC: N •SS: 1000 PSD:29 PNL:21 AUR:19 USR:16 UDMR:5 •O:10' >> ropf-files/ro.ropf

# 2. Rebuild website
./build-romania-website.sh

# 3. View locally
python3 -m http.server --directory romania-website 8000

# 4. Open browser to http://localhost:8000

# 5. Navigate to:
#    - statistics.html → See pie charts
#    - ro.html → See updated table with new poll
#    - ro.csv → Download data including new poll
```

## Next Steps

1. **Add Real Data:** Replace example polls with actual Romanian poll data
2. **Customize Colors:** Edit custom.css with party colors
3. **Add More Areas:** Add other countries to the configuration
4. **Deploy Online:** Push to GitHub Pages or web host
5. **Automate Updates:** Set up scheduled rebuilds when new polls are added

## Key Files Reference

| File | Purpose |
|------|---------|
| `PieChart.java` | Generates SVG pie charts |
| `WidgetsBuilder.java` | Generates table widgets |
| `AreaIndexPagesBuilder.java` | Generates area pages with tables |
| `StatisticsPageBuilder.java` | Generates statistics page with charts |
| `WebsiteBuilder.java` | Orchestrates entire website build |
| `romania-website-config.yaml` | Configuration for Romania |
| `custom.css` | Custom styling |
| `ro.ropf` | Romania opinion poll data |

---

**Ready to generate graphs?** Run: `./build-romania-website.sh`

**Want to see examples?** Visit: https://filipvanlaenen.github.io/romanian_polls/
