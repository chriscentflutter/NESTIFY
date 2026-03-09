# 🏠 Nestify — Nigerian Real Estate App

**Nestify** is a modern, feature-rich Flutter application for renting, buying, and managing properties across Nigeria. Built with a sleek dark-mode-first UI featuring a red and black color scheme, smooth animations, and comprehensive property management features.

---

## ✨ Features

### 🔐 Authentication
- User login & signup with email/password
- Agent registration with NIN verification
- Forgot password flow
- Agent application review status tracking

### 🏡 Property Management
- Browse properties by category (Apartments, Offices, Houses, Land)
- Featured properties carousel on home screen
- Grid & list view toggle for property listings
- Detailed property pages with image gallery, features, amenities, and location map
- Filter by rent vs. sale

### 👤 User Experience
- Animated splash screen with wave background effects
- Custom bottom navigation bar with favorites center button
- Dark/Light theme toggle
- Language selection (English, French, Spanish)
- Profile management with stats dashboard
- Favorites system with local persistence

### 📅 Agent Interaction
- Schedule property visitations with date & time picker
- Contact agent via phone call or in-app messaging
- Appointment confirmation screen
- Payment integration (Paystack & Flutterwave)

### 🛡️ Admin Panel
- Admin dashboard for property management
- Agent application review & approval
- Property submission management
- Admin management screen

### ⚙️ Settings
- Notification preferences
- Privacy & Security settings
- Help & Support with FAQ
- About page with app information

---

## 🛠️ Tech Stack

| Category | Technology |
|----------|-----------|
| **Framework** | Flutter (Dart SDK ^3.8.1) |
| **State Management** | Provider |
| **Authentication** | Firebase Auth, Google Sign-In |
| **Database** | Cloud Firestore |
| **Storage** | Firebase Storage |
| **Maps** | Google Maps Flutter |
| **Location** | Geolocator, Geocoding |
| **Payments** | Flutterwave Standard, Flutter Paystack |
| **Local Storage** | SharedPreferences, Hive |
| **Networking** | Dio, HTTP |
| **Notifications** | Firebase Messaging, Flutter Local Notifications |
| **UI Components** | Carousel Slider, Cached Network Image, Photo View |

---

## 📁 Project Structure

```
lib/
├── main.dart                         # App entry point & route definitions
├── config/
│   └── theme/
│       ├── app_colors.dart           # Color palette (dark & light mode)
│       ├── app_text_styles.dart      # Typography system
│       └── app_theme.dart            # ThemeData definitions
├── core/
│   ├── providers/
│   │   └── theme_provider.dart       # Theme state management
│   └── widgets/
│       ├── animated_button.dart      # Animated & gradient buttons
│       ├── category_card.dart        # Slanted category cards
│       ├── custom_bottom_nav.dart    # Custom bottom navigation bar
│       ├── custom_button.dart        # Standard button components
│       ├── custom_text_field.dart    # Text input & search fields
│       ├── property_card.dart        # Property listing card
│       └── wave_background.dart      # Animated wave background
├── data/
│   ├── models/
│   │   ├── property_model.dart       # Property data model
│   │   ├── user_model.dart           # User data model
│   │   ├── agent_application.dart    # Agent application model
│   │   └── property_submission.dart  # Property submission model
│   ├── providers/
│   │   └── favorites_provider.dart   # Favorites state management
│   └── services/
│       └── mock_data_service.dart    # Mock data for development
└── presentation/
    └── screens/
        ├── splash/                   # Splash screen
        ├── onboarding/               # Onboarding walkthrough
        ├── auth/                     # Login, Signup, Agent signup, etc.
        ├── home/                     # Home screen with bottom nav
        ├── property/                 # Listings, detail, payment, etc.
        ├── favorites/                # Favorited properties
        ├── profile/                  # User profile & preferences
        ├── admin/                    # Admin dashboard & management
        └── settings/                 # About, notifications, help, privacy
```

---

## 🗺️ Navigation Flow

```
Splash → Onboarding → Login/Signup
                           ↓
                     Home Screen (Bottom Nav)
                     ├── 🏠 Home
                     │   ├── Categories → Property Listing → Property Detail
                     │   │                                     ├── Schedule Visitation → Confirmation
                     │   │                                     ├── Contact Agent
                     │   │                                     └── Payment
                     │   ├── Featured Properties → Property Detail
                     │   └── Quick Actions (Buy/Rent) → Property Listing
                     ├── 🔍 Search (Property Listings)
                     ├── ❤️ Favorites (Center Button)
                     ├── 💬 Help & Support
                     └── 👤 Profile
                         ├── Notifications Settings
                         ├── Privacy & Security
                         ├── Help & Support
                         ├── About
                         ├── Admin Dashboard → Agent Applications
                         └── Logout → Login
```

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (^3.8.1)
- Dart SDK (^3.8.1)
- Android Studio / VS Code with Flutter extensions
- Firebase project configured (optional for web preview)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd NESTIFY
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   # Android
   flutter run

   # Web (Chrome/Edge)
   flutter run -d chrome

   # iOS
   flutter run -d ios
   ```

### Firebase Configuration (Optional)

The app gracefully handles missing Firebase config and will run without it. To enable Firebase features:

1. Create a Firebase project at [console.firebase.google.com](https://console.firebase.google.com)
2. Add Android/iOS/Web apps to your Firebase project
3. Run FlutterFire CLI:
   ```bash
   dart pub global activate flutterfire_cli
   flutterfire configure
   ```
4. This generates `lib/firebase_options.dart` — update `main.dart` to use it:
   ```dart
   await Firebase.initializeApp(
     options: DefaultFirebaseOptions.currentPlatform,
   );
   ```

### Google Maps Setup

Add your Google Maps API key:
- **Android**: `android/app/src/main/AndroidManifest.xml`
- **iOS**: `ios/Runner/AppDelegate.swift`

---

## 📱 Screens Overview

| Screen | Description |
|--------|-------------|
| **Splash** | Animated logo with wave background |
| **Onboarding** | 3-page walkthrough introducing the app |
| **Login/Signup** | Email authentication with social sign-in |
| **Agent Signup** | Agent registration with NIN verification |
| **Home** | Featured properties, categories, quick actions |
| **Property Listing** | Grid/list view with search & filters |
| **Property Detail** | Image gallery, features, map, agent info |
| **Schedule Visitation** | Date & time picker for property visits |
| **Contact Agent** | In-app messaging with agent |
| **Payment** | Paystack/Flutterwave integration |
| **Favorites** | Saved properties list |
| **Profile** | User info, theme toggle, language, settings |
| **Admin Dashboard** | Property & agent management |
| **Settings** | Notifications, privacy, help, about |

---

## 🎨 Design System

- **Color Palette**: Deep Red (#C41E3A) + Rich Black (#0A0A0A) with gradient accents
- **Typography**: Material Design type scale with custom weights
- **Components**: Rounded corners (30px cards), gradient buttons, wave backgrounds
- **Theme**: Dark-mode-first with full light-mode support
- **Animations**: Splash fade/scale, shimmer buttons, wave background, carousel auto-play

---

## 📄 License

This project is proprietary. All rights reserved.
