# Cloudflare API Token Generator Guide
# Use this to create a proper API token with correct permissions

Write-Host @"

╔═══════════════════════════════════════════════════════════════╗
║  CLOUDFLARE API TOKEN - STEP BY STEP GUIDE                ║
╚═══════════════════════════════════════════════════════════════╝

The Global API Key has limited permissions. You need to create
a custom API Token with specific permissions.

🔐 HOW TO CREATE API TOKEN:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

STEP 1: Open API Token Page
   Copy this URL and paste in a NEW BROWSER TAB:
   
   https://dash.cloudflare.com/profile/api-tokens

   (If it shows JSON, open in Incognito/Private mode)


STEP 2: Create Token
   1. Click the blue "Create Token" button
   2. Scroll down to "Custom token"
   3. Click "Get started"


STEP 3: Token Configuration
   Token name: 
      Elite Wealth Bot Protection
   
   Permissions (click "+ Add more" for each):
      Zone → Zone → Read
      Zone → Zone Settings → Edit
      Zone → Firewall Services → Edit
      Zone → WAF → Edit
   
   Zone Resources:
      Include → Specific zone → elitewealthcapita.uk


STEP 4: Generate Token
   1. Scroll to bottom
   2. Click "Continue to summary"
   3. Click "Create Token"
   4. COPY THE TOKEN (it shows only once!)


STEP 5: Save Token to Environment
   Run this command with your NEW token:

"@ -ForegroundColor White

Write-Host @'
   $token = "YOUR_TOKEN_HERE"
   Add-Content -Path "$env:USERPROFILE\.copilot\secrets\.env" -Value "`nCLOUDFLARE_API_TOKEN=$token"
   $env:CLOUDFLARE_API_TOKEN = $token
'@ -ForegroundColor Yellow

Write-Host @"


STEP 6: Run Firewall Setup
   After saving token, run:
   
   .\create_cloudflare_rules_with_token.ps1


═══════════════════════════════════════════════════════════════

💡 TIP: If browser shows JSON instead of dashboard:
   1. Try opening https://dash.cloudflare.com in Incognito mode
   2. Or use different browser (Chrome, Edge, Firefox)
   3. Clear browser cache and cookies
   4. Make sure you're logged into: bthailand998@gmail.com

"@ -ForegroundColor Cyan

Read-Host "`nPress ENTER when you have the token ready"
