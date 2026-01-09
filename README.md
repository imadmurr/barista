# 🍸 Barista AI

**Course:** Mobile Programming with Flutter  
**Instructor:** Dr. Mohamad Aoude  

**Students:**  
- Clovis Abou Kheir  
- Imad El Murr  

---

Barista AI is a Flutter mobile app that lets users **discover**, **search**, **favorite**, and **create** cocktail recipes with the help of **AI-powered generation** and **beautiful animated visuals**.

The app combines modern UI, smooth animations, and Firebase-backed data to deliver a premium cocktail discovery experience.

---

## ✨ Features

### 🔍 Discover
- Browse a curated list of cocktails from Firestore
- Filter by flavor, vibe, or category
- Beautiful gradient cards with smooth transitions

### 🔎 Search
- Real-time search across cocktail names, descriptions, and tags
- Firestore-backed data with client-side filtering

### ⭐ Favorites (Per User)
- Favorite cocktails are stored **per authenticated user**
- Synced in real time using Firestore
- Works across devices when signed in

### 🎬 Cocktail Details
- Full recipe view with ingredients and step-by-step instructions
- Animated “how it’s made” visualization for each cocktail
- Smooth Hero animations between screens

### 🤖 Create (AI)
- Generate custom cocktail recipes using generative AI
- Designed to save generated recipes to Firestore (future extension)

### 🔐 Authentication
- Email & password authentication using Firebase Auth
- Auth is **required to use the app**
- Clean onboarding → sign-in → app flow

---

## 🏗 Tech Stack

- **Flutter** (Material 3)
- **Firebase**
  - Firestore (cocktail data, favorites)
  - Firebase Authentication (email/password)
- **Provider** (state management)
- **GoRouter** (navigation & auth guards)
