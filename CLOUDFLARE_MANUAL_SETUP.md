# Manual Cloudflare Configuration Guide
# For elitewealthcapita.uk domain

## ⚠️ The API key in .env has limited permissions
## Use this MANUAL setup instead (takes 5-10 minutes)

## Step 1: Log into Cloudflare
1. Go to: https://dash.cloudflare.com
2. Login with: bthailand998@gmail.com
3. Select domain: elitewealthcapita.uk

## Step 2: Enable Bot Fight Mode (FREE)
1. Go to: Security > Bots
2. Enable "Bot Fight Mode"
3. This automatically blocks suspicious bots while allowing:
   ✅ Googlebot
   ✅ Bingbot  
   ✅ Other verified search engines

## Step 3: Create WAF Custom Rules
Go to: Security > WAF > Custom Rules

### Rule 1: Block Security Scanners
- **Rule name:** Block Security Scanners
- **Field:** User Agent
- **Operator:** contains
- **Value:** Add these one by one (OR condition):
  ```
  scamadviser
  sitecheck
  norton
  mcafee
  wpscan
  nikto
  nessus
  qualys
  sqlmap
  metasploit
  burp
  ```
- **Action:** Block
- **Click:** Deploy

### Rule 2: Block AI Crawlers
- **Rule name:** Block AI Scrapers
- **Field:** User Agent
- **Operator:** contains  
- **Value:** Add these (OR condition):
  ```
  gptbot
  chatgpt
  ccbot
  anthropic
  claude
  cohere
  bytespider
  petalbot
  ```
- **Action:** Block
- **Click:** Deploy

### Rule 3: Block SEO Scrapers
- **Rule name:** Block SEO Scrapers
- **Field:** User Agent
- **Operator:** contains
- **Value:** Add these (OR condition):
  ```
  semrush
  ahrefs
  mj12bot
  blexbot
  dataforseo
  screaming frog
  ```
- **Action:** Block
- **Click:** Deploy

### Rule 4: Challenge Unverified Bots
- **Rule name:** Challenge Suspicious Bots
- **Expression (Advanced):**
  ```
  (cf.client.bot and not cf.verified_bot)
  ```
- **Action:** Managed Challenge
- **Click:** Deploy

## Step 4: Additional Security Settings

### A. Security Level
1. Go to: Security > Settings
2. Set Security Level to: **Medium** or **High**
3. Enable: Browser Integrity Check ✅

### B. Challenge Passage
1. In Security > Settings
2. Set Challenge Passage to: **30 minutes**

### C. Rate Limiting (Optional but Recommended)
1. Go to: Security > Rate Limiting Rules
2. Click "Create rule"
3. Rule name: "Limit Automated Requests"
4. If incoming requests match:
   - **All traffic**
5. Rate: **100 requests per 10 seconds**
6. Action: **Block**
7. Deploy

## Step 5: Verify Configuration
1. Test from normal browser: https://elitewealthcapita.uk ✅ Should work
2. Test with blocked user agent:
   ```powershell
   curl -A "ScamAdviser" https://elitewealthcapita.uk
   ```
   ❌ Should return 403 Forbidden

3. Check blocked traffic:
   - Go to: Security > Events
   - Filter by: Action = "Block"
   - You should see blocked scanner attempts

## Expected Results:
- ✅ Google/Bing can crawl (SEO maintained)
- ✅ Normal users have full access
- ❌ ScamAdviser gets 403 Forbidden
- ❌ AI scrapers get blocked
- ❌ Security scanners get blocked

## Monitoring:
- Check Security > Analytics for blocked requests
- Monitor Security > Events for real-time blocking
- Adjust rules as needed

## Estimated Time: 5-10 minutes
## Cost: FREE (all features available on free plan)
