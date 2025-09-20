# Firebase Configuration Security Guide

## 🚨 IMPORTANT: This file contains sensitive information and should NEVER be committed to version control!

## Setup Instructions for Team Members

### 1. Getting Firebase Credentials

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select the project: `health-care-app-791f6`
3. Go to Project Settings → General tab
4. Scroll down to "Your apps" section
5. Find the Android app (`com.example.health_care`)
6. Click the download button to get `google-services.json`

### 2. Installation

1. Download the `google-services.json` file from Firebase Console
2. Place it in: `android/app/google-services.json`
3. **DO NOT** commit this file to git - it's already in `.gitignore`

### 3. For iOS (if applicable)

1. Download `GoogleService-Info.plist` from Firebase Console
2. Place it in: `ios/Runner/GoogleService-Info.plist`
3. **DO NOT** commit this file to git

### 4. Security Best Practices

- ✅ Keep credentials in `.gitignore`
- ✅ Rotate API keys regularly
- ✅ Use Firebase App Check for production
- ✅ Restrict API keys to specific domains/apps
- ❌ Never commit credentials to version control
- ❌ Never share credentials in chat/email
- ❌ Never hardcode API keys in source code

### 5. Environment-Specific Configuration

For different environments (dev, staging, prod), use separate Firebase projects:
- Development: `health-care-app-dev`
- Staging: `health-care-app-staging`
- Production: `health-care-app-791f6`

### 6. If Credentials Are Compromised

1. Immediately revoke the API key in Firebase Console
2. Generate new credentials
3. Update local files
4. Remove from git history using `git filter-repo`
5. Force push to remove from remote repository

## Contact

If you need help setting up Firebase credentials, contact the project maintainer.