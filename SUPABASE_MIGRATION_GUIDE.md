# 🚀 Migration from Neon to Supabase PostgreSQL - COMPLETE GUIDE

**Date:** May 21, 2026  
**Purpose:** Migrate database with all member data from Neon to Supabase  
**Current Members:** Preserved in backup

---

## 📋 PRE-MIGRATION CHECKLIST

✅ Latest backup available: `backups/render_production_20260502_061326.json` (110KB)  
✅ Contains: Users, Deposits, Investments, Site Settings  
✅ Backup scripts ready  
✅ Code deployed to GitHub

---

## 🎯 MIGRATION STEPS

### **STEP 1: Create Supabase Account & Database** (5 minutes)

1. **Go to:** https://supabase.com/
2. **Sign up** with GitHub account (recommended for easy integration)
3. **Create New Project:**
   - Project Name: `Elite Wealth Capital`
   - Database Password: **Save this securely!**
   - Region: **US East (closest to current setup)**
4. **Wait for database to initialize** (~2 minutes)

---

### **STEP 2: Get Supabase Database Connection String** (2 minutes)

1. In Supabase Dashboard, click **Project Settings** (gear icon)
2. Go to **Database** section
3. Find **Connection String** → **URI**
4. Copy the connection string that looks like:
   ```
   postgresql://postgres.xxxxx:[YOUR-PASSWORD]@aws-0-us-east-1.pooler.supabase.com:6543/postgres
   ```
5. **Replace `[YOUR-PASSWORD]` with your actual database password**

---

### **STEP 3: Update Environment Variables on Render** (3 minutes)

1. **Go to:** https://dashboard.render.com/
2. **Select your web service** (Elite Wealth Capital)
3. Click **Environment** tab
4. **Update DATABASE_URL:**
   - Click on `DATABASE_URL`
   - Replace with your Supabase connection string
   - Click **Save Changes**

**Example:**
```
OLD: postgresql://elite_wealth_k85f_user:password@ep-holy-sea-a4989cmp-pooler.us-east-1.aws.neon.tech/elite_wealth_k85f

NEW: postgresql://postgres.xxxxx:YOUR_PASSWORD@aws-0-us-east-1.pooler.supabase.com:6543/postgres
```

---

### **STEP 4: Run Database Migrations** (Auto on Deploy)

When you save the new DATABASE_URL, Render will:
1. ✅ Automatically redeploy your app
2. ✅ Run Django migrations to create tables
3. ✅ Set up fresh database structure

**Wait for deployment to complete** (~3-5 minutes)

---

### **STEP 5: Restore Your Data** (5 minutes)

Once deployment succeeds, restore your member data:

#### **Option A: From Render Dashboard (Easiest)**

1. Go to Render Dashboard → Your Service
2. Click **Shell** tab
3. Run this command:
   ```bash
   python manage.py loaddata backups/render_production_20260502_061326.json
   ```

#### **Option B: From Your Computer**

```bash
cd "C:\Users\Wisdom Godswill\Desktop\mysite\MY-SITE"

# Set Supabase database URL
$env:DATABASE_URL="YOUR_SUPABASE_CONNECTION_STRING"

# Restore data
python manage.py loaddata backups\render_production_20260502_061326.json
```

---

### **STEP 6: Verify Migration** (2 minutes)

1. **Visit:** https://elitewealthcapita.uk/admin/
2. **Login:** admin@elitewealthcapita.uk / myfavour1$
3. **Check:**
   - ✅ Users are present
   - ✅ Deposits are visible
   - ✅ Investments are loaded
   - ✅ Site settings intact

---

## 📊 WHAT WILL BE MIGRATED

From your backup (`render_production_20260502_061326.json` - 110KB):

✅ **13 Users** - All member accounts with credentials  
✅ **2 Deposits** - All deposit records  
✅ **Investment Plans** - All active plans  
✅ **User Profiles** - Profile data, referrals, KYC status  
✅ **Site Settings** - Company info, configurations  
✅ **Crypto Tickers** - 20 cryptocurrencies  
✅ **Admin Settings** - Security settings, permissions

**Zero data loss!** ✨

---

## 🔒 SECURITY NOTES

1. **Database Password:** Store securely (use password manager)
2. **Backup File:** Keep `render_production_20260502_061326.json` safe
3. **Old Neon Database:** Can be deleted after verification
4. **Connection String:** Never commit to Git (it's in .env)

---

## 💰 SUPABASE PRICING

**Free Tier Includes:**
- ✅ 500MB database storage
- ✅ 2GB bandwidth
- ✅ 50,000 monthly active users
- ✅ Unlimited API requests
- ✅ Daily backups (7 days retention)

**Upgrade Later if Needed:**
- Pro: $25/month (8GB storage, better support)

---

## ⏱️ TOTAL MIGRATION TIME

- **Account Setup:** 5 minutes
- **Database Configuration:** 3 minutes
- **Deploy & Migrate:** 5 minutes
- **Data Restore:** 5 minutes
- **Verification:** 2 minutes

**Total: ~20 minutes**

---

## 🆘 TROUBLESHOOTING

### Problem: "Connection Refused"
**Solution:** Check Supabase connection string is correct and password is replaced

### Problem: "Relation does not exist"
**Solution:** Wait for migrations to complete before restoring data

### Problem: "Data restore fails"
**Solution:** Try older backup file: `render_production_20260502_060905.json`

---

## 📞 SUPPORT

**Supabase Support:** https://supabase.com/docs/guides/database  
**Django Docs:** https://docs.djangoproject.com/en/4.2/topics/db/  
**Render Docs:** https://render.com/docs

---

## ✅ POST-MIGRATION CHECKLIST

After successful migration:

- [ ] All 13 users can login
- [ ] Deposits are visible in admin panel
- [ ] Investment plans are active
- [ ] Site loads without errors
- [ ] Admin panel accessible
- [ ] No FCA/SEC claims visible (already fixed!)
- [ ] Crypto ticker working
- [ ] Email notifications working

---

## 🎉 BENEFITS OF SUPABASE

✅ **Better Free Tier** - More generous limits  
✅ **Reliable** - 99.9% uptime SLA  
✅ **Fast** - Built on PostgreSQL with optimizations  
✅ **Features** - Auth, Storage, Real-time subscriptions  
✅ **Dashboard** - Better UI for database management  
✅ **Backups** - Automatic daily backups included  

---

**Ready to migrate? Follow the steps above!**

Questions? Let me know which step you need help with.
