# Cloudflare Bot Protection Setup Script
# Run this with proper API token

# ====================================
# STEP 1: Get Your Cloudflare API Token
# ====================================
# 1. Log in to Cloudflare Dashboard: https://dash.cloudflare.com
# 2. Go to "My Profile" > "API Tokens"
# 3. Click "Create Token"
# 4. Use "Edit zone DNS" template or create custom with:
#    - Zone:Firewall Services:Edit
#    - Zone:Zone Settings:Edit
# 5. Copy the token

# ====================================
# STEP 2: Configure Variables
# ====================================
$CLOUDFLARE_API_TOKEN = "YOUR_API_TOKEN_HERE"  # Replace with your token
$ZONE_ID = "36d0d0d33e2e83010ec216677bdec2b2"  # elitewealthcapita.uk zone

# ====================================
# STEP 3: Run Firewall Configuration
# ====================================
$headers = @{
    "Authorization" = "Bearer $CLOUDFLARE_API_TOKEN"
    "Content-Type" = "application/json"
}

Write-Host "`n🛡️  Configuring Cloudflare Bot Protection..." -ForegroundColor Cyan

# Rule 1: Block Security Scanners
Write-Host "`n📋 Creating Rule 1: Block Security Scanners..." -ForegroundColor Yellow
$rule1 = @{
    description = "Block Security Scanners and Malicious Bots"
    expression = '(http.user_agent contains "scamadviser") or (http.user_agent contains "sitecheck") or (http.user_agent contains "norton") or (http.user_agent contains "mcafee") or (http.user_agent contains "wpscan") or (http.user_agent contains "nikto") or (http.user_agent contains "nessus") or (http.user_agent contains "qualys") or (http.user_agent contains "sqlmap") or (http.user_agent contains "metasploit") or (http.user_agent contains "burp")'
    action = "block"
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/rulesets/phases/http_request_firewall_custom/entrypoint" -Method Put -Headers $headers -Body $rule1
    Write-Host "✅ Security scanners blocked!" -ForegroundColor Green
} catch {
    Write-Host "⚠️  API Error: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "   You may need to configure manually via dashboard" -ForegroundColor Yellow
}

# Rule 2: Block AI Scrapers
Write-Host "`n📋 Creating Rule 2: Block AI Scrapers..." -ForegroundColor Yellow
$rule2 = @{
    description = "Block AI Crawlers and Scrapers"
    expression = '(http.user_agent contains "gptbot") or (http.user_agent contains "chatgpt") or (http.user_agent contains "ccbot") or (http.user_agent contains "anthropic") or (http.user_agent contains "claude") or (http.user_agent contains "cohere") or (http.user_agent contains "bytespider") or (http.user_agent contains "petalbot")'
    action = "block"
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/rulesets/phases/http_request_firewall_custom/entrypoint" -Method Put -Headers $headers -Body $rule2
    Write-Host "✅ AI scrapers blocked!" -ForegroundColor Green
} catch {
    Write-Host "⚠️  API Error: $($_.Exception.Message)" -ForegroundColor Red
}

# Rule 3: Block SEO Scrapers
Write-Host "`n📋 Creating Rule 3: Block SEO Scrapers..." -ForegroundColor Yellow
$rule3 = @{
    description = "Block SEO Scrapers (Not Google/Bing)"
    expression = '(http.user_agent contains "semrush") or (http.user_agent contains "ahrefs") or (http.user_agent contains "mj12bot") or (http.user_agent contains "blexbot") or (http.user_agent contains "dataforseo") or (http.user_agent contains "screaming frog")'
    action = "block"
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/rulesets/phases/http_request_firewall_custom/entrypoint" -Method Put -Headers $headers -Body $rule3
    Write-Host "✅ SEO scrapers blocked!" -ForegroundColor Green
} catch {
    Write-Host "⚠️  API Error: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n✅ Bot protection setup complete!" -ForegroundColor Green
Write-Host "`n📊 Verify in Cloudflare Dashboard:" -ForegroundColor Cyan
Write-Host "   https://dash.cloudflare.com > Security > WAF" -ForegroundColor White
