/**
 * @module home
 * @title Facebook
 *
 * @section Extension's Features
 * @desc
 *
 * * Initialize Meta's Facebook SDK from the extension's own options
 * * Log the player in with Facebook and request permissions
 * * Read the session's user ID, access token and granted permissions
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
 * This extension wraps Meta's [Facebook SDK](https://developers.facebook.com/docs) for **Android and
 * iOS**. There is no HTML5, Windows, macOS or Linux support - every function returns a default value
 * on those targets, so guard your calls with an `os_type` check if your game also builds for them.
 *
 * Call ${function.fb_initialize} once, before anything else; the only functions that make sense
 * earlier are the privacy switches in ${module.settings}, which you may want in place before the SDK
 * logs its first automatic event. Everything else fails with ${constant.FacebookError}.NotInitialized
 * until initialization has completed.
 *
 * Every function that talks to Meta follows the same two-part shape. It **returns**
 * a ${constant.FacebookError} synchronously for anything that can be rejected before Meta's SDK is
 * reached - and when that value is not `Ok`, the callback never fires, so it is the only place such a
 * failure is reported. Otherwise the callback fires with a ${struct.FacebookResult} as its first
 * argument and, where the call has one, an optional payload as its second. Check `result.success`
 * before trusting the payload.
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
