@title Extension Options

# Extension Options

You can open the options for the **GMFacebook** extension from the Asset Browser (either by
double-clicking the extension, or by right-clicking it and choosing **Properties**) to fill in your
Meta app details. All three values come from the Meta developer dashboard, so see ${page.setup} for
how to get there, and ${page.dashboard} for Meta's own documentation on the dashboard itself.

## App Data

| Option | Required | Where to find it | What it does |
|---|---|---|---|
| **App ID** | Yes | **Settings** -> **Basic** -> **App ID** | Identifies your app to Meta. It is written into the Android string resources and the iOS plist, and is used to build the `fb<AppID>` URL scheme that Meta's login flow returns to. ${function.fb_initialize} will fail if this is empty. |
| **Display Name** | Yes | **Settings** -> **Basic** -> **Display Name** | The app name that Meta shows to the player on the login and share screens. It is written into the iOS plist. |
| **Client Token** | Yes | **Settings** -> **Advanced** -> **Security** -> **Client Token** | The public client credential that Meta's SDK authenticates with. ${function.fb_initialize} will fail if this is empty. |

[[Warning: Do **not** put your **App Secret** in here, or anywhere else in the project. It is a
server-side credential, and anything that is shipped inside a game can be extracted from it.]]

## Required project settings

The following are not extension options, but the extension will not build or run without them.

### Android

In the **General** section of the
[Android Game Options](https://manual.gamemaker.io/monthly/en/Settings/Game_Options/Android.htm):

| Setting | Minimum |
|---|---|
| Minimum SDK | **21** |

Meta's `facebook-android-sdk` 18.x does not support anything older than that.

### iOS

In the [iOS Game Options](https://manual.gamemaker.io/monthly/en/Settings/Game_Options/iOS.htm):

| Setting | Minimum |
|---|---|
| Minimum iOS Version | **12.0** |

[[Important: GameMaker's default is lower than this, and the failure that it causes is not an obvious
one, as `pod install` refuses the Facebook pods outright and so the build dies during the CocoaPods
step rather than telling you that the deployment target is wrong. You should set it before your first
iOS build.]]

Building for iOS also requires CocoaPods to be installed on the Mac, and you can find the
[installation guide](https://gamemaker.io/en/help/articles/ios-and-tvos-using-cocoapods) here.

## What the extension configures for you

You do not need to edit any of the injection boxes in the extension's platform settings. From the
three options above, the extension writes everything that Meta's SDKs require at build time:

**Android**

* The Gradle dependency on `com.facebook.android:facebook-android-sdk`.
* The `facebook_app_id`, `facebook_client_token` and `fb_login_protocol_scheme` string resources.
* The `com.facebook.sdk.ApplicationId` and `com.facebook.sdk.ClientToken` manifest metadata.
* The `FacebookActivity` and `CustomTabActivity` declarations, including the browser intent filter
that lets Meta's login flow return to your game.

**iOS**

* The `FacebookAppID`, `FacebookClientToken` and `FacebookDisplayName` plist keys.
* The `fb<AppID>` URL scheme, along with the `fbapi` and `fb-messenger-share-api` query schemes that
let the SDK hand off to the Facebook and Messenger apps when they are installed.
* The CocoaPods dependencies on `FBSDKCoreKit`, `FBSDKLoginKit` and `FBSDKShareKit`.

## Export targets

The extension only has Android and iOS implementations, so you should leave its other export targets
disabled. On any other platform every function simply returns a default value and nothing ever
reaches Meta, so if your project also builds elsewhere then you should guard your calls with an
`os_type` check.
