# Check-in Reminder App — Feature Verification & Usage Guide

## 1. Product Overview

A smart geofence-based check-in reminder app. When the user arrives at or leaves a configured location, it automatically pushes a notification to remind them to check in/out. Tapping the notification opens the attendance app (DingTalk/WeCom/Lark/Slack/Teams). Fully local app with no backend dependency.

---

## 2. First Launch — Onboarding Flow

### Page 1: Welcome
- [ ] Shows app icon, name "Check-in Reminder", and intro text
- [ ] Bottom shows page indicator (4 dots) + "Next" button

### Page 2: Set Location
- [ ] Tap "Select Location" to go to the add location page
- [ ] After adding, return to onboarding and continue to next step

### Page 3: Select Attendance App
- [ ] Shows attendance app options (read from database)
- [ ] Selected app is highlighted, saved to `attendanceApp`
- [ ] Selecting an app does not cause a white screen (router is cached, only rebuilds when `onboardingCompleted` changes)

### Page 4: Permissions
- [ ] Tap "Grant Permissions" to show system dialogs for location + notification permissions
- [ ] Permission status shown in real time (green check / red X / gray circle)
- [ ] If location permission is denied, show "Go to Settings" button
- [ ] Tap "Get Started" to complete onboarding and go to home page
- [ ] On next app launch, onboarding is not shown again

### Debug: Re-test Onboarding
- [ ] Settings → Debug Tools → Tap "Reset Onboarding" → Redirects to onboarding flow
- [ ] After reset, complete onboarding again, then enters home page normally

---

## 3. Bottom Navigation

4 Tabs: **Home** / **Records** / **Statistics** / **Settings**

---

## 4. Home Page

### 4.1 Status Card
- [ ] Shows current geofence status: Inside range (green) / Outside range (orange) / Unknown (gray)
- [ ] Shows number of actively monitored locations
- [ ] Shows monitoring status label (Monitoring / Not monitored)

### 4.2 Map View
- [ ] Embedded map loads correctly (OpenStreetMap tiles)
- [ ] All active locations show red pin markers
- [ ] Geofence radius shown as colored circles (green for current location, blue for others)
- [ ] Map supports pinch-zoom and drag

### 4.3 Today's Records
- [ ] Lists today's enter/exit events in chronological order
- [ ] Each entry shows HH:mm:ss timestamp
- [ ] If user tapped the notification (opened attendance app), shows green checkmark icon

---

## 5. Records Page

- [ ] Shows today's records by default
- [ ] Left arrow to go to previous day, right arrow to go to next day
- [ ] When showing today, right arrow is disabled (gray)
- [ ] Tap the date to open date picker, jump to any date
- [ ] Each record shows: enter/exit icon, time, location name
- [ ] If notification for that record was tapped, shows "Punched" label

---

## 6. Statistics Page

### 6.1 Week/Month Toggle
- [ ] AppBar has SegmentedButton to toggle "This Week" / "This Month"
- [ ] Chart and stats update accordingly on toggle

### 6.2 Arrival Time Bar Chart
- [ ] One bar per workday, height represents arrival time
- [ ] Green = on time (before 09:30), Orange = late
- [ ] Missed days show red question mark icon
- [ ] Bar top labeled with actual arrival time (HH:mm)
- [ ] Bottom labeled with day-of-week abbreviation

### 6.3 Stats Cards (4 columns)
- [ ] Attendance days: attended / expected
- [ ] Average arrival time: HH:mm
- [ ] Late days: > 0 orange, = 0 green
- [ ] Missed days: > 0 red, = 0 green

### 6.4 Detail List
- [ ] One row per workday: green check (normal) / orange warning (late) / red error (missed)
- [ ] Shows date + arrival~departure time range

---

## 7. Settings Page

### 7.1 Location Management (Grouped by Type)

#### Location List
- [ ] Grouped by location type (Office / School / Gym / Custom / user-added types)
- [ ] Each group has an independent section header showing type name
- [ ] Each location shows name + geofence radius
- [ ] Right toggle: enable/disable geofence monitoring for that location
- [ ] Right delete button: tap shows confirmation dialog, confirm to delete
- [ ] Tap location row: enter edit page (pre-filled with existing data)
- [ ] When no locations exist, shows default "Locations" header

#### Add/Edit Location Page
- [ ] **Location type** selection: ChoiceChip (supports any number of types, including user-defined)
- [ ] **Name** input, required validation
- [ ] **Name hint changes with type**:
  - Office → "e.g. HQ Building"
  - School → "e.g. MIT Campus"
  - Gym → "e.g. Fitness Center"
  - Custom/Other → "e.g. Coffee Shop"
