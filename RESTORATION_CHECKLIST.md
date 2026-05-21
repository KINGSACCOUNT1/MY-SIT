# 🔄 Database Restoration Checklist

**Date:** May 21, 2026  
**Migration:** Neon → Supabase  
**Status:** In Progress

---

## ✅ COMPLETED STEPS

- [x] Created Supabase account
- [x] Created new project: fykzoburtipislgjrcjm
- [x] Generated database connection string
- [x] Updated local .env file

---

## 📋 REMAINING STEPS

### 1. UPDATE RENDER ENVIRONMENT VARIABLE

**Go to:** https://dashboard.render.com/

**Steps:**
1. Select your "Elite Wealth Capital" service
2. Click **Environment** tab
3. Find **DATABASE_URL** variable
4. Click **Edit** button
5. Replace with:
   ```
   postgresql://postgres:gTpjdkGJBLBjdFGT@db.fykzoburtipislgjrcjm.supabase.co:5432/postgres
   ```
6. Click **Save Changes**
7. Wait for automatic redeployment (~3-5 minutes)

**Status:** [ ] Pending

---

### 2. WAIT FOR DEPLOYMENT

After saving DATABASE_URL, Render will:
- Automatically redeploy the application
- Run database migrations
- Create all tables in Supabase

**Watch for:** "Deploy succeeded" message in Render dashboard

**Estimated Time:** 3-5 minutes

**Status:** [ ] Pending

---

### 3. RESTORE MEMBER DATA

Once deployment succeeds:

#### Option A: Via Render Shell (Recommended)
1. Go to Render Dashboard → Your Service
2. Click **Shell** tab
3. Run this command:
   ```bash
   python manage.py loaddata backups/render_production_20260502_061326.json
   ```
4. Wait for success message

#### Option B: From Local Machine
```bash
cd "C:\Users\Wisdom Godswill\Desktop\mysite\MY-SITE"
$env:DATABASE_URL="postgresql://postgres:gTpjdkGJBLBjdFGT@db.fykzoburtipislgjrcjm.supabase.co:5432/postgres"
python manage.py loaddata backups\render_production_20260502_061326.json
```

**Expected Output:**
```
Installed 13 user objects
Installed 2 deposit objects
Installed X investment objects
...
```

**Status:** [ ] Pending

---

### 4. VERIFY MIGRATION SUCCESS

Visit: https://elitewealthcapita.uk/admin/

**Login:**
- Email: admin@elitewealthcapita.uk
- Password: myfavour1$

**Check These:**
- [ ] Can login to admin panel
- [ ] Users table shows 13 members
- [ ] Deposits table shows 2 deposits
- [ ] Investment plans are visible
- [ ] Site loads without errors
- [ ] Dashboard accessible
- [ ] No database connection errors

**Status:** [ ] Pending

---

### 5. TEST MEMBER LOGIN

Pick a test user and verify:
- [ ] Member can login
- [ ] Dashboard loads correctly
- [ ] Investment history visible
- [ ] Profile data intact
- [ ] Balance information correct

**Status:** [ ] Pending

---

## 📊 DATA TO BE RESTORED

From backup: `backups/render_production_20260502_061326.json` (110KB)

**Contents:**
- ✅ 13 Users (all member accounts)
- ✅ 2 Deposits (deposit records)
- ✅ User Profiles (KYC, avatars, referrals)
- ✅ Investment Plans (all active plans)
- ✅ Site Settings (company info, configs)
- ✅ Crypto Tickers (20 cryptocurrencies)
- ✅ Admin Settings (permissions, security)

---

## 🔐 CREDENTIALS

**Supabase:**
- Project: fykzoburtipislgjrcjm
- Dashboard: https://supabase.com/dashboard/project/fykzoburtipislgjrcjm
- Database Password: gTpjdkGJBLBjdFGT ⚠️ Keep secure!

**Website Admin:**
- URL: https://elitewealthcapita.uk/admin/
- Email: admin@elitewealthcapita.uk
- Password: myfavour1$

---

## ⚠️ TROUBLESHOOTING

### Problem: "Connection refused"
**Solution:** Verify DATABASE_URL is exactly:
```
postgresql://postgres:gTpjdkGJBLBjdFGT@db.fykzoburtipislgjrcjm.supabase.co:5432/postgres
```

### Problem: "Relation does not exist"
**Solution:** Wait for migrations to complete (check deployment logs)

### Problem: "Data restore fails"
**Solution:** 
1. Check deployment succeeded first
2. Try alternative backup: `render_production_20260502_060905.json`
3. Verify connection string is correct

### Problem: "Admin login fails"
**Solution:** Data not restored yet - complete Step 3 first

---

## 📞 SUPPORT

**Supabase Docs:** https://supabase.com/docs  
**Render Support:** https://render.com/docs  
**Django Migrations:** https://docs.djangoproject.com/en/4.2/topics/migrations/

---

## ✅ COMPLETION CHECKLIST

Once all steps complete:

- [ ] Render environment updated
- [ ] Deployment succeeded
- [ ] Data restored (all 13 users)
- [ ] Admin panel accessible
- [ ] Members can login
- [ ] No errors on site
- [ ] FCA/SEC claims removed (already done!)
- [ ] Site fully operational

---

**Current Step:** UPDATE RENDER ENVIRONMENT VARIABLE

**Next Action:** Go to https://dashboard.render.com/ and update DATABASE_URL

**Questions?** Mark completed items as [x] and track your progress!
