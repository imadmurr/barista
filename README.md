# 🍸 Barista AI

A Flutter mobile application for discovering, searching, favoriting, and previewing cocktail recipes with a polished, animated UI and Firebase-backed data storage.
Demo and report here: https://drive.google.com/drive/folders/1totkQoniIX4kvn_q5nIx9l6UtcX2qqIN?usp=sharing
---

## 📌 Project Overview

Barista AI is a university mobile programming project focused on delivering a premium cocktail discovery experience. The app combines a modern, dark visual style with smooth transitions, searchable data, and per-user favorites. A **Creator Studio** screen provides a mock “AI” cocktail generator flow that previews drink colors and attributes, demonstrating how an AI feature could be integrated in a future extension.

---

## ✨ Key Features

- **Discover feed** backed by Firestore with filter chips for tags and categories.
- **Search** across cocktail names, subtitles, and tags with client-side filtering.
- **Favorites per user** stored in Firestore and synchronized in real time.
- **Cocktail detail** view with ingredients, steps, and animated pour visualization.
- **Creator Studio** UI for mock cocktail generation + visual preview.
- **Firebase Authentication** with email/password onboarding flow.
- **GoRouter** navigation with route guards for auth and splash onboarding.

---

## 🧱 Architecture Overview

The project follows a clean separation of concerns:

- **`core/`**: Global config (theme, routing).
- **`data/`**: Data access layer (repositories + mock data + seeding).
- **`models/`**: Immutable data models (`Cocktail`, `Ingredient`).
- **`state/`**: App state controllers (auth + favorites) using Provider.
- **`presentation/`**: UI screens and widgets.

### Data Flow

1. **Repositories** read/write from Firebase (Firestore + Auth).
2. **State controllers** expose app state via `ChangeNotifier`.
3. **Screens** watch providers and render UI.

---

## 🗂️ Firestore Data Model

### `cocktails` collection
Each document represents a cocktail:

```json
{
  "id": "sunset_spritz",
  "name": "Sunset Spritz",
  "subtitle": "Citrus & berry layered spritz",
  "tags": ["Citrus", "Sparkling"],
  "ingredients": [{"amount": "60 ml", "name": "Orange juice"}],
  "steps": ["Fill glass with ice", "Top with soda"],
  "gradient": [4294967295, 4294967295],
  "layerColors": [4294967295, 4294967295],
  "createdAt": "<timestamp>"
}
```

### `users/{uid}/favorites` subcollection
Stores favorite cocktail IDs per authenticated user.

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.9.2 or newer)
- Firebase project configured for Android and iOS

### Install Dependencies

```bash
flutter pub get
```

### Firebase Configuration

This project uses `Firebase.initializeApp()` with default options. You must provide your own Firebase configuration:

1. Create a Firebase project.
2. Register Android and iOS apps.
3. Download and place:
   - `android/app/google-services.json`
   - `ios/Runner/GoogleService-Info.plist`
4. Enable **Email/Password Auth** in Firebase Authentication.
5. Create a Firestore database in **test mode** or with rules.

### Run the App

```bash
flutter run
```

---

## 🧪 Seeding Firestore Data (Optional)

In debug builds you can seed Firestore with mock cocktails:

- Use `FirestoreSeeder.seedIfNeeded()` from `lib/seed_firestore.dart`.
- The seeder prevents duplicate seed runs by writing a `_meta/seed_v1` marker.

---

## 🧰 Useful Commands

```bash
flutter analyze
flutter test
```

---

## 📄 Technical Report

A complete LaTeX technical report is provided in:

```
docs/technical_report.tex
```

You can compile it with:

```bash
pdflatex docs/technical_report.tex
```

---

## 📁 Project Structure

```
lib/
  core/              # Routing + theme
  data/              # Firebase + mock data repositories
  models/            # Cocktail + ingredient models
  presentation/      # UI screens
  state/             # Auth + favorites controllers
  main.dart           # App entry point
```

---

## ✅ Status

This is a completed university prototype. Future extensions may include:

- Real AI integration (OpenAI / Vertex API)
- Profile personalization
- Admin dashboard for cocktail uploads
- Offline caching

---

## 👥 Team

- Clovis Abou Kheir
- Imad El Murr

**Course:** Mobile Programming with Flutter  
**Instructor:** Dr. Mohamad Aoude
