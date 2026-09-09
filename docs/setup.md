@title Setup

# Setup

This guide covers everything that you have to do outside your game's code before the Facebook
extension will work, which means creating an app on Meta's developer dashboard, registering your
Android and iOS builds against it, and then installing and configuring the extension in GameMaker.

Once that is done, see ${page.getting_started} for the order in which the functions should be called
in GML, and ${page.extension_options} for what each of the extension's options is for.

[[Warning: This extension supports **Android and iOS only**. There is no HTML5, Windows, macOS or
Linux implementation, and on those targets every function simply returns a default value and nothing
ever reaches Meta.]]

## 1. Create an app on the Meta dashboard

Everything starts with an app on Meta's developer dashboard, and with three values from it that
GameMaker will need later: the **App ID**, the **Display Name** and the **Client Token**.

> [Create an App](https://developers.facebook.com/docs/development/create-an-app)

Meta documents its own dashboard, so this guide does not restate it. Instead, ${page.dashboard} acts
as a map, walking you through Meta's documentation in the order that a GameMaker project needs it and
telling you exactly where each of the three values lives.

[[Warning: The **App Secret** on the Basic settings page is a server-side credential. It is not one
of the three values, this extension never asks for it, and it must never be shipped inside a game.]]

## 2. Add your platforms

Meta will not accept traffic from a build that it does not recognise, so every platform that you ship
on has to be registered against the app.

> [Platform Settings](https://developers.facebook.com/docs/development/create-an-app/app-dashboard/platform-settings)

The fields that Meta asks for there are filled in with values that come out of GameMaker rather than
out of Meta's documentation, so those are listed below.

### iOS

Add the **iOS** platform and fill in your **Bundle ID**. It must exactly match the bundle identifier
in your game's
[iOS Game Options](https://manual.gamemaker.io/monthly/en/Settings/Game_Options/iOS.htm), as a
mismatch is the single most common reason for a login silently failing on a device.

### Android

Add the **Android** platform and fill in three fields:

| Field | Where it comes from |
|---|---|
| **Package Name** | The reverse-domain identifier from your game's [Android Game Options](https://manual.gamemaker.io/monthly/en/Settings/Game_Options/Android.htm). |
| **Class Name** | Your package name followed by `.RunnerActivity`, for example `com.company.game.RunnerActivity`. |
| **Key Hash** | The keystore hash, from the **Keystore** section of the [Android Platform Preferences](https://manual.gamemaker.io/monthly/en/Setting_Up_And_Version_Information/Platform_Preferences/Android.htm). |

[[Important: The key hash belongs to the keystore and not to the app. A build that is signed with
your debug keystore and a build that is signed with your release keystore will produce different
hashes, and Meta rejects a login from a hash that it has not been given, so you should add
**both**.]]

Save your changes on the dashboard before moving on.

## 3. Install the extension in GameMaker

Download the **.yymps** file from the Releases section of the repository. Drag the file into your
GameMaker window or use the **Tools -> Import Local Package** option.

[[Important: Make sure that every one of the extension's files is added when you import it.]]

## 4. Fill in the extension options

Open the **GMFacebook** extension from the Asset Browser and fill in the three values that you noted
down in step 1, which are the **App ID**, the **Display Name** and the **Client Token**. All three
are required, and ${function.fb_initialize} will fail if either the App ID or the Client Token is
left empty.

See ${page.extension_options} for the full list, as well as for the Android and iOS project settings
that the extension needs.

Everything else that Meta requires is written for you when the project is built, which means the
Android manifest entries and string resources, the iOS plist keys and URL scheme, the Gradle
dependency and the CocoaPods pods. There is nothing that you need to paste into the injection boxes
by hand.

## 5. Build and test

Facebook logins cannot be tested in the IDE. The SDK is native, so you will need a real Android or
iOS build running on a device or an emulator.

* **Before App Review**, only people with a role on the app can log in, and only `public_profile`,
`email` and `user_friends` are available. Everybody else will see a login failure. See
${page.dashboard} for more on roles, test users and App Review.
* **App Events** are batched by the SDK, so an event that has just been sent will not appear in the
Events Manager straight away. You can call ${function.fb_flush_events} to push them through
immediately while you are testing.
* Anything beyond the three basic permissions has to go through App Review before it will work for
the public.
