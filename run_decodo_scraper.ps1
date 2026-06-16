#!/usr/bin/env powershell
# ============================================================================
# Decodo Proxy Scraper Runner
# This script sets up environment variables and runs the Perl scraper
# ============================================================================

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Decodo Proxy Scraper Setup" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Set Decodo Proxy Credentials
# If not already set as environment variables, prompt for them now
if (-not $env:PROXY_USERNAME) { $env:PROXY_USERNAME = Read-Host "Enter PROXY_USERNAME" }
if (-not $env:PROXY_PASSWORD) { $env:PROXY_PASSWORD = Read-Host "Enter PROXY_PASSWORD" }
if (-not $env:PROXY_HOST)     { $env:PROXY_HOST = 'gate.decodo.com' }
if (-not $env:PROXY_PORT)     { $env:PROXY_PORT = '7000' }

Write-Host "[✓] Environment variables set:" -ForegroundColor Green
Write-Host "  PROXY_USERNAME: $env:PROXY_USERNAME" -ForegroundColor Gray
Write-Host "  PROXY_PASSWORD: (hidden)" -ForegroundColor Gray
Write-Host "  PROXY_HOST: $env:PROXY_HOST" -ForegroundColor Gray
Write-Host "  PROXY_PORT: $env:PROXY_PORT" -ForegroundColor Gray
Write-Host ""

# Check if perl is available
$perlCheck = Get-Command perl -ErrorAction SilentlyContinue
if (-not $perlCheck) {
    Write-Host "[✗] ERROR: Perl is not installed or not in PATH" -ForegroundColor Red
    Write-Host "Please install Strawberry Perl from https://strawberryperl.com/" -ForegroundColor Yellow
    exit 1
}

Write-Host "[✓] Perl found: $($perlCheck.Source)" -ForegroundColor Green
Write-Host ""

# Run the Perl scraper
Write-Host "[→] Running Decodo Proxy Scraper..." -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

& perl "decodo_proxy_scraper.pl"

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "[✓] Script completed successfully" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
} else {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Red
    Write-Host "[✗] Script failed with exit code: $LASTEXITCODE" -ForegroundColor Red
    Write-Host "========================================" -ForegroundColor Red
}
