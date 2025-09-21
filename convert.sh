#!/bin/bash
# Blog Conversion Script - Converts AsciiDoc to HTML with styling

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Paths
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ASCIIDOCTOR="/home/evanusmodestus/.local/share/gem/ruby/3.4.0/bin/asciidoctor"
HTML_OUTPUT="${BASE_DIR}/html_output"

# Asciidoctor options (no quotes in variable)

echo -e "${GREEN}=== Tech Blog Conversion Script ===${NC}"
echo "Base directory: $BASE_DIR"
echo ""

# Check if asciidoctor exists
if [ ! -f "$ASCIIDOCTOR" ]; then
    echo -e "${RED}Error: Asciidoctor not found at $ASCIIDOCTOR${NC}"
    echo "Install with: gem install asciidoctor"
    exit 1
fi

# Create output directories
echo -e "${YELLOW}Creating output directories...${NC}"
mkdir -p "${HTML_OUTPUT}"
mkdir -p "${HTML_OUTPUT}/drafts"
mkdir -p "${HTML_OUTPUT}/series"
mkdir -p "${HTML_OUTPUT}/assets"

# Install required gems if missing
echo -e "${YELLOW}Checking dependencies...${NC}"
gem list | grep -q "asciidoctor-diagram" || gem install asciidoctor-diagram
gem list | grep -q "rouge" || gem install rouge

# Convert published posts
echo -e "${YELLOW}Converting published posts...${NC}"
if ls ${BASE_DIR}/01_POSTS/*.adoc 1> /dev/null 2>&1; then
    for file in ${BASE_DIR}/01_POSTS/*.adoc; do
        filename=$(basename "$file")
        echo "  Converting: $filename"
        $ASCIIDOCTOR -a toc=left -a toclevels=3 -a numbered -a icons=font -a source-highlighter=rouge -r asciidoctor-diagram -D "${HTML_OUTPUT}" "$file"
    done
    echo -e "${GREEN}✓ Published posts converted${NC}"
else
    echo "  No posts found in 01_POSTS/"
fi

# Convert drafts
echo -e "${YELLOW}Converting drafts...${NC}"
if ls ${BASE_DIR}/02_DRAFTS/*.adoc 1> /dev/null 2>&1; then
    for file in ${BASE_DIR}/02_DRAFTS/*.adoc; do
        filename=$(basename "$file")
        echo "  Converting draft: $filename"
        $ASCIIDOCTOR -a toc=left -a toclevels=3 -a numbered -a icons=font -a source-highlighter=rouge -r asciidoctor-diagram -D "${HTML_OUTPUT}/drafts" "$file"
    done
    echo -e "${GREEN}✓ Drafts converted${NC}"
else
    echo "  No drafts found in 02_DRAFTS/"
fi

# Convert series
echo -e "${YELLOW}Converting series documentation...${NC}"
if ls ${BASE_DIR}/03_SERIES/*.adoc 1> /dev/null 2>&1; then
    for file in ${BASE_DIR}/03_SERIES/*.adoc; do
        filename=$(basename "$file")
        echo "  Converting series: $filename"
        $ASCIIDOCTOR -a toc=left -a toclevels=3 -a numbered -a icons=font -a source-highlighter=rouge -r asciidoctor-diagram -D "${HTML_OUTPUT}/series" "$file"
    done
    echo -e "${GREEN}✓ Series converted${NC}"
else
    echo "  No series found in 03_SERIES/"
fi

# Copy assets
echo -e "${YELLOW}Copying assets...${NC}"
if ls ${BASE_DIR}/04_ASSETS/* 1> /dev/null 2>&1; then
    cp -r ${BASE_DIR}/04_ASSETS/* "${HTML_OUTPUT}/assets/" 2>/dev/null || true
    echo -e "${GREEN}✓ Assets copied${NC}"
else
    echo "  No assets found in 04_ASSETS/"
fi

# Convert README
if [ -f "${BASE_DIR}/README.adoc" ]; then
    echo -e "${YELLOW}Converting README...${NC}"
    $ASCIIDOCTOR -a toc=left -a toclevels=3 -a numbered -a icons=font -a source-highlighter=rouge -r asciidoctor-diagram -D "${HTML_OUTPUT}" "${BASE_DIR}/README.adoc"
    echo -e "${GREEN}✓ README converted${NC}"
fi

# Create CSS file for better styling
echo -e "${YELLOW}Creating stylesheet...${NC}"
cat > "${HTML_OUTPUT}/style.css" << 'EOF'
/* Custom AsciiDoc Styling */
body {
    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
    line-height: 1.6;
    color: #333;
    max-width: 1200px;
    margin: 0 auto;
    padding: 2rem;
    background: #f5f5f5;
}

#header {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    color: white;
    padding: 2rem;
    border-radius: 8px;
    margin-bottom: 2rem;
}

#header h1 {
    margin: 0;
    font-size: 2.5rem;
}

#toc {
    background: white;
    border: 1px solid #ddd;
    border-radius: 8px;
    padding: 1.5rem;
    margin-bottom: 2rem;
    box-shadow: 0 2px 4px rgba(0,0,0,0.1);
}

