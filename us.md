# SoftLoud - iOS Development Guide

## Executive Summary

SoftLoud is an iOS alarm clock app that solves one of the most frustrating iPhone limitations: alarm volume is tied to the ringer volume. Users who turn down their ringer at night or in meetings risk sleeping through their morning alarm. SoftLoud decouples alarm volume from system volume, giving each alarm its own independent volume control.

**Target Audience**: iPhone users who need reliable wake-up alarms but also want to control their ringer volume independently. This includes office workers, students, parents, and anyone who has ever overslept because they forgot to turn their ringer back up.

**Key Differentiators**:
- Only app focused exclusively on independent alarm volume control
- Built on iOS 26 AlarmKit for system-level alarm reliability
- Per-alarm volume with visual presets (Gentle Wake, Normal, Loud & Clear, Earthquake)
- Gradual volume ramp-up for scientific waking
- Paid upfront model: no subscriptions, no ads, no data collection

## Competitive Analysis

| App | Strengths | Weaknesses | Our Advantage |
|-----|-----------|------------|---------------|
| **Apple Clock** | Built-in, free, reliable | Volume tied to ringer, no per-alarm volume | Independent volume per alarm |
| **VariAlarm** | Same concept (per-alarm volume), uses AlarmKit, iOS 26 native | New app, limited reviews, only 4 volume presets (0/20/60/100%) | Continuous volume slider, gradual wake, 4 themed presets, paid upfront (no IAP confusion) |
| **Alarmy** | 75M users, 4.8 rating, mission-based wake | Volume still depends on system, subscription model ($4.99/mo), bloated feature set | Focused on volume control, no subscription, lightweight |
| **Loud Alarm Clock** | 3M+ downloads, very loud sounds | Volume tied to system, outdated UI, ads | Independent volume, modern SwiftUI design, no ads |
| **Sleep Cycle** | Sleep tracking, smart wake | $39.99/year subscription, volume depends on system | No subscription needed, volume is the focus |

## Apple Design Guidelines Compliance

- **HIG - Notifications**: Using AlarmKit for system-level alarm scheduling ensures alarms fire reliably even in Silent mode and Focus modes
- **HIG - Audio**: AVAudioSession configured with `.playback` category to override system volume for alarm playback
- **HIG - Settings**: App does not require complex setup; volume control is inline in the alarm edit view
- **HIG - Dark Mode**: Full dark mode support with OLED-friendly pure black background
- **HIG - Accessibility**: Volume slider supports Dynamic Type, VoiceOver labels on all controls
- **App Store Review 2.5.4**: App uses background audio for alarm playback, properly declared in capabilities
- **App Store Review 3.1.1**: Paid upfront model with no IAP, no subscription, no hidden costs

## Technical Architecture

- **Language**: Swift 5.9+
- **Framework**: SwiftUI (primary), AVFoundation (audio playback), UserNotifications (fallback)
- **Data**: SwiftData for local persistence
- **Alarm Scheduling**: AlarmKit (iOS 26) with UNUserNotification fallback for earlier iOS versions
- **Audio**: AVAudioPlayer with AVAudioSession `.playback` category for independent volume
- **Minimum iOS**: 17.0

## Module Structure

```
SoftLoud/
├── SoftLoudApp.swift
├── Models/
│   ├── Alarm.swift
│   └── VolumePreset.swift
├── ViewModels/
│   ├── AlarmListViewModel.swift
│   ├── AlarmEditViewModel.swift
│   └── VolumeManager.swift
├── Views/
│   ├── AlarmListView.swift
│   ├── AlarmEditView.swift
│   ├── VolumeSliderView.swift
│   ├── VolumePresetButton.swift
│   ├── DayPickerView.swift
│   ├── AlarmRingingView.swift
│   ├── OnboardingView.swift
│   ├── SettingsView.swift
│   └── ContactSupportView.swift
├── Services/
│   ├── AudioPlayerManager.swift
│   ├── AlarmScheduler.swift
│   └── NotificationManager.swift
└── Resources/
    ├── Sounds/
    └── Assets.xcassets/
```

## Implementation Flow

1. Create data models (Alarm, VolumePreset) with SwiftData
2. Implement AudioPlayerManager with independent volume control and gradual wake
3. Implement AlarmScheduler with AlarmKit integration and notification fallback
4. Build AlarmListView with volume indicators and swipe actions
5. Build AlarmEditView with time picker, volume slider, presets, sound picker
6. Build VolumeSliderView with dynamic color feedback
7. Build DayPickerView for repeat day selection
8. Build AlarmRingingView for alarm dismissal/snooze UI
9. Build OnboardingView for first-launch notification permission request
10. Build SettingsView with policy links and contact support
11. Build ContactSupportView with feedback form
12. Integrate all views in SoftLoudApp with TabView navigation
13. Test on iPhone and iPad simulators

## UI/UX Design Specifications

- **Color Scheme**: Orange (#FF9500) primary, Green (#34C759) low volume, Orange (#FF9500) medium, Red (#FF3B30) high volume
- **Background**: Light #F2F2F7, Dark #000000 (OLED-friendly)
- **Typography**: SF Pro, system default sizes, `.title2.bold()` for volume percentage
- **Layout**: List-based alarm list, Form-based alarm editing, volume slider is the hero element
- **Animations**: `.contentTransition(.numericText())` for volume percentage, smooth color transitions
- **iPad**: Max content width 720pt, no restrictive tab styles

## Code Generation Rules

- Single responsibility: one feature per module
- MVVM pattern: View + ViewModel for each screen
- No comments in code unless asked
- SwiftData for all persistence
- AVAudioSession `.playback` category for alarm audio
- All SwiftData attributes must be optional or have default values
- iPad layout: `.frame(maxWidth: 720).frame(maxWidth: .infinity)` for main content

## Build & Deployment Checklist

1. Verify Bundle ID: com.zzoutuo.SoftLoud
2. Verify Deployment Target: iOS 17.0
3. Configure Audio background mode capability
4. Configure Push Notifications capability
5. Generate app icon
6. Build and test on iPhone simulator
7. Build and test on iPad simulator
8. Push to GitHub repository
9. Deploy policy pages to GitHub Pages
10. Generate App Store metadata (keytext.md)
