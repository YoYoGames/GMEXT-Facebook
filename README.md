# GMEXT-Facebook
Repository for GameMaker's Facebook Extension

This repository was created with the intent of presenting users with the latest version available of the extension (even previous to marketplace updates) and also provide a way for the community to contribute with bug fixes and feature implementation.

This extension works on Android and iOS, wrapping Meta's Facebook SDK (`facebook-android-sdk:18.2.3` on Android, the `FBSDKCoreKit` / `FBSDKLoginKit` / `FBSDKShareKit` pods `~> 18.1` on iOS).

> [!IMPORTANT]
> **Version 3.0.0 is a breaking change.** The extension has been fully rewritten with a new
> callback-based API (`fb_*` functions that take a GML callback function directly, replacing the
> `async_load`-based Social Async Events). Function names and signatures differ from 2.x, and the
> OAuth login path that covered HTML5 and desktop has been removed. Projects upgrading from an
> earlier (2.x) version will need to adjust their code, and projects that need the old API or OAuth
> login should stay on the final 2.1.3 release. Check [the documentation](../../wiki) for the
> current API.

The API surface is declared in a single GMIDL spec and the platform bindings are generated from it,
so the layout is by role rather than by IDE project:

* API SPEC: `source/Facebook_gml/extensions/GMFacebook/source/spec.gmidl`
* ANDROID (Java): `source/Facebook_gml/extensions/GMFacebook/AndroidSource/Java/GMFacebook.java`
* iOS (Swift, with an Objective-C++ lifecycle bridge): `source/Facebook_gml/extensions/GMFacebook/source/src/ios/`
* GENERATED BINDINGS: `source/Facebook_gml/extensions/GMFacebook/source/code_gen/` (never edit by hand - regenerate from the spec)
* BUILD PRESETS: `source/Facebook_gml/extensions/GMFacebook/source/CMakePresets.json`

---

## What's in 3.0.0

Version 3.0.0 is a full rewrite. The platform bindings are generated from a single GMIDL spec, and
the extension delivers its results to a GML callback function instead of the Social Async Event.

The public GML API changed with the rewrite - function names and signatures differ from 2.x - so
moving an existing project across is a migration rather than a drop-in upgrade. The OAuth login path
that covered HTML5 and desktop has also been removed, and those targets are no longer supported.
Projects that need the older API, or OAuth login, should stay on the final 2.x release.

---

## Important

Do not download from the **main branch** this branch is a work in place branch and probably has features that might be broken or not working properly, please download from the releases panel (right side instead).

---

## Documentation

* Check [the documentation](../../wiki)

The online documentation is regularly updated to ensure it contains the most current information. For those who prefer a different format, we also offer a HTML version. This HTML is directly converted from the GitHub Wiki content, ensuring consistency, although it may follow slightly behind in updates.

We encourage users to refer primarily to the GitHub Wiki for the latest information and updates. The HTML version, included with the extension and within the demo project's data files, serves as a secondary, static reference.

Additionally, if you're contributing new features through PR (Pull Requests), we kindly ask that you also provide accompanying documentation for these features, to maintain the comprehensiveness and usefulness of our resources.

---
