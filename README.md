<div align="center">

# 🧘 Pause & Unscroll

**Pause and replace scrolling with mindful activities focused on self-growth.**

[![Flutter](https://img.shields.io/badge/Flutter-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![Firebase](https://img.shields.io/badge/Firebase-FFCA28?logo=firebase&logoColor=black)](https://firebase.google.com)
[![State Management](https://img.shields.io/badge/State-GetX-8A2BE2)](https://pub.dev/packages/get)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS-3DDC84)](#)

<a href="https://play.google.com/store/apps/details?id=com.pauseandunscroll">
  <img alt="Get it on Google Play" src="https://play.google.com/intl/en_us/badges/static/images/badges/en_badge_web_generic.png" width="200"/>
</a>

</div>

---

## 📖 About

In a world filled with endless notifications and social media feeds, **Pause & Unscroll** encourages you to redirect your attention toward meaningful, mindful activities that support your wellbeing, productivity, and personal growth.

Whether you want to take a break from social media, build healthier habits, or simply be more present, the app gives you simple tools to make the most of your time.

> 🚀 **Live on Google Play:** [Pause and Unscroll](https://play.google.com/store/apps/details?id=com.pauseandunscroll)

---

## 📱 Screenshots

<div align="center">
  <table>
    <tr>
      <td align="center"><b>Home</b><br/><br/><img src="screenshots/home.png" width="240" alt="Home"/></td>
      <td align="center"><b>Breathing &amp; Meditation</b><br/><br/><img src="screenshots/breathing.png" width="240" alt="Breathing"/></td>
    </tr>
    <tr>
      <td align="center"><b>Meditation Timer</b><br/><br/><img src="screenshots/meditation_timer.png" width="240" alt="Meditation Timer"/></td>
      <td align="center"><b>Planning</b><br/><br/><img src="screenshots/planning.png" width="240" alt="Planning"/></td>
    </tr>
  </table>
</div>

---

## ✨ Features

- 🏠 **Wellness Dashboard**: daily wellness score, streaks (hydration, journaling), daily inspirational quote, and a snapshot of today's progress
- 🌬️ **Breathing Exercises**: guided mindful breathing techniques
- 🎵 **Meditation**: relaxing music with a customizable timer (up to 120 minutes)
- ✅ **To-Do Lists**: daily, weekly, and recurring tasks with gentle reminders
- 📊 **Daily Progress Tracker**: log hydration, meditation, mood, and workout activity
- 📓 **Personal Journaling**: reflect and record your thoughts
- 🍎 **Nourishment**: nutrition and self-care guidance
- 📅 **Calendar**: view and plan your days
- 🎯 **Goal Setting & Habit Tracking**
- 💬 **Daily Motivation**: fresh quotes every day
- 🔔 **Push Notifications**: timely reminders and motivation via Firebase Cloud Messaging
- 🔐 **Secure Authentication**: email/password, Google Sign-In, and Sign in with Apple

---

## 🛠️ Tech Stack

| Category | Technology |
|---|---|
| **Framework** | [Flutter](https://flutter.dev) & Dart |
| **State Management** | [GetX](https://pub.dev/packages/get) |
| **Networking / REST APIs** | [Dio](https://pub.dev/packages/dio) |
| **Local Storage** | [SharedPreferences](https://pub.dev/packages/shared_preferences) |
| **Authentication** | Email/Password, Google Sign-In, Apple Sign-In |
| **Push Notifications** | Firebase Cloud Messaging (FCM) |
| **Backend Services** | Firebase |

---

## 🏗️ Architecture

The project uses a **feature-first structure with GetX**. Every screen lives in its own folder and is split into four files (binding, logic, state, view), so UI, business logic, and state stay cleanly separated.

```
lib/
├── backend/                  # API layer (Dio client, services, models)
├── dialogs/                  # Reusable dialogs
├── utils/                    # Constants, helpers, themes
├── widgets/                  # Shared reusable widgets
├── view/
│   ├── splash_screen/
│   ├── login_screen/
│   ├── register_screen/
│   ├── dashboard_screen/     # Bottom navigation host
│   ├── home_screen/
│   ├── breathing_exercises/  # Breathing & meditation
│   ├── planning_screen/
│   ├── todo_screen/
│   ├── journal_screen/
│   ├── daily_progress/
│   ├── nourishment_screen/
│   ├── inspiration_screen/
│   ├── calendar_screen/
│   │   ├── calendar_screen_binding.dart   # Dependency injection
│   │   ├── calendar_screen_logic.dart     # Business logic (GetxController)
│   │   ├── calendar_screen_state.dart     # Observable state
│   │   └── calendar_screen_view.dart      # UI
│   ├── notification_screen/
│   └── profile_screen/
└── main.dart
```

Each feature follows the same pattern:

| File | Responsibility |
|---|---|
| `*_binding.dart` | Registers the controller with GetX dependency injection |
| `*_logic.dart` | `GetxController` holding business logic and API calls |
| `*_state.dart` | Reactive (`.obs`) state kept separate from logic |
| `*_view.dart` | Pure UI that listens to the controller |

### Key Implementation Notes

- **GetX** handles state management, dependency injection (`Bindings`), and navigation. The logic/state split keeps controllers small and easy to test.
- **Dio** is configured with a base client and interceptors for headers, auth tokens, logging, and centralized error handling.
- **SharedPreferences** persists user session, preferences, and lightweight app data.
- **Firebase Messaging** handles foreground, background, and terminated-state notifications.
- **Social login** supports Google and Apple sign-in alongside email/password.

---

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (stable channel)
- Android Studio or VS Code with Flutter plugin
- A Firebase project
- Xcode (for iOS builds, macOS only)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/<your-username>/<your-repo-name>.git
   cd <your-repo-name>
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Set up Firebase**
   - Create a project in the [Firebase Console](https://console.firebase.google.com)
   - Add your Android app and download `google-services.json` → place in `android/app/`
   - Add your iOS app and download `GoogleService-Info.plist` → place in `ios/Runner/`
   - Enable **Authentication** (Email/Password, Google, Apple) and **Cloud Messaging**

4. **Configure the API**
   - Add your base URL and keys in the environment/config file (for example `lib/core/network/api_constants.dart`)

5. **Run the app**
   ```bash
   flutter run
   ```

### Build Release

```bash
# Android App Bundle
flutter build appbundle --release

# iOS
flutter build ipa --release
```

---

## 🔒 Security Notice

Sensitive files are intentionally **not** committed to this repository. Add them to `.gitignore` and provide your own:

- `google-services.json`
- `GoogleService-Info.plist`
- `key.properties` and keystore files (`*.jks`)
- API keys and secrets

---

## 🗺️ Roadmap

- [ ] Home-screen widgets
- [ ] Dark mode
- [ ] Multi-language support
- [ ] Unit & widget test coverage
- [ ] Offline-first sync improvements

---

## 🤝 Contributing

Contributions, issues, and feature requests are welcome!

1. Fork the project
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m "Add amazing feature"`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## 📄 License

Distributed under the MIT License. See [`LICENSE`](LICENSE) for more information.

---

## 📬 Contact

**Developer:** `<Your Name>`
**Email:** `<your-email>`
**LinkedIn:** `<your-linkedin>`
**GitHub:** [`@<your-username>`](https://github.com/<your-username>)

---

<div align="center">

⭐ If you like this project, please consider giving it a star!

*Pause. Breathe. Unscroll.*

</div>
