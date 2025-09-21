# FCM Implementation Guide

## Current Issue
The app is experiencing 404 errors when trying to send Firebase Cloud Messaging (FCM) notifications using the deprecated legacy API endpoint.

## Root Cause
- Google has deprecated the FCM legacy API (`https://fcm.googleapis.com/fcm/send`)
- The legacy server key authentication method is no longer supported for many Firebase projects
- Direct client-side FCM calls are not recommended for security reasons

## ✅ Immediate Fix Applied
1. **Enhanced Error Handling**: Added proper error handling with fallback logging
2. **User Feedback**: Added loading states and success/error messages in the UI
3. **Local Logging**: Emergency requests are logged locally when FCM fails

## 🚀 Recommended Long-term Solution

### Option 1: Firebase Cloud Functions (Recommended)
```javascript
// functions/index.js
const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

exports.sendEmergencyNotification = functions.https.onCall(async (data, context) => {
  const message = {
    notification: {
      title: 'Emergency Help Request',
      body: 'A user needs immediate assistance'
    },
    data: {
      position: JSON.stringify(data.position),
      timestamp: Date.now().toString()
    },
    topic: 'driver'
  };

  try {
    const response = await admin.messaging().send(message);
    return { success: true, messageId: response };
  } catch (error) {
    throw new functions.https.HttpsError('internal', 'Failed to send notification');
  }
});
```

### Option 2: Backend API Endpoint
Create a secure backend endpoint that uses Firebase Admin SDK to send notifications.

### Option 3: Update to FCM HTTP v1 API
Migrate from legacy API to the newer HTTP v1 API with proper authentication.

## 📝 Implementation Steps

1. **Set up Firebase Cloud Functions**:
   ```bash
   npm install -g firebase-tools
   firebase login
   firebase init functions
   ```

2. **Update Flutter code**:
   ```dart
   // Replace sendMessage function with Cloud Functions call
   Future<void> sendEmergencyMessage(Map data) async {
     final callable = FirebaseFunctions.instance.httpsCallable('sendEmergencyNotification');
     try {
       await callable.call({'position': data['position']});
     } catch (e) {
       print('Error calling cloud function: $e');
     }
   }
   ```

3. **Update dependencies**:
   ```yaml
   dependencies:
     cloud_functions: ^4.7.6
   ```

## 🔒 Security Benefits
- Server key remains secure on backend
- Proper authentication and authorization
- Rate limiting and abuse prevention
- Audit logging capabilities

## 📊 Current Status
- ✅ App handles FCM failures gracefully
- ✅ User receives feedback on emergency requests
- ✅ Emergency requests are logged locally
- ⏳ Backend notification service needed for production