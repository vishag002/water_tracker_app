# Water Tracker

Version: 1.0 (MVP)
Platform: Android
Framework: Flutter

---

# 1. Project Vision

Water Tracker is a modern, minimal, and beautiful Android application that helps users build a healthy hydration habit.

The goal of the first release is to provide an excellent user experience through simplicity, clean design, smooth animations, and reliable functionality.

The application should feel lightweight, polished, and enjoyable to use.

This is an MVP (Minimum Viable Product). Every decision should prioritize shipping a high-quality first version instead of adding more features.

---

# 2. Project Goals

## Primary Goals

- Ship the first production-ready version quickly.
- Publish on Google Play.
- Build a portfolio-quality Flutter application.
- Learn the complete app publishing process.
- Validate the market before expanding.

## Secondary Goals

- Generate passive income.
- Collect user feedback.
- Improve user retention.
- Continuously improve the application based on real-world feedback.

---

# 3. Target Audience

- Android users
- Users who want a simple hydration tracker
- Users who dislike complicated health apps
- Users looking for a clean and beautiful interface

---

# 4. Design Philosophy

The application should feel:

- Minimal
- Modern
- Clean
- Premium
- Fast
- Friendly
- Easy to understand

Principles

- Simplicity over complexity
- Functionality over decoration
- Smooth interactions
- Consistent spacing
- Consistent typography

Every screen should have a single clear purpose.

---

# 5. MVP Scope

Only the following features belong to Version 1.

## Home

- Welcome section
- Settings button
- Animated water bottle
- Current intake
- Daily goal
- Quick add buttons
- Quick subtract button

## History

- Day
- Week
- Month
- Year

Display

- Daily intake
- Goal progress
- Timeline
- Statistics

## Settings

- Light Theme
- Dark Theme
- Reminder Settings
- Streak Calendar
- Water Goal
- Water Intake Calculator
- History Shortcut
- Remove Ads

## Reminders

- Enable / Disable
- Reminder Interval
- Start Time
- End Time

## Water Goal

- Manual Goal Selection
- Water Intake Calculator

## Streak

- Current Streak
- Longest Streak
- Calendar View

---

# 6. Not Included In MVP

Do not implement these unless explicitly requested.

- User Login
- Cloud Sync
- Firebase
- Google Fit
- Apple Health
- Wear OS
- Home Screen Widgets
- Social Features
- Friends
- Challenges
- Achievements
- AI Suggestions
- Multiple Drink Types
- Data Export
- Data Backup
- Multi-language support

---

# 7. Current Progress

## Completed

- Home Screen UI
- Water Bottle Animation
- Add Water
- Remove Water
- Settings Screen UI
- Theme Switching
- Bottom Navigation

## Pending

- Drift Database
- History Module
- Reminder Module
- Water Goal Logic
- Water Calculator
- Streak Module
- Statistics
- Remove Ads
- Localizations
- Final Polish
- Play Store Assets

---

# 8. UI Guidelines

The application must follow the approved Figma design.

Guidelines

- Consistent spacing
- Rounded corners
- Large touch targets
- Smooth animations
- Clean typography
- Minimal color palette

Do not redesign screens unless requested.

---

# 9. Animation Guidelines

Animations should feel natural.

Examples

- Bottle fill animation
- Progress animation
- Page transitions
- Button press feedback
- Theme transition
- Goal completion celebration

Avoid excessive animations.

Performance always takes priority.

---

# 10. Architecture

The application follows a clean feature-oriented architecture.

Recommended Structure

```
lib/

core/
database/
features/
shared/
services/
routes/
```

Each feature should contain

- models
- providers
- repositories
- screens
- widgets

Guidelines

- Business logic should never exist inside UI.
- Riverpod manages application state.
- Drift manages persistent storage.
- SharedPreferences stores lightweight settings only.

---

# 11. Tech Stack

## Framework

- Flutter

## State Management

- flutter_riverpod

## Database

- drift
- drift_flutter
- sqlite3_flutter_libs

## Responsive UI

- flutter_screenutil

## Localization

- flutter_localizations
- intl

## Notifications

- flutter_local_notifications

## In-App Purchases

- in_app_purchase

## Animations

- flutter_animate
- confetti

## Local Settings

- shared_preferences

Used for

- Theme
- Language
- Onboarding
- App Preferences

## Utilities

- package_info_plus
- url_launcher

## Icons

- cupertino_icons

## Development

- flutter_test
- flutter_lints

## Planned For Future

- flutter_svg
- fl_chart
- path_provider
- path
- logger

---

# 12. Coding Standards

Always

- Write production-ready code.
- Follow Flutter best practices.
- Follow Dart style guidelines.
- Use Riverpod for state management.
- Use Drift for persistent storage.
- Keep widgets reusable.
- Keep files focused.
- Use meaningful naming.
- Separate UI from business logic.
- Reuse components whenever possible.

Never

- Over-engineer.
- Introduce unnecessary packages.
- Store app data inside SharedPreferences.
- Rewrite unrelated code.
- Add features outside MVP.

---

# 13. UX Principles

- Every action should require minimal taps.
- Support one-handed usage.
- Make interactions obvious.
- Keep screens uncluttered.
- Prioritize speed over customization.
- Minimize friction.

---

# 14. Performance Goals

- Fast startup
- Smooth animations
- Efficient rebuilds
- Offline-first
- Minimal memory usage
- Responsive interactions

Avoid unnecessary computations.

---

# 15. Monetization

Version 1

- Google AdMob
- Remove Ads (One-time purchase)

Future

- Premium Subscription
- Themes
- Widgets
- Cloud Sync

---

# 16. Release Checklist

Before publishing

- No crashes
- Responsive UI
- Light Theme tested
- Dark Theme tested
- Reminder system tested
- Drift database tested
- App icon
- Splash screen
- Privacy Policy
- Play Store screenshots
- Feature Graphic
- Store Listing
- Internal Testing
- Release Build Verification

---

# 17. Future Roadmap

## Version 2

- Better Statistics
- Charts
- Custom Bottle Themes
- More Reminder Options

## Version 3

- Cloud Sync
- Multiple Device Support
- Google Fit Integration

## Version 4

- Premium Experience
- Home Widgets
- Wear OS Support

---

# 18. Team Workflow

## Developer (Vishag)

- Product Owner
- Flutter Development
- Integration
- Testing
- Publishing

## ChatGPT

- Product Strategy
- Architecture
- Code Reviews
- Market Research
- Feature Planning
- Technical Decision Making

## Claude

- Flutter Implementation
- Riverpod Providers
- Drift Database
- Reusable Widgets
- Refactoring
- Bug Fixes
- Documentation

---

# 19. Development Rules

Before implementing any feature, ask:

1. Is it inside the MVP scope?
2. Does it improve the user experience?
3. Can it be implemented cleanly?
4. Does it delay the release?

If the answer to Question 4 is **Yes**, move it to a future version.

---

# 20. Project Mission

Our goal is **not** to build the biggest water tracker.

Our goal is to build the **best possible Version 1**, publish it quickly, gather real user feedback, and improve through continuous iterations.

**Done is better than perfect. Ship first, improve continuously.**