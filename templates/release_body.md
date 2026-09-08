## IMPORTANT

- This extension is to be used with GameMaker **2026.0 LTS** or newer
- Requires CocoaPods when used on iOS platforms (is not required on newer versions of IDE)
- Works with **Android** and **iOS**.
- **Version 3.0.0 is a breaking change**: the extension has been fully rewritten with a new
  callback-based API (`fb_*` functions that take a GML callback function directly, replacing the
  `async_load`-based Social Async Events). Function names and signatures differ from 2.x, and the
  OAuth login path that covered HTML5 and desktop has been removed. Projects upgrading from an
  earlier (2.x) version will need to adjust their code, and projects that need the old API or OAuth
  login should stay on the final 2.1.3 release. Check the documentation for the current API.

## CHANGES SINCE ${releaseOldVersion}

https://github.com/YoYoGames/GMEXT-Facebook/compare/${releaseOldVersion}...${releaseNewVersion}

## DESCRIPTION

This extension wraps Meta's Facebook SDK (Android 18.2.3, iOS 18.1), allowing users to add Facebook
login to their application or integrate it with third party extensions
(ie.: [Firebase](https://github.com/YoYoGames/GMEXT-Firebase)).

## FEATURES

- Facebook Login, with permission requests and permission checks
- Login status and access token management
- Graph API requests
- Share dialogs
- App Events, both standard and custom, including purchase logging
- Privacy settings: automatic app event logging, advertiser ID collection, event data usage limits
  and data processing options

## DOCUMENTATION

The full documentation of the API is included in the extension asset (included files).
