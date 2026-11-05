# SkillForge – Personal Skill Learning App

## Project Overview

SkillForge is a Flutter-based mobile application designed to help users organize their learning journey, explore skill roadmaps, complete challenges, and monitor their learning progress.

The application provides a simple and user-friendly interface to support structured and consistent learning.

## Features

* **Skill Roadmaps:** Explore learning paths and organize skills.
* **Learning Progress:** Track completed topics and overall progress.
* **Challenges:** Complete learning challenges.
* **Achievements:** Unlock achievements by completing learning activities.
* **Profile:** View personal learning information.
* **Settings:** Manage application preferences and learning reminders.
* **Help & Support:** Find answers to frequently asked questions.
* **Local Data Storage:** Save learning information using SharedPreferences.

## Technologies Used

| Technology        | Purpose                        |
| ----------------- | ------------------------------ |
| Flutter           | Mobile application development |
| Dart              | Programming language           |
| Provider          | State management               |
| SharedPreferences | Local data storage             |
| Material Design   | User interface                 |

## Project Structure

```text
lib/
├── models/
├── services/
├── screens/
├── widgets/
├── theme/
└── main.dart
```

## Help & Support

SkillForge includes a Help & Support screen to assist users with common application questions.

### Frequently Asked Questions

**1. How do I add a new skill?**

Open Roadmaps and use the Add Skill option.

**2. How can I track my learning progress?**

Open Progress or Profile to view completed topics and overall progress.

**3. How do I complete a challenge?**

Open Challenges, select a challenge and tap Mark Completed.

**4. How can I earn achievements?**

Complete roadmap topics and challenges to unlock achievements.

**5. Will my learning data remain saved?**

SkillForge stores learning data locally on the device using SharedPreferences.

### Contact Support

Users can access the Contact Support option to get guidance when they face application issues.

## Installation and Setup

### Prerequisites

* Flutter SDK
* Dart SDK
* Android Studio or Visual Studio Code
* Android Emulator or Android Device

### Steps

1. Clone the repository:

```bash
git clone https://github.com/mukeSh-2492006/skillforge.git
```

2. Navigate to the project folder:

```bash
cd skillforge
```

3. Install dependencies:

```bash
flutter pub get
```

4. Run the application:

```bash
flutter run
```

## Testing

Run the following command to execute Flutter tests:

```bash
flutter test
```

## Build APK

To generate a release APK:

```bash
flutter build apk --release
```

APK location:

```text
build/app/outputs/flutter-apk/app-release.apk
```

## Screenshots

Add application screenshots here:

* Home Screen
* Roadmaps Screen
* Progress Screen
* Challenges Screen
* Settings Screen
* Help & Support Screen

## Team Contributions

| Team Member       | Roll Number | Contribution                                         |
| ----------------- | ----------- | ---------------------------------------------------- |
| Sami Mukesh       | 248X1A05Q4  | Core application development and project integration |
| Shaik Abdul Samad | 248X1A05Q8  | Update after completing assigned contribution        |
| Talakaya Rakesh   | 248X1A05T0  | Help & Support FAQ updates and project documentation |

## Data Storage

The application uses SharedPreferences for local data storage.

Learning information and preferences are stored locally on the user's device.

## Repository

GitHub Repository:

https://github.com/mukeSh-2492006/skillforge

## Future Enhancements

* Cloud-based data synchronization
* More learning roadmaps
* Additional skill challenges
* Improved progress analytics
* Enhanced user experience

---

**Developed using Flutter and Dart.**