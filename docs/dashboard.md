@title Meta App Dashboard

# Meta App Dashboard

Everything on Meta's side of a Facebook integration lives in the
[App Dashboard](https://developers.facebook.com/apps) - creating the app, holding the three values this
extension needs, deciding who is allowed to log in, and keeping the whole thing alive after launch.

**This page is a map, not a tutorial.** Meta documents its own dashboard, that dashboard changes, and a
second-hand copy of their instructions goes stale silently. So what follows is the route through
*their* documentation, in the order a GameMaker project actually needs it, with a note on each step
saying what it means for your game. Follow the links for the actual steps.

See ${page.setup} for the GameMaker side, which is where the values you collect here get used.

## 1. Create the app

> [Create an App](https://developers.facebook.com/docs/development/create-an-app)

Meta's creation flow is **use-case based**: you pick what the app is for and it enables the right
products and permissions. For this extension the relevant use case is authenticating people with
Facebook Login and reading data with the Graph API; add sharing and App Events if your game uses
${function.fb_dialog} or ${module.app_events}.

Creating an app may require connecting it to a **business portfolio**, and some of what the Publish
section below covers requires that business to be verified. Worth knowing before you start rather than
halfway through App Review.

What you leave this step with is an **App ID**. That is the first of the three values ${page.setup}
asks for.

## 2. Collect the three values

Only three things from the dashboard ever reach your GameMaker project, and all three go into the
extension's options - see ${page.extension_options}.

| Value | Where it lives | Meta's page |
|---|---|---|
| **App ID** | Settings -> Basic | [Basic settings](https://developers.facebook.com/docs/development/create-an-app/app-dashboard/basic-settings) |
| **Display Name** | Settings -> Basic | [Basic settings](https://developers.facebook.com/docs/development/create-an-app/app-dashboard/basic-settings) |
| **Client Token** | Settings -> Advanced -> Security | [Advanced settings](https://developers.facebook.com/docs/development/create-an-app/app-dashboard/advanced-settings) |

[[Warning: The **App Secret**, on that same Basic settings page, is a server-side credential. It is not
one of the three, this extension never asks for it, and anything shipped inside a game can be
extracted from it. See Meta's
[login security guide](https://developers.facebook.com/docs/facebook-login/security).]]

## 3. Register your platforms

> [Platform Settings](https://developers.facebook.com/docs/development/create-an-app/app-dashboard/platform-settings)

Meta refuses traffic from a build it does not recognise, so the iOS and Android platforms have to be
added to the app and filled in. The values themselves come out of GameMaker rather than out of Meta's
documentation, so the mapping is in ${page.setup} step 2 - Bundle ID for iOS, and Package Name, Class
Name and Key Hash for Android.

Meta's own platform guides are worth a read if something does not work, particularly the key hash:

* [Facebook Login for Android](https://developers.facebook.com/docs/facebook-login/android)
* [Facebook Login for iOS](https://developers.facebook.com/docs/facebook-login/ios)
* [Getting started on Android](https://developers.facebook.com/docs/android/getting-started) - includes
generating the key hash

## 4. Decide who can log in

A new app is in **development mode**, and that is the single most common source of "login just fails on
my tester's phone".

> [App modes](https://developers.facebook.com/docs/development/build-and-test/app-modes)

In development mode only people with a role on the app can log in at all. Give your testers one:

> [App roles](https://developers.facebook.com/docs/development/build-and-test/app-roles)

Or use accounts Meta creates for the purpose, which need no real Facebook account and can be given
permissions directly:

> [Test users](https://developers.facebook.com/docs/development/build-and-test/test-users)

## 5. Understand permissions and access levels

Every permission you pass to ${function.fb_login} is defined by Meta, and each one has an access level
that decides whether it works for the public or only for your own testers.

* [Permissions reference](https://developers.facebook.com/docs/permissions) - what each permission
grants, and what it requires
* [Access levels](https://developers.facebook.com/docs/graph-api/overview/access-levels) - standard
versus advanced access, and what each means in practice

The short version, and the part that shapes how you write the code: `public_profile`, `email` and
`user_friends` work out of the box for people with a role on the app. Anything else - and anything at
all for the general public - needs App Review. ${function.fb_check_permission} tells you at runtime
what you actually hold.

## 6. Publish

> [Publish](https://developers.facebook.com/docs/development/release)

Three things gate a public launch, and they are not quick, so start them well before you ship:

* [App Review](https://developers.facebook.com/docs/app-review) - Meta reviews each permission and
feature you request beyond the defaults. You submit a written justification and usually a screen
recording of the flow in your game.
* [Business verification](https://developers.facebook.com/docs/development/release/business-verification)
- Meta verifies the business behind the app. Required for some permissions and features.
* **Going live** - switching the app out of development mode, from the dashboard's Publish section.

[[Note: Releasing a new version of an already-live game does not need a new review unless it uses
permissions the app has not been approved for. Meta covers this under
[App Review for live apps](https://developers.facebook.com/docs/app-review).]]

## 7. Keep it alive

The step that catches people, because nothing in your game breaks at build time - the app simply stops
working one day for players who were fine yesterday.

> [Maintaining data access](https://developers.facebook.com/docs/development/maintaining-data-access)

* **Data Use Checkup** is an **annual** certification that your app still uses Meta's APIs the way its
permissions allow. An app admin has to complete it. Miss it and API access is restricted.
* **Inactive apps.** An app with no logins, no Graph or Marketing API calls and no webhook activity for
**90 days** can be flagged inactive: tokens are invalidated and API access is blocked. An admin can
restore it from the dashboard, but every player has to log in again, and lapsed permissions go back
through App Review. This is a real risk for a game between releases, or for a second app you keep
around for testing.
* **Data Protection Assessment** applies to apps holding advanced permissions - a questionnaire on how
you use, share and protect the data.
* **API version upgrades.** Graph API versions are deprecated on a schedule; the dashboard's Settings -> Advanced
page shows which version your app calls. This matters directly to ${function.fb_graph_request},
which talks to the Graph API by path.

[[Important: Meta emails app admins about all of the above, so make sure the notification address on
the app is one somebody reads. It is under Settings -> Advanced -> Security.]]

## Everything above, in one list

Every link on this page, in the order it appears. All of them are Meta's own documentation.

| Topic | Meta's documentation |
|---|---|
| Create an app | [developers.facebook.com/docs/development/create-an-app](https://developers.facebook.com/docs/development/create-an-app) |
| App Dashboard | [developers.facebook.com/docs/development/create-an-app/app-dashboard](https://developers.facebook.com/docs/development/create-an-app/app-dashboard) |
| Basic settings - App ID, Display Name | [developers.facebook.com/docs/development/create-an-app/app-dashboard/basic-settings](https://developers.facebook.com/docs/development/create-an-app/app-dashboard/basic-settings) |
| Advanced settings - Client Token | [developers.facebook.com/docs/development/create-an-app/app-dashboard/advanced-settings](https://developers.facebook.com/docs/development/create-an-app/app-dashboard/advanced-settings) |
| Platform settings | [developers.facebook.com/docs/development/create-an-app/app-dashboard/platform-settings](https://developers.facebook.com/docs/development/create-an-app/app-dashboard/platform-settings) |
| App modes | [developers.facebook.com/docs/development/build-and-test/app-modes](https://developers.facebook.com/docs/development/build-and-test/app-modes) |
| App roles | [developers.facebook.com/docs/development/build-and-test/app-roles](https://developers.facebook.com/docs/development/build-and-test/app-roles) |
| Test users | [developers.facebook.com/docs/development/build-and-test/test-users](https://developers.facebook.com/docs/development/build-and-test/test-users) |
| Permissions reference | [developers.facebook.com/docs/permissions](https://developers.facebook.com/docs/permissions) |
| Access levels | [developers.facebook.com/docs/graph-api/overview/access-levels](https://developers.facebook.com/docs/graph-api/overview/access-levels) |
| Publish | [developers.facebook.com/docs/development/release](https://developers.facebook.com/docs/development/release) |
| App Review | [developers.facebook.com/docs/app-review](https://developers.facebook.com/docs/app-review) |
| Business verification | [developers.facebook.com/docs/development/release/business-verification](https://developers.facebook.com/docs/development/release/business-verification) |
| Maintaining data access | [developers.facebook.com/docs/development/maintaining-data-access](https://developers.facebook.com/docs/development/maintaining-data-access) |
| Login security | [developers.facebook.com/docs/facebook-login/security](https://developers.facebook.com/docs/facebook-login/security) |
| Graph API | [developers.facebook.com/docs/graph-api](https://developers.facebook.com/docs/graph-api) |
| App Events | [developers.facebook.com/docs/app-events](https://developers.facebook.com/docs/app-events) |
| Sharing | [developers.facebook.com/docs/sharing](https://developers.facebook.com/docs/sharing) |
