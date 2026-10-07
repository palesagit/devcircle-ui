# DevCircle UI (Track 1) 🚀

Hi there! Welcome to my repository for **DevCircle UI**. This is my submission project for **Track 1: Introduction to Flutter and Dart**.

DevCircle is designed as a mini Discord-like platform created by a student (Palesa which is me), for other students. The goal of this project is to give peer developers a clean space to discuss tech topics, share learning resources, and schedule study group sessions together.

> **Note:** This repository focuses purely on the **frontend UI layer** built using Flutter & Dart with in-memory state management. For backend integration (Firebase Auth & Cloud Firestore), check out my companion repository: `devcircle-auth`.

---

## 📌 Project Overview

As a student developer, one of the biggest challenges I faced when starting out was finding an easy way to organize quick peer study sessions and share documentation links with my classmates. **DevCircle UI** solves this by providing three main hubs:

1. **💬 Topics & Chat UI**: Create discussion topics (e.g., `Flutter-dev`, `Algorithms`) and add messages in the local app state.
2. **🔗 Shared Resources Shelf**: Add developer resource titles and links to an in-app list.
3. **📅 Study Sessions & Meetings**: Schedule meetings with date and time pickers; upcoming meetings are sorted by start time.

This is a frontend prototype: messages, resources, and meetings are stored in memory and are not saved across app restarts or synced between users.

---

## 🎬 Project Demo & Presentation Guide

If you are evaluating my project or watching my presentation video, here is a step-by-step walkthrough of how to demo **DevCircle UI**:

### 1. Launch & Navigation (Bottom Bar)
* **What to show:** Open the app and highlight the bottom navigation bar (`NavigationBar` using Material 3).
* **Talking point:** *"Notice how switching between tabs preserves our app state smoothly using `IndexedStack` without re-rendering or losing our data."*

### 2. Creating a Topic & Sending Messages
* **What to do:**
  1. On the **Topics** tab, tap the `+` Floating Action Button.
  2. Enter a topic name like `Flutter-Tips` and tap **Save**.
  3. Tap on the newly created topic line to open the `ChatPage`.
  4. Type a message like *"Has anyone finished the Codelab?"* and press send.
* **Talking point:** *"Messages sent as the current user (`lee_codes`) appear on the right in the primary purple theme. The UI can align messages from other senders to the left, but this prototype does not generate peer replies."*

### 3. Adding a Learning Resource
* **What to do:**
  1. Switch to the **Resources** tab.
  2. Click the `+` FAB button to bring up the double-input modal (`Title` and `Link`).
  3. Enter `Flutter Docs` as Title and `docs.flutter.dev` as Link. Click **Save** to add it to the in-app list.
* **Talking point:** *"I built a reusable dynamic dialog helper function `askFields()` that accepts custom field labels and returns user inputs asynchronously."*

### 4. Scheduling a Study Meeting
* **What to do:**
  1. Switch to the **Meetings** tab.
  2. Tap `+` FAB, type meeting topic `Final Project Prep` and link `meet.jit.si/study-room`.
  3. Use the Flutter native **Date Picker** to choose a date, and the **Time Picker** to pick a time.
  4. Save and observe the topic and scheduled date/time in the list. Meeting links are currently collected but not displayed or opened.
* **Talking point:** *"When a meeting is saved, Dart's native `.sort()` method reorganizes the list so that the soonest scheduled study session always appears at the top!"*

---

## 🛠️ Built With & Technology Stack

* **Framework:** Flutter (v3.3.0+)
* **Language:** Dart
* **Design System:** Material 3 (`ColorScheme.fromSeed` with deep purple `#8E5FC1`)
* **State Management:** In-memory `StatefulWidget` & state hoisting
* **Navigation:** `IndexedStack` + `MaterialPageRoute`

---

## 🧠 Key Learnings as a Beginner Developer

Building this project taught me foundational software engineering and Flutter concepts:

1. **Stateful vs. Stateless Widgets**: Learning when to use `StatelessWidget` for static display and `StatefulWidget` with `setState()` to update the UI when lists change.
2. **Tab Preservation with `IndexedStack`**: Understanding how `IndexedStack` keeps tab state active in memory rather than discarding it when navigating.
3. **Asynchronous UI Flow (`async`/`await`)**: Handling user input modals, `showDatePicker`, and `showTimePicker`, while making sure to guard widget lifecycle using `if (!mounted) return;`.
4. **Data Modeling & Dart Collections**: Writing custom Dart classes (`Message`, `Resource`, `Meeting`) and utilizing list manipulation methods like `.putIfAbsent()` and `.sort()`.
5. **UI Ergonomics**: Creating responsive list layouts using `ListView.builder` for chat messages and `ListTile` for clean lists.

---

## ⚡ How to Run This Project Locally

Follow these simple commands to run the project on your machine:

```bash
# 1. Clone the repository
git clone https://github.com/palesagit/devcircle-ui.git

# 2. Move into the project directory
cd devcircle-ui

# 3. Generate platform folders if missing
flutter create --project-name devcircle_ui .

# 4. Fetch dependencies
flutter pub get

# 5. Run the app on an emulator or browser
flutter run
```

To run unit and widget tests:
```bash
flutter test
```

---

## 🔮 What's Next?

* **Backend Integration:** Connect `DevCircle UI` to Firebase Authentication and Cloud Firestore database (developed in `devcircle-auth`) so messages and study sessions persist across app restarts.
* **User Profiles:** Add student avatar customization and user bio cards.
* **Dark Mode Support:** Implement dynamic light/dark theme switching.

---

## 🤝 Community Engagement & Acknowledgments

* **Codelab Reference:** Built following guidance from the [Flutter First Codelab](https://codelabs.developers.google.com/codelabs/flutter-codelab-first).
* **Community:** Special thanks to the Flutter student community and my university peers for feedback on UI layout and usability!

---

*Thank you for checking out my Flutter Track 1 project! Feedback and suggestions are always welcome.* 😊

------------------------------------------------------------------------------------------------------------------
WTC-7WFDKS75