- [ ] **Use Current Location** button: requests location permission → gets GPS coordinates (3 samples)
  - [ ] Shows loading animation while getting location
  - [ ] Permission denied shows dialog (Cancel / Manual Input / Go to Settings)
- [ ] **Pick on Map** button: opens full-screen map page (see 7.10)
- [ ] **Manual coordinate input**: Latitude (-90~90) and Longitude (-180~180) fields with validation
- [ ] **Geofence radius** slider: 50m ~ 1000m, step ~50m
- [ ] **Wi-Fi Assist**:
  - [ ] "Bind Current Wi-Fi" button reads currently connected SSID
  - [ ] When not connected to Wi-Fi, shows unable to detect
  - [ ] Bound SSIDs shown as Chips, can tap × to remove
  - [ ] Duplicate binding shows already exists
- [ ] **Save** button: disabled when coordinates not set
- [ ] Edit mode shows title "Edit Location", after save shows "Location updated"
- [ ] Add mode shows title "Add Location", after save shows "Location saved"

#### Manage Location Types
- [ ] Settings page tap "Manage Location Types" → enters location type management page
- [ ] Lists all types: 4 built-in types (Office/School/Gym/Custom) + user-added
- [ ] Each item shows: type name + enter/exit notification text
- [ ] Edit button: opens dialog to modify name, enter text, exit text
- [ ] Delete button:
  - Built-in types (isBuiltin=true) → shows "Built-in types cannot be deleted"
  - Locations using this type → shows "This type is used by N locations and cannot be deleted"
  - Otherwise shows confirmation dialog then deletes
- [ ] FAB button to add new type: fill in name + enter text + exit text
- [ ] New types appear in the ChoiceChip on add location page
- [ ] Geofence event notifications use the corresponding type's text (not hardcoded)

### 7.2 Notification Settings
- [ ] **Notify on Enter** toggle: when off, no notification on arrival
- [ ] **Notify on Exit** toggle: when off, no notification on departure
- [ ] **Cooldown Time** dropdown: 30 / 60 / 90 / 120 / 180 / 240 minutes
  - Meaning: same location same event type won't re-notify within cooldown period
- [ ] **Re-remind Interval** dropdown: 1 / 2 / 3 / 5 / 10 / 15 minutes
- [ ] **Max Reminder Count** dropdown: 1 / 2 / 3 / 4 / 5 times

### 7.3 Attendance App
- [ ] Radio list: DingTalk / WeCom / Lark / Slack / Teams / Google Calendar (+ user-defined apps if any)
- [ ] Selected item highlighted
- [ ] Debug mode shows "Manage Attendance Apps" entry (see 7.12)

### 7.4 Work Days
- [ ] 7 FilterChips for Mon~Sun, multi-select
- [ ] Quick options:
  - [ ] "Mon-Fri" one-tap set
  - [ ] "Mon-Sat" one-tap set

### 7.5 Silent Period (Multi-period Support)
- [ ] Default shows one entry "22:00 ~ 06:00"
- [ ] Tap existing period: shows "Select silent start time" and "Select silent end time" pickers
- [ ] Saves immediately after modification
- [ ] **Delete button**: disabled when only one period remains (must keep at least one)
- [ ] **Add Silent Period**: shows two time pickers, adds a new entry
- [ ] Typical use: add "11:30 ~ 13:30" lunch break, no notifications during lunch outings

### 7.6 Appearance
- [ ] **Theme Mode**: System / Light / Dark, takes effect immediately
- [ ] **Haptic Feedback** toggle: vibrate on geofence event
- [ ] **Sound** dropdown: System Default / Silent
  - [ ] "Silent" = no notification sound
  - [ ] "Default" = system notification sound

### 7.7 Keep Alive Guide
- [ ] Tap to enter keep alive guide page
- [ ] **Android** shows 3 steps (disable battery optimization, allow auto-start, lock in recents)
- [ ] **iOS** shows 2 steps (allow background app refresh, keep location permission as "Always")

### 7.8 Permission Status Page
- [ ] Tap "Permission Status" to enter permission check page
- [ ] Shows 3 permission statuses:
  - Location When In Use
  - Location Always
  - Notifications
- [ ] Each shows: icon + name + status (Granted green / Denied red / Not Requested gray)
- [ ] Denied permissions show platform-specific help text (different guidance for iOS / Android)
- [ ] Refresh button: re-checks all permission statuses
- [ ] "Open System Settings" button

