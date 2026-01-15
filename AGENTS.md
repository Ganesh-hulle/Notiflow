# AI Agent Guide (NotiFlow)
This guide helps AI coding agents understand the NotiFlow project, architecture, and workflows. Read before making changes.

# NotiFlow Project Architecture & Guide

NotiFlow is a Flutter application designed for internal college notifications (Director -> HOD -> Employee).

## 🚀 Technical Stack

| Category | Technology | Package(s) |
|----------|------------|------------|
| **Framework** | Flutter | `flutter` |
| **Language** | Dart | `dart` |
| **State Management** | BLoC | `flutter_bloc`, `equatable` |
| **Backend / BaaS** | Firebase (Planned) | `firebase_auth`, `cloud_firestore` (Future Integration) |
| **Mocking** | In-Memory / Repos | Local Mock Repositories for now |
| **UI Components** | Google Fonts | `google_fonts`, `dropdown_button2` |

---

## 📂 Project Structure

The project follows a **Feature-First** architecture.

```
lib/
├── auth/                  # Authentication feature
│   ├── bloc/              # AuthBloc
│   ├── screens/           # Login, Profile Setup
│   └── models/            # User model
├── notifications/         # Notifications feature
│   ├── bloc/              # NotificationBloc
│   ├── screens/           # Home (Received), Sent
│   ├── models/            # Notification model
│   └── repository/        # Notification Repository (Mock)
├── settings/              # Settings feature
│   └── screens/           # Settings Page
├── theme/                 # App styling
├── widgets/               # Shared UI components
├── main.dart              # Entry point
└── ...
```

---

## 🏗 Core Flow

### 1. Authentication
-   **Login**: Users sign in via Google (Mock for now).
-   **Profile Setup**: Users select Profile Color, Name, and Role (Director, HOD, Employee).
-   **State**: `AuthBloc` manages authentication status.

### 2. Notifications
-   **Received**: Displayed on Home Screen using Cards (Sender Name, Color, Message).
-   **Sent**: Displayed on Sent Screen.
-   **Data**: Currently served via `MockNotificationRepository`.

---

## 🛠 Tasks
- [ ] Implement Auth UI (Login & Profile Setup).
- [ ] Implement Home & Sent Screens.
- [ ] Implement Settings.
- [ ] Prepare for Firebase Integration.


