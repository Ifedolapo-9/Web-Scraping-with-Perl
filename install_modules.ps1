#!/usr/bin/env powershell
# ============================================================================
# Install Required Perl Modules for Decodo Proxy Scraper
# ============================================================================

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Installing Required Perl Modules" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if cpanm is available
$cpanmCheck = Get-Command cpanm -ErrorAction SilentlyContinue
if (-not $cpanmCheck) {
    Write-Host "[✗] ERROR: cpanm is not found" -ForegroundColor Red
    Write-Host ""
    Write-Host "cpanm comes with Strawberry Perl. Please install it from:" -ForegroundColor Yellow
    Write-Host "https://strawberryperl.com/" -ForegroundColor Yellow
    Write-Host ""
    exit 1
}

Write-Host "[✓] Found cpanm at: $($cpanmCheck.Source)" -ForegroundColor Green
Write-Host ""

# List of required modules
$modules = @(
    'LWP::UserAgent',
    'HTML::TreeBuilder',
    'JSON',
    'HTTP::Request::Common'
)

Write-Host "[→] Installing modules..." -ForegroundColor Cyan
Write-Host ""

foreach ($module in $modules) {
    Write-Host "Installing: $module" -ForegroundColor Yellow
    & cpanm $module
    if ($LASTEXITCODE -eq 0) {
        Write-Host "[✓] $module installed successfully" -ForegroundColor Green
    } else {
        Write-Host "[✗] Failed to install $module" -ForegroundColor Red
    }
    Write-Host ""
}

Write-Host "========================================" -ForegroundColor Green
Write-Host "[✓] Module installation complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "You can now run the Decodo proxy scraper:" -ForegroundColor Cyan
Write-Host "  powershell -ExecutionPolicy Bypass -File run_decodo_scraper.ps1" -ForegroundColor Cyan
