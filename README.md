# DevCircle UI - Track 1: Introduction to Flutter and Dart

**DevCircle** is a mini Discord for software engineering students: a place to discuss topics, share learning resources and schedule study meetings.
This repository is my **Track 1** submission: the **user interface**, built with **Flutter and Dart**.

> This is a front-end prototype. Everything is stored in memory (it resets when the app restarts and is not shared between users).
> The live app with accounts and shared chat history is in my second repository, **`devcircle-auth`** (Track 2).

- **Course used:** [Flutter first codelab](https://codelabs.developers.google.com/codelabs/flutter-codelab-first)
- **Student:** _Palesa_ · **Reference code:** WTC-7WFDKS75

---

## What the app does
| Feature | How it works |
|---|---|
| **Circles** (left strip) | Communities such as `DC`. The dashed **+** creates a new circle. |
| **Topics + chat** | **+** next to TOPICS adds a topic. Tap it to chat. Phones open a new page; wide screens show the chat beside the sidebar. |
| **Resources** | **+** next to RESOURCES adds a title and link. Tap one to see it and copy the link. |
| **Meetings** | **+** next to MEETINGS uses a date picker and a time picker. Meetings are sorted soonest first (shown like `Thu 6 PM`). |
| **Starts empty** | No sample data. Everything is created by the user. |

## Flutter and Dart concepts used
- `StatelessWidget` and `StatefulWidget` with `setState()`
- Material 3 dark theme (`ThemeData`, `ColorScheme.fromSeed`)
- Lists, `ListView`, `Row`, `Column`, `Stack`, `LayoutBuilder` (responsive layout)
- Dart classes (`Topic`, `Resource`, `Meeting`, `Circle`), `async`/`await`, `showDialog`, `showDatePicker`, `showTimePicker`
- Reusable widgets in `lib/shell_widgets.dart` and colours in `lib/theme.dart`

## Project files
| File | Purpose |
|---|---|
| `lib/main.dart` | The app: data classes, home screen, chat |
| `lib/theme.dart` | Dark theme and colours |
| `lib/shell_widgets.dart` | Reusable pieces: circle strip, sidebar rows, badges, user card |
| `test/widget_test.dart` | Widget tests |

---

## Commands to run (for the demo)

**One-time setup** (needs Flutter installed: https://docs.flutter.dev/get-started)
```bash
git clone https://github.com/<your-github-username>/devcircle-ui.git
cd devcircle-ui
flutter create --project-name devcircle_ui .   # creates android/web/ios folders if missing
flutter pub get                                # downloads packages
```

**Check the code is healthy**
```bash
flutter analyze        # looks for mistakes (should say "No issues found")
flutter test           # runs the widget tests (should say "All tests passed")
```

**Run the app**
```bash
flutter devices                # list where you can run it
flutter run -d chrome          # run in the browser (easiest for a demo)
flutter run -d windows         # or as a Windows app
flutter run                    # or on a connected Android phone / emulator
```
While it runs: press `r` for hot reload, `R` for hot restart, `q` to quit.

**Build (optional)**
```bash
flutter build web --release    # output in build/web
flutter build apk --release    # Android file in build/app/outputs/flutter-apk/
```

---

## Demo script (about 2 minutes)
1. Run `flutter run -d chrome`. **Show the empty start**: *"Nothing is pre-loaded; every item is created by the user."*
2. **Topics:** click **+** next to TOPICS, type `flutter-tips`, Save. Open it and send a message.
3. **Resources:** click **+** next to RESOURCES, add `Dart tour` and `dart.dev/language`. Click it, then **Copy link**.
4. **Meetings:** click **+** next to MEETINGS, add `Final prep`, pick a date and a time. Show it in the sidebar.
5. **Circles:** click the dashed **+** in the left strip and create `Java`.
6. **Responsive layout:** make the browser window narrow, then wide. The chat moves between its own page and the side-by-side view.
7. Run `flutter test` and show that the tests pass.

## Screenshots
From the repository directory (`devcircle-ui`), run:
```powershell
flutter pub get
flutter run -d chrome
```

When the app opens in Chrome, use **Win + Shift + S** to capture the screens you want. Save the images in a `screenshots` folder in the project, then add a Markdown image link for each one, for example:
```
![Empty start](screenshots/empty.png)
![Chat](screenshots/chat.png)
![Resources and meetings](screenshots/sidebar.png)
```

## What I learned
- How widgets build the screen and how `setState()` refreshes it.
- How to make one layout work on phones and wide screens.
- How to split a bigger app into reusable widgets and files.
- Next step: connect it to Firebase, which I did in `devcircle-auth`.

*Thank you for checking out my Flutter Track 1 project! Feedback and suggestions are always welcome.* 😊

------------------------------------------------------------------------------------------------------------------
WTC-7WFDKS75
