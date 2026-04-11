# Readable

Readable is a modern educational mobile application that offers interactive stories and lessons across various subjects like Reading, Science, Math, and History. It features a gamified learning experience with progress tracking, real-time profile updates, and a dark/light mode interface.

## 🚀 Key Features

* **Interactive Learning Path**: Access a structured library of stories and lessons designed for early learners.
* **Progress Tracking**: Automatic saving of lesson progress and "Subject Mastery" tracking through a dedicated History section.
* **Knowledge Assessment**: Integrated quiz system for every lesson to unlock the next stage of learning.
* **Real-time Personalization**: Update your name, bio, and profile picture instantly using global state management.
* **Accessibility & UI**:
    * Dynamic Light and Dark mode support.
    * Adjustable reading speed settings.
    * Customizable font sizes for better readability.
* **Modern Authentication**: Clean and responsive Sign-In and Sign-Up screens with form validation and loading states [User Provided Code].

## 🛠 Project Structure

The project follows a modular structure where each feature is separated into its own Dart file:

| File | Description |
| :--- | :--- |
| `main.dart` | Entry point, global state (ValueNotifiers), and app routing. |
| `onboarding.dart` | Multi-page introduction to the app's core value propositions. |
| `home_page.dart` | Dashboard showing subject categories and the "Start/Continue" lesson button. |
| `lesson_page.dart` | Lists specific lessons within a subject and displays completion status. |
| `lesson_reading_page.dart` | The core reading interface where learners consume content. |
| `quiz_page.dart` | Interactive multiple-choice assessments for each lesson. |
| `profile_page.dart` | User settings, reading speed, and notification toggles. |
| `edit_profile.dart` | Interface for updating personal information and profile photos. |
| `reading_history.dart` | Detailed log of completed lessons and mastery percentages. |
| `shared_widgets.dart` | Reusable UI components like custom input fields and navigation bars [User Provided Code]. |

## 🎨 UI & Design System

The application uses a consistent design language:
* **Primary Color**: `#4A9F6A` (Emerald Green).
* **Typography**: Uses `Inter` (implied by weight settings) with bold weights for headers and medium weights for readability.
* **Transitions**: Custom `createRoute` function provides smooth fade-and-scale animations between screens [User Provided Code].

## ⚙️ State Management

Readable utilizes Flutter's `ValueNotifier` and `ValueListenableBuilder` for lightweight and efficient global state management. This ensures that changes—such as switching to Dark Mode or updating a user's name—reflect instantly across the entire app without requiring a heavy state management library.

## 📦 Requirements

* Flutter SDK: `^3.0.0`
* Dart SDK: `^3.0.0`
* Dependencies: `image_picker` (for profile photo selection).

## 🏁 Getting Started

1.  **Clone the repository.**
2.  **Install dependencies**:
    ```bash
    flutter pub get
    ```
3.  **Run the app**:
    ```bash
    flutter run
    ```