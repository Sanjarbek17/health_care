# 🔧 FCM Setup Fix Guide

## Issue Found
Your FCM is failing with 404 errors because of incomplete Firebase setup.

## ✅ **Steps to Fix FCM Setup**

### Step 1: Download google-services.json
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select project: `health-care-app-791f6`
3. Click the ⚙️ gear icon → **Project Settings**
4. Scroll down to **"Your apps"** section
5. Find your Android app: `com.example.health_care`
6. Click the **Download** button to get `google-services.json`
7. Place the file in: `android/app/google-services.json`

### Step 2: Enable Cloud Messaging API
1. In Firebase Console, go to **Cloud Messaging** (left sidebar)
2. If you see "Cloud Messaging API is disabled", click **Enable**
3. Note down the **Server Key** (it should start with "AAAA...")

### Step 3: Update Server Key
1. In Firebase Console → Cloud Messaging
2. Copy the **Server Key**
3. Replace the hardcoded key in your `functions.dart` file

### Step 4: Verify Setup
After completing steps 1-3, run the app and test the emergency button.

## 🔍 **Current Configuration Found**
- ✅ Project ID: `health-care-app-791f6`
- ✅ Sender ID: `392841827787`
- ✅ App ID: `1:392841827787:android:8e6c6c81f6c2540ca4924e`
- ❌ google-services.json: **MISSING**
- ❓ Server Key: **NEEDS VERIFICATION**

## 🚨 **Most Likely Cause of 404 Error**
The missing `google-services.json` file means your app can't properly authenticate with Firebase services, causing the 404 error.

## 📝 **After Setup**
Once you complete these steps, the FCM should work properly and you'll stop seeing the 404 errors.