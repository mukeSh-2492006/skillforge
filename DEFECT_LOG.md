# SkillSprint – Defect Log

Record defects found during testing, the steps to reproduce them, and their current status. Update this log with any further defects found during physical-device and final robustness testing.

| ID | Defect | Steps to reproduce | Resolution / current status |
|---|---|---|---|
| D-01 | Challenge category chips displayed a Material ancestor error when opening the Challenges screen from Home. | Open Home and tap **Start Now** under Today's Challenge. | **Fixed in code:** wrapped the Challenges screen content in a `Material` widget. Recheck on the release APK. |
| D-02 | Roadmap category chips displayed a Material ancestor error. | Open Roadmaps and interact with the category chips. | **Fixed in code:** wrapped the Roadmaps screen content in a `Material` widget. Recheck on the release APK. |
| D-03 | Roadmap category chips were visual-only and did not filter skills. | Open Roadmaps and select Programming, DSA, or Frameworks. | **Fixed:** category selection filters the saved skills list. User confirmed it works. |
| D-04 | Roadmap search control did not perform a search. | Open Roadmaps, tap the search icon, and enter a skill name. | **Fixed:** search filters skills by title/subtitle and shows a no-results message. User confirmed it works. |
| D-05 | Profile Settings and Help & Support tiles did not navigate. | Open Profile and tap Settings or Help & Support. | **Fixed in code:** navigation screens and tap handlers were added. User confirmed the screens open. |
| D-06 | Home screen showed hard-coded progress and skill/challenge content rather than provider data. | Change topic completion or add a skill, then return to Home. | **Fixed in code:** Home now reads progress, challenges, and skills from `SkillProvider`. User tested the screen. |
| D-07 | Profile showed a generic hard-coded student profile without editable details. | Open Profile and attempt to change student identity details. | **Fixed in code:** Edit Profile saves name, branch, year, college, and goal locally. User confirmed the details changed. |
| D-08 | Roadmap screen did not display all required list states. | Open Roadmaps; test loading, empty data, and data states. Simulate a storage-read failure to test error/retry. | **Implemented in code:** loading, error/retry, empty, and data branches added. **Runtime verification still required**, especially error/retry. |

## Additional final testing still required

- [ ] Empty input and invalid form values on every form
- [ ] Very long skill names, topics, descriptions, and profile values
- [ ] Rapid repeated taps on navigation and save/complete buttons
- [ ] Device rotation / orientation change
- [ ] App close and restart to verify all persisted data
- [ ] Physical Android phone installation and full flow
- [ ] Fresh clone: `flutter pub get`, `flutter analyze`, `flutter test`, and app launch
- [ ] Release APK launch and feature checks

**Note:** The listed resolutions reflect code changes and user-reported checks during development. Reproduce and verify each item on the final release APK before marking the whole project defect-free.