### 7.9 Map Picker
- [ ] Add location page tap "Pick on Map" → enters full-screen map page
- [ ] Map uses OpenStreetMap tiles (same as home page map)
- [ ] Top shows hint "Tap on the map to select a location"
- [ ] Tap anywhere on map → places red pin marker
- [ ] Bottom shows "Confirm Location" button
- [ ] Tap confirm → returns to add location page, coordinates auto-fill latitude/longitude fields
- [ ] Edit mode: centers on existing coordinates
- [ ] Add mode: tries to get GPS current location as initial center, falls back to default if unavailable

### 7.10 Debug Tools (Debug Mode Only)
- [ ] Shows current geofence status (Inside / Outside / Unknown)
- [ ] Shows monitoring status (Monitoring / Not Monitored)
- [ ] Shows last enter / exit time
- [ ] **Mock Enter** button: triggers simulated enter event for active locations
- [ ] **Mock Exit** button: triggers simulated exit event for active locations
- [ ] Simulated events skip workday, silent period, cooldown checks; directly saves record + sends notification
- [ ] **Reset Onboarding** button: resets `onboardingCompleted` to false, navigates to onboarding

### 7.11 Manage Attendance Apps (Debug Mode Only)
- [ ] Lists all attendance apps: built-in (DingTalk/WeCom/Lark/Slack/Teams/Google Calendar) + user-defined
- [ ] Each item shows: app name + URL Scheme
- [ ] Edit button: modify name and URL Scheme
- [ ] Delete button: built-in apps cannot be deleted, user-defined apps can be deleted
- [ ] FAB button to add new app: input name + URL Scheme
- [ ] New apps appear in the settings page attendance app list and onboarding page

---

## 8. Core Background Logic Verification

### 8.1 Geofence Event Processing Pipeline (4-level filter)

Real geofence events pass through the following checks in order; any failure discards the event:

| # | Check | Verification Method |
|---|-------|-------------------|
| 1 | Notification type enabled | Disable "Notify on Enter" → simulate enter → should not receive notification |
| 2 | Today is a workday | Trigger geofence on Saturday (non-workday) → should not receive notification |
| 3 | Not in silent period | Trigger during 22:00~06:00 → should not receive notification |
| 4 | Not in cooldown period | Enter same location twice (interval < cooldown time) → second should not notify |

> Note: Debug mode "Mock Enter/Exit" **skips** all above checks, always sends notification

### 8.2 Overnight Silent Period
- [ ] Silent period "22:00-06:00": trigger at 23:00 → no notification; trigger at 07:00 → notification
- [ ] Silent period "11:30-13:30": trigger at 12:00 → no notification; trigger at 14:00 → notification
- [ ] Multiple periods active simultaneously, any match silences

### 8.3 Re-remind
- [ ] After first notification, re-reminds at configured interval (e.g. 5 minutes)
- [ ] Reminder count does not exceed configured maximum
- [ ] Reminder shows "Reminder: please check in (#N)"

### 8.4 Notification Tap to Open App
- [ ] Tap notification → opens selected attendance app (e.g. DingTalk `dingtalk://`)
- [ ] Record's `notifyClicked` marked as true, home and records pages show "Punched"
- [ ] Custom attendance apps also support tap-to-open (looks up URL Scheme from database)

### 8.5 Background / Killed Process Behavior
- [ ] Geofence events trigger notifications when app is in background
- [ ] After app process is killed by system (Headless mode), geofence events still trigger notifications
- [ ] Headless mode re-initializes StorageService and NotificationService

### 8.6 Home Widget
- [ ] Geofence event updates home widget data (status, time, location name)
- [ ] App startup restores widget state from storage

### 8.7 Geofence Notification Text
- [ ] Notification text uses the corresponding location type's custom text (read from database, not hardcoded)
- [ ] Custom location types' text displays correctly

---

## 9. Localization Support

- [ ] When system language is Chinese, app shows Chinese
- [ ] When system language is English, app shows English
- [ ] All UI text is internationalized (via `AppLocalizations`)

---

## 10. Known Limitations

| Item | Status | Notes |
|------|--------|-------|
| Wi-Fi assist monitoring | **Not activated** | `WifiMonitorService.startMonitoring()` implemented but not connected to startup flow; only used to read current Wi-Fi when binding SSID |
| Statistics holidays | **Simplified** | Statistics uses local `workDays` to determine workdays; makeup/offset workdays are not reflected |
| Re-remind persistence | **In-memory** | `_reRemindTimers` lives in process memory; if app is killed, remaining reminders are lost |
| Sound gentle/urgent | **Removed** | Requires custom audio files; currently only supports system default and silent |
| Manage Attendance Apps | **Debug only** | Custom attendance app entry only visible in debug mode, since regular users have difficulty obtaining URL Schemes |