#toctitle {
    font-weight: bold;
    font-size: 1.2rem;
    margin-bottom: 1rem;
    color: #667eea;
}

.sectlevel1 { margin-left: 0; }
.sectlevel2 { margin-left: 1rem; }
.sectlevel3 { margin-left: 2rem; }

#content {
    background: white;
    padding: 2rem;
    border-radius: 8px;
    box-shadow: 0 2px 4px rgba(0,0,0,0.1);
}

/* Code blocks */
.listingblock {
    margin: 1.5rem 0;
}

.listingblock pre {
    background: #1e1e1e;
    color: #d4d4d4;
    padding: 1rem;
    border-radius: 8px;
    overflow-x: auto;
    font-family: 'Consolas', 'Monaco', 'Courier New', monospace;
    font-size: 14px;
    line-height: 1.5;
}

/* Inline code */
code {
    background: #f0f0f0;
    padding: 0.2rem 0.4rem;
    border-radius: 3px;
    font-family: 'Consolas', 'Monaco', 'Courier New', monospace;
    font-size: 0.9em;
}

pre code {
    background: none;
    padding: 0;
}

/* Tables */
table {
    width: 100%;
    border-collapse: collapse;
    margin: 1.5rem 0;
}

table thead {
    background: #667eea;
    color: white;
}

table th, table td {
    padding: 0.75rem;
    border: 1px solid #ddd;
    text-align: left;
}

table tbody tr:nth-child(even) {
    background: #f9f9f9;
}

/* Admonitions */
.admonitionblock {
    margin: 1.5rem 0;
    padding: 1rem;
    border-radius: 8px;
    border-left: 4px solid;
}

.admonitionblock.note {
    background: #e3f2fd;
    border-left-color: #2196f3;
}

.admonitionblock.tip {
    background: #e8f5e9;
    border-left-color: #4caf50;
}

.admonitionblock.warning {
    background: #fff3e0;
    border-left-color: #ff9800;
}

.admonitionblock.important {
    background: #fce4ec;
    border-left-color: #e91e63;
}

/* Links */
a {
    color: #667eea;
    text-decoration: none;
}

a:hover {
    text-decoration: underline;
}

/* Sections */
.sect1 {
    margin-top: 2rem;
}

.sect1 h2 {
    color: #333;
    border-bottom: 2px solid #667eea;
    padding-bottom: 0.5rem;
}

/* Highlight.js theme override for better visibility */
.hljs {
    background: #1e1e1e !important;
    color: #d4d4d4 !important;
}

.hljs-keyword { color: #c586c0 !important; }
.hljs-string { color: #ce9178 !important; }
.hljs-comment { color: #6a9955 !important; }
.hljs-number { color: #b5cea8 !important; }
.hljs-function { color: #dcdcaa !important; }
.hljs-class { color: #4ec9b0 !important; }
EOF
echo -e "${GREEN}✓ Stylesheet created${NC}"

# Generate summary
echo ""
echo -e "${GREEN}=== Conversion Complete ===${NC}"
echo "HTML files location: ${HTML_OUTPUT}"
echo ""
echo "Statistics:"
echo "  Published posts: $(ls -1 ${HTML_OUTPUT}/2025-POST-*.html 2>/dev/null | wc -l)"
echo "  Drafts: $(ls -1 ${HTML_OUTPUT}/drafts/*.html 2>/dev/null | wc -l)"
echo "  Series: $(ls -1 ${HTML_OUTPUT}/series/*.html 2>/dev/null | wc -l)"
echo ""
# Add CSS and JS links to all HTML files
echo -e "${YELLOW}Applying styles to HTML files...${NC}"
for html in ${HTML_OUTPUT}/*.html ${HTML_OUTPUT}/*/*.html; do
    if [ -f "$html" ]; then
        # Get relative path for assets
        if [[ "$html" == *"/drafts/"* ]] || [[ "$html" == *"/series/"* ]]; then
            ASSET_PATH="../"
        else
            ASSET_PATH=""
        fi

        # Add CSS link and JavaScript if not already present
        if ! grep -q "style.css" "$html"; then
            sed -i "/<\/head>/i <link rel=\"stylesheet\" href=\"${ASSET_PATH}style.css\">" "$html" 2>/dev/null || true
            sed -i "/<\/head>/i <link rel=\"stylesheet\" href=\"https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/styles/github-dark.min.css\">" "$html" 2>/dev/null || true
            sed -i "/<\/body>/i <script src=\"https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/highlight.min.js\"></script>" "$html" 2>/dev/null || true
            sed -i "/<\/body>/i <script>hljs.highlightAll();</script>" "$html" 2>/dev/null || true
            sed -i "/<\/body>/i <script src=\"${ASSET_PATH}code-copy.js\"></script>" "$html" 2>/dev/null || true
        fi
    fi
done
echo -e "${GREEN}✓ Styles applied${NC}"

echo -e "${GREEN}View your blog:${NC}"
echo "  firefox ${HTML_OUTPUT}/index.html"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "  1. Review the converted HTML files"
echo "  2. Commit changes: git add . && git commit -m 'Update blog'"
echo "  3. Push to GitHub: git push"
echo "  4. Trigger GitHub Action to publish"