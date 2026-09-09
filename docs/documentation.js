/**
 * @module home
 * @title Facebook
 *
 * @section Extension's Features
 * @desc
 *
 * * Initialise Meta's Facebook SDK from the extension's own options
 * * Log the player in with Facebook and request permissions from them
 * * Read the user ID, the access token and the granted permissions for the session
 * * Call Meta's Graph API directly and read the raw response
 * * Open Meta's share dialog on a link
 * * Report standard, custom and purchase App Events to the Events Manager
 * * Honour player consent through Meta's privacy and Limited Data Use settings
 *
 * @section_end
 *
 * @section Introduction
 *
 * @desc
 *
 * This extension gives you access to Meta's [Facebook SDK](https://developers.facebook.com/docs) on
 * **Android and iOS**. There is no support for HTML5, Windows, macOS or Linux, and on those targets
 * every function simply returns a default value, so if your game also builds for them you should
 * guard your calls with an `os_type` check.
 *
 * You must call ${function.fb_initialize} once before anything else. The only functions that make
 * sense any earlier are the privacy switches in ${module.settings}, which you may want in place
 * before the SDK logs its first automatic event. Everything else will fail with
 * ${constant.FacebookError}.NotInitialized until initialisation has completed.
 *
 * Every function that talks to Meta has the same two-part shape. It **returns** a
 * ${constant.FacebookError} straight away for anything that can be rejected before Meta's SDK is
 * ever reached, and when that value is not `Ok` the callback is never called, which makes the return
 * value the only place such a failure is reported. Otherwise the callback is called with a
 * ${struct.FacebookResult} as its first argument and, where the call has one, an optional payload as
 * its second. You should always check `result.success` before trusting the payload.
 *
 * @section_end
 *
 * @section Guides
 * @desc Guides for the Facebook extension.
 * @reference page.setup
 * @reference page.dashboard
 * @reference page.getting_started
 * @reference page.extension_options
 * @section_end
 *
 * @section Modules
 * @desc The following are the available modules for the Facebook extension:
 *
 * @reference module.general
 * @reference module.login
 * @reference module.graph
 * @reference module.app_events
 * @reference module.settings
 *
 * @section_end
 *
 * @module_end
 */
