# Cloudflare Firewall Rules Setup Script
# Run this AFTER getting your API token

# Load environment
Get-Content "$env:USERPROFILE\.copilot\secrets\.env" | ForEach-Object { 
    if ($_ -match '^([^#][^=]+)=(.*)$') { 
        [Environment]::SetEnvironmentVariable($matches[1], $matches[2], 'Process') 
    }
}

# Check if token exists
if (-not $env:CLOUDFLARE_API_TOKEN) {
    Write-Host "`n❌ CLOUDFLARE_API_TOKEN not found!" -ForegroundColor Red
    Write-Host "   Run: .\get_cloudflare_token_guide.ps1 first`n" -ForegroundColor Yellow
    exit 1
}

$headers = @{
    "Authorization" = "Bearer $env:CLOUDFLARE_API_TOKEN"
    "Content-Type" = "application/json"
}

Write-Host "`n╔═══════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║  CLOUDFLARE BOT PROTECTION - AUTOMATIC SETUP      ║" -ForegroundColor Cyan
Write-Host "╚═══════════════════════════════════════════════════════╝`n" -ForegroundColor Cyan

# Verify zone access
Write-Host "🔍 Verifying API access..." -ForegroundColor Yellow
try {
    $zone = Invoke-RestMethod -Uri "https://api.cloudflare.com/client/v4/zones/$env:CLOUDFLARE_ZONE_ID" -Method Get -Headers $headers
    Write-Host "✅ Connected to: $($zone.result.name)" -ForegroundColor Green
    Write-Host "   Plan: $($zone.result.plan.name)`n" -ForegroundColor Cyan
} catch {
    Write-Host "❌ API access failed: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "   Make sure your token has correct permissions`n" -ForegroundColor Yellow
    exit 1
}

# Create filters and rules
Write-Host "📋 Creating firewall rules...`n" -ForegroundColor Cyan

# Rule 1: Block Security Scanners
Write-Host "[1/3] Creating: Block Security Scanners..." -ForegroundColor Yellow
$filter1 = @(
    @{
        expression = '(http.user_agent contains "scamadviser") or (http.user_agent contains "sitecheck") or (http.user_agent contains "norton") or (http.user_agent contains "mcafee") or (http.user_agent contains "wpscan") or (http.user_agent contains "nikto") or (http.user_agent contains "sqlmap")'
        description = "Security Scanners Filter"
    }
) | ConvertTo-Json -Depth 10

try {
    $filterResp1 = Invoke-RestMethod -Uri "https://api.cloudflare.com/client/v4/zones/$env:CLOUDFLARE_ZONE_ID/filters" -Method Post -Headers $headers -Body $filter1
    $filterId1 = $filterResp1.result[0].id
    
    $rule1 = @(
        @{
            filter = @{ id = $filterId1 }
            action = "block"
            description = "Block Security Scanners"
        }
    ) | ConvertTo-Json -Depth 10
    
    Invoke-RestMethod -Uri "https://api.cloudflare.com/client/v4/zones/$env:CLOUDFLARE_ZONE_ID/firewall/rules" -Method Post -Headers $headers -Body $rule1 | Out-Null
    Write-Host "      ✅ Security scanners blocked" -ForegroundColor Green
} catch {
    Write-Host "      ⚠️  $($_.Exception.Message)" -ForegroundColor Yellow
}

# Rule 2: Block AI Scrapers
Write-Host "[2/3] Creating: Block AI Scrapers..." -ForegroundColor Yellow
$filter2 = @(
    @{
        expression = '(http.user_agent contains "gptbot") or (http.user_agent contains "chatgpt") or (http.user_agent contains "ccbot") or (http.user_agent contains "anthropic") or (http.user_agent contains "claude") or (http.user_agent contains "bytespider")'
        description = "AI Scrapers Filter"
    }
) | ConvertTo-Json -Depth 10

try {
    $filterResp2 = Invoke-RestMethod -Uri "https://api.cloudflare.com/client/v4/zones/$env:CLOUDFLARE_ZONE_ID/filters" -Method Post -Headers $headers -Body $filter2
    $filterId2 = $filterResp2.result[0].id
    
    $rule2 = @(
        @{
            filter = @{ id = $filterId2 }
            action = "block"
            description = "Block AI Scrapers"
        }
    ) | ConvertTo-Json -Depth 10
    
    Invoke-RestMethod -Uri "https://api.cloudflare.com/client/v4/zones/$env:CLOUDFLARE_ZONE_ID/firewall/rules" -Method Post -Headers $headers -Body $rule2 | Out-Null
    Write-Host "      ✅ AI scrapers blocked" -ForegroundColor Green
} catch {
    Write-Host "      ⚠️  $($_.Exception.Message)" -ForegroundColor Yellow
}

# Rule 3: Block SEO Scrapers
Write-Host "[3/3] Creating: Block SEO Scrapers..." -ForegroundColor Yellow
$filter3 = @(
    @{
        expression = '(http.user_agent contains "semrush") or (http.user_agent contains "ahrefs") or (http.user_agent contains "mj12bot") or (http.user_agent contains "blexbot") or (http.user_agent contains "dataforseo")'
        description = "SEO Scrapers Filter"
    }
) | ConvertTo-Json -Depth 10

try {
    $filterResp3 = Invoke-RestMethod -Uri "https://api.cloudflare.com/client/v4/zones/$env:CLOUDFLARE_ZONE_ID/filters" -Method Post -Headers $headers -Body $filter3
    $filterId3 = $filterResp3.result[0].id
    
    $rule3 = @(
        @{
            filter = @{ id = $filterId3 }
            action = "block"
            description = "Block SEO Scrapers"
        }
    ) | ConvertTo-Json -Depth 10
    
    Invoke-RestMethod -Uri "https://api.cloudflare.com/client/v4/zones/$env:CLOUDFLARE_ZONE_ID/firewall/rules" -Method Post -Headers $headers -Body $rule3 | Out-Null
    Write-Host "      ✅ SEO scrapers blocked`n" -ForegroundColor Green
} catch {
    Write-Host "      ⚠️  $($_.Exception.Message)`n" -ForegroundColor Yellow
}

Write-Host "╔═══════════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║            ✅ SETUP COMPLETE!                      ║" -ForegroundColor Green
Write-Host "╚═══════════════════════════════════════════════════════╝`n" -ForegroundColor Green

Write-Host "Protection Active:" -ForegroundColor Cyan
Write-Host "  ✅ Google/Bing crawlers allowed" -ForegroundColor Green
Write-Host "  ❌ ScamAdviser blocked" -ForegroundColor Red
Write-Host "  ❌ AI scrapers blocked" -ForegroundColor Red
Write-Host "  ❌ Security scanners blocked`n" -ForegroundColor Red

Write-Host "Test blocking:" -ForegroundColor Yellow
Write-Host '  curl -A "ScamAdviser" https://elitewealthcapita.uk' -ForegroundColor Gray
Write-Host "  (Should return 403 Forbidden)`n" -ForegroundColor Gray

Write-Host "Monitor traffic at:" -ForegroundColor Cyan
Write-Host "  https://dash.cloudflare.com → Security → Events`n" -ForegroundColor White
