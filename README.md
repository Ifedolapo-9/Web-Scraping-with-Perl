# Perl Web Scraping Scripts

A collection of Perl web scraping scripts covering HTTP requests, HTML parsing, session management, headless browser automation, and proxy integration with Decodo.

---

## Scripts

| File | What it does |
|---|---|
| `perl_scraper.pl` | Core scraper using LWP::UserAgent and HTML::TreeBuilder |
| `decodo_proxy_scraper.pl` | Scraper routed through a Decodo residential proxy with IP verification |
| `mechanize_chrome_example.pl` | Headless Chrome scraper using WWW::Mechanize::Chrome (for JS-heavy sites) |
| `selenium_chrome_example.pl` | Headless Chrome scraper using Selenium::Chrome |
| `hello.pl` | Basic Perl sanity check |

---

## Prerequisites

### macOS

```bash
# Install Perl (already included on macOS) and cpanminus
brew install perl cpanminus chromium

# Install required modules
cpanm LWP::UserAgent HTML::TreeBuilder WWW::Mechanize JSON Text::CSV XML::Simple
cpanm WWW::Mechanize::Chrome
cpanm Selenium::Remote::Driver
```

### Windows (Strawberry Perl)

Download and install [Strawberry Perl](https://strawberryperl.com/), then open the Perl command line:

```powershell
cpanm LWP::UserAgent HTML::TreeBuilder WWW::Mechanize JSON Text::CSV XML::Simple
cpanm Selenium::Remote::Driver
```

> `WWW::Mechanize::Chrome` is not recommended on Windows — use Docker instead (see below).

### Linux / Docker (recommended for headless browser scripts)

```bash
docker build -t perl-scraper .
```

---

## Running the scripts

### Basic scraper

```bash
perl perl_scraper.pl
```

### Decodo proxy scraper

Set your credentials as environment variables first — never hardcode them.

**macOS / Linux:**
```bash
export PROXY_USERNAME=your_username
export PROXY_PASSWORD=your_password
perl decodo_proxy_scraper.pl
```

**Windows PowerShell:**
```powershell
$env:PROXY_USERNAME = "your_username"
$env:PROXY_PASSWORD = "your_password"
perl decodo_proxy_scraper.pl
```

Or use the runner script, which will prompt for credentials if they aren't set:

```powershell
.\run_decodo_scraper.ps1
```

### Headless Chrome scripts (Docker)

```bash
# WWW::Mechanize::Chrome
docker run --rm -v "$(pwd):/app" perl-scraper perl mechanize_chrome_example.pl

# Selenium::Chrome
docker run --rm -v "$(pwd):/app" perl-scraper perl selenium_chrome_example.pl
```

**Windows PowerShell:**
```powershell
docker run --rm -v "C:/path/to/perl_scrape:/app" perl-scraper perl mechanize_chrome_example.pl
```

---

## Environment variables

| Variable | Required | Default | Description |
|---|---|---|---|
| `PROXY_USERNAME` | Yes | — | Decodo proxy username |
| `PROXY_PASSWORD` | Yes | — | Decodo proxy password |
| `PROXY_HOST` | No | `gate.decodo.com` | Decodo proxy host |
| `PROXY_PORT` | No | `7000` | Decodo proxy port |

---

## Project structure

```
perl_scrape/
├── Dockerfile                  # Docker image for Linux/headless Chrome runs
├── perl_scraper.pl             # Core LWP + HTML::TreeBuilder scraper
├── decodo_proxy_scraper.pl     # Proxy scraper via Decodo
├── mechanize_chrome_example.pl # JS scraping with WWW::Mechanize::Chrome
├── selenium_chrome_example.pl  # JS scraping with Selenium::Chrome
├── hello.pl                    # Basic Perl test
├── install_modules.ps1         # Windows module installer
├── run_decodo_scraper.ps1      # Windows runner for the proxy scraper
└── README.md
```
