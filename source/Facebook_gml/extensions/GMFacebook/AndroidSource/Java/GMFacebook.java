package ${YYAndroidPackageName};

import ${YYAndroidPackageName}.GMExtWire;
import ${YYAndroidPackageName}.GMExtWire.GMFunction;
import ${YYAndroidPackageName}.enums.*;
import ${YYAndroidPackageName}.records.*;

import android.app.Activity;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.util.Log;

import com.facebook.AccessToken;
import com.facebook.CallbackManager;
import com.facebook.FacebookCallback;
import com.facebook.FacebookException;
import com.facebook.FacebookSdk;
import com.facebook.GraphRequest;
import com.facebook.GraphResponse;
import com.facebook.HttpMethod;
import com.facebook.appevents.AppEventsConstants;
import com.facebook.appevents.AppEventsLogger;
import com.facebook.login.LoginManager;
import com.facebook.login.LoginResult;
import com.facebook.share.Sharer;
import com.facebook.share.model.ShareLinkContent;
import com.facebook.share.widget.ShareDialog;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Currency;
import java.util.List;
import java.util.Locale;
import java.util.Set;

/**
 * Extension Generator conversion of FacebookExtension2.
 *
 * Meta Android SDK target: 18.2.3.
 * Social Async DS-map events were replaced by per-function GMFunction callbacks.
 * Callback payloads use the generated FacebookCallbackResult record.
 */
public class GMFacebook extends GMFacebookInternal
{
    private static final String TAG = "GMFacebook";

    private volatile boolean ready = false;
    private volatile FacebookLoginStatus loginStatus = FacebookLoginStatus.Idle;

    private CallbackManager callbackManager;
    private LoginManager loginManager;
    private int nextRequestId = 1;

    private static Activity activity()
    {
        return RunnerActivity.CurrentActivity;
    }

    private static String safe(String value)
    {
        return value != null ? value : "";
    }

    private synchronized int nextRequestId()
    {
        return nextRequestId++;
    }

    private static GMExtWire.StructStream streamStruct()
    {
        return new GMExtWire.StructStream(8192);
    }

    private static GMExtWire.ArrayStream streamArray()
    {
        return new GMExtWire.ArrayStream(8192);
    }

    private static GMExtWire.ArrayStream stringArray(
        List<String> values)
    {
        GMExtWire.ArrayStream output = streamArray();

        if (values != null)
        {
            for (String value : values)
                output.add(safe(value));
        }

        return output;
    }

    private static List<String> sortedStrings(Set<String> values)
    {
        if (values == null || values.isEmpty())
            return Collections.emptyList();

        List<String> output = new ArrayList<>(values);
        Collections.sort(output);
        return output;
    }

    private static String errorMessage(Throwable throwable)
    {
        if (throwable == null)
            return "Unknown Facebook SDK error.";

        String message = throwable.getMessage();
        return message != null && !message.trim().isEmpty()
            ? message
            : throwable.getClass().getSimpleName();
    }

    private AppEventsLogger appEventsLogger()
    {
        Activity currentActivity = activity();

        if (!ready || currentActivity == null || !FacebookSdk.isInitialized())
            return null;

        try
        {
            return AppEventsLogger.newLogger(
                currentActivity.getApplicationContext()
            );
        }
        catch (Exception exception)
        {
            Log.e(TAG, "Could not create AppEventsLogger.", exception);
            return null;
        }
    }

    private GMExtWire.StructStream result(
        boolean success,
        FacebookOperationStatus status,
        int requestId,
        String errorMessage,
        String accessToken,
        String userId,
        String responseText,
        String postId,
        List<String> granted,
        List<String> declined)
    {
        return streamStruct()
            .kv("success", success)
            .kv("status", status.value())
            .kv("request_id", requestId)
            .kv("error_message", safe(errorMessage))
            .kv("access_token", safe(accessToken))
            .kv("user_id", safe(userId))
            .kv("response_text", safe(responseText))
            .kv("post_id", safe(postId))
            .kv("granted_permissions", stringArray(granted))
            .kv("declined_permissions", stringArray(declined));
    }

    private GMExtWire.StructStream success(int requestId)
    {
        return result(
            true,
            FacebookOperationStatus.Success,
            requestId,
            "",
            fb_access_token(),
            fb_user_id(),
            "",
            "",
            Collections.emptyList(),
            Collections.emptyList()
        );
    }

    private GMExtWire.StructStream failure(
        int requestId,
        String errorMessage)
    {
        return result(
            false,
            FacebookOperationStatus.Error,
            requestId,
            errorMessage,
            "",
            "",
            "",
            "",
            Collections.emptyList(),
            Collections.emptyList()
        );
    }

    private void call(
        GMFunction callback,
        GMExtWire.StructStream value)
    {
        if (callback == null)
            return;

        try
        {
            callback.call(value);
        }
        catch (Exception exception)
        {
            Log.e(TAG, "Could not invoke GML callback.", exception);
        }
    }

    private boolean requireReady(GMFunction callback, int requestId)
    {
        if (ready && callbackManager != null && loginManager != null)
            return true;

        call(callback, failure(requestId, "Facebook SDK is not initialized."));
        return false;
    }

    @SuppressWarnings("deprecation")
    private void initializeSdkIfNeeded(
        Activity currentActivity,
        Runnable completion)
    {
        if (FacebookSdk.isInitialized())
        {
            FacebookSdk.fullyInitialize();
            completion.run();
            return;
        }

        // Compatibility fallback for hosts where FacebookInitProvider was not
        // allowed to initialize the SDK before the GameMaker extension loads.
        FacebookSdk.sdkInitialize(
            currentActivity.getApplicationContext(),
            () ->
            {
                FacebookSdk.fullyInitialize();
                completion.run();
            }
        );
    }

    public void fb_initialize(final GMFunction callback)
    {
        final Activity currentActivity = activity();

        if (currentActivity == null)
        {
            call(callback, failure(0, "RunnerActivity.CurrentActivity is null."));
            return;
        }

        currentActivity.runOnUiThread(() ->
        {
            if (ready)
            {
                call(callback, success(0));
                return;
            }

            try
            {
                String appId =
                    safe(currentActivity.getString(R.string.facebook_app_id)).trim();
                String clientToken =
                    safe(currentActivity.getString(R.string.facebook_client_token)).trim();

                if (appId.isEmpty())
                {
                    call(callback, failure(0, "facebook_app_id is empty."));
                    return;
                }

                if (clientToken.isEmpty())
                {
                    call(callback, failure(0, "facebook_client_token is empty."));
                    return;
                }

                FacebookSdk.setApplicationId(appId);
                FacebookSdk.setClientToken(clientToken);

                initializeSdkIfNeeded(
                    currentActivity,
                    () ->
                    {
                        try
                        {
                            callbackManager = CallbackManager.Factory.create();
                            loginManager = LoginManager.getInstance();
                            ready = true;
                            loginStatus =
                                AccessToken.isCurrentAccessTokenActive()
                                    ? FacebookLoginStatus.Authorised
                                    : FacebookLoginStatus.Idle;

                            call(callback, success(0));
                        }
                        catch (Exception exception)
                        {
                            ready = false;
                            loginStatus = FacebookLoginStatus.Failed;
                            call(callback, failure(0, errorMessage(exception)));
                        }
                    }
                );
            }
            catch (Exception exception)
            {
                ready = false;
                loginStatus = FacebookLoginStatus.Failed;
                call(callback, failure(0, errorMessage(exception)));
            }
        });
    }

    public boolean fb_ready()
    {
        return ready;
    }

    public FacebookLoginStatus fb_status()
    {
        if (loginStatus == FacebookLoginStatus.Processing)
            return loginStatus;

        if (fb_is_logged_in())
        {
            loginStatus = FacebookLoginStatus.Authorised;
            return loginStatus;
        }

        if (loginStatus == FacebookLoginStatus.Authorised)
            loginStatus = FacebookLoginStatus.Idle;

        return loginStatus;
    }

    public boolean fb_is_logged_in()
    {
        try
        {
            return AccessToken.isCurrentAccessTokenActive();
        }
        catch (Exception exception)
        {
            return false;
        }
    }

    public String fb_user_id()
    {
        try
        {
            AccessToken token = AccessToken.getCurrentAccessToken();

            return token != null && !token.isExpired()
                ? safe(token.getUserId())
                : "";
        }
        catch (Exception exception)
        {
            return "";
        }
    }

    public String fb_access_token()
    {
        try
        {
            AccessToken token = AccessToken.getCurrentAccessToken();

            return token != null && !token.isExpired()
                ? safe(token.getToken())
                : "";
        }
        catch (Exception exception)
        {
            return "";
        }
    }

    public void fb_logout()
    {
        try
        {
            LoginManager manager =
                loginManager != null
                    ? loginManager
                    : LoginManager.getInstance();

            manager.logOut();
        }
        catch (Exception exception)
        {
            Log.e(TAG, "Could not log out from Facebook.", exception);
        }

        // Deliberately not gated on ready: clearing loginStatus here is the
        // only way out of a login that was left pending, and the try/catch
        // already covers calling the SDK before initialization.
        loginStatus = FacebookLoginStatus.Idle;
    }

    public void fb_set_auto_log_app_events_enabled(boolean enabled)
    {
        FacebookSdk.setAutoLogAppEventsEnabled(enabled);
    }

    public boolean fb_auto_log_app_events_enabled()
    {
        try
        {
            return FacebookSdk.getAutoLogAppEventsEnabled();
        }
        catch (Exception exception)
        {
            return false;
        }
    }

    public void fb_set_advertiser_id_collection_enabled(boolean enabled)
    {
        FacebookSdk.setAdvertiserIDCollectionEnabled(enabled);
    }

    public boolean fb_advertiser_id_collection_enabled()
    {
        try
        {
            return FacebookSdk.getAdvertiserIDCollectionEnabled();
        }
        catch (Exception exception)
        {
            return false;
        }
    }

    public void fb_set_event_data_usage_limited(boolean enabled)
    {
        // The SDK's own application context, not the activity's: iOS applies
        // this through Settings.shared whatever the app is doing, and tying it
        // to a live activity made it a silent no-op while backgrounded.
        if (!FacebookSdk.isInitialized())
        {
            Log.w(
                TAG,
                "fb_set_event_data_usage_limited ignored: SDK not initialized."
            );
            return;
        }

        try
        {
            FacebookSdk.setLimitEventAndDataUsage(
                FacebookSdk.getApplicationContext(),
                enabled
            );
        }
        catch (Exception exception)
        {
            Log.e(TAG, "Could not set event data usage limit.", exception);
        }
    }

    public boolean fb_event_data_usage_limited()
    {
        if (!FacebookSdk.isInitialized())
            return false;

        try
        {
            return FacebookSdk.getLimitEventAndDataUsage(
                FacebookSdk.getApplicationContext()
            );
        }
        catch (Exception exception)
        {
            return false;
        }
    }

    public void fb_set_data_processing_options(
        List<String> options,
        int country,
        int state)
    {
        String[] values =
            options == null
                ? new String[0]
                : options.toArray(new String[0]);

        FacebookSdk.setDataProcessingOptions(values, country, state);
    }

    public boolean fb_check_permission(String permission)
    {
        if (permission == null || permission.trim().isEmpty())
            return false;

        String requestedPermission = permission.trim();
        AccessToken token = AccessToken.getCurrentAccessToken();

        return token != null
            && !token.isExpired()
            && token.getPermissions().contains(requestedPermission);
    }

    public void fb_login(
        List<String> permissions,
        final GMFunction callback)
    {
        requestReadPermissions(permissions, callback);
    }

    public void fb_request_read_permissions(
        List<String> permissions,
        final GMFunction callback)
    {
        requestReadPermissions(permissions, callback);
    }

    private void requestReadPermissions(
        List<String> permissions,
        final GMFunction callback)
    {
        final int requestId = nextRequestId();

        if (!requireReady(callback, requestId))
            return;

        if (loginStatus == FacebookLoginStatus.Processing)
        {
            call(
                callback,
                failure(requestId, "A Facebook login request is already in progress.")
            );
            return;
        }

        final Activity currentActivity = activity();
        if (currentActivity == null)
        {
            call(callback, failure(requestId, "Activity is null."));
            return;
        }

        final List<String> requested =
            permissions == null || permissions.isEmpty()
                ? Collections.singletonList("public_profile")
                : new ArrayList<>(permissions);

        loginStatus = FacebookLoginStatus.Processing;

        currentActivity.runOnUiThread(() ->
        {
            try
            {
                loginManager.registerCallback(
                    callbackManager,
                    new FacebookCallback<LoginResult>()
                    {
                        @Override
                        public void onSuccess(LoginResult loginResult)
                        {
                            AccessToken token =
                                loginResult != null
                                    ? loginResult.getAccessToken()
                                    : null;

                            if (token == null || token.isExpired())
                            {
                                loginStatus = FacebookLoginStatus.Failed;
                                call(
                                    callback,
                                    failure(
                                        requestId,
                                        "Facebook login returned no active access token."
                                    )
                                );
                                return;
                            }

                            loginStatus = FacebookLoginStatus.Authorised;

                            Set<String> grantedSet =
                                loginResult.getRecentlyGrantedPermissions();
                            Set<String> declinedSet =
                                loginResult.getRecentlyDeniedPermissions();

                            call(
                                callback,
                                result(
                                    true,
                                    FacebookOperationStatus.Success,
                                    requestId,
                                    "",
                                    safe(token.getToken()),
                                    safe(token.getUserId()),
                                    "",
                                    "",
                                    sortedStrings(grantedSet),
                                    sortedStrings(declinedSet)
                                )
                            );
                        }

                        @Override
                        public void onCancel()
                        {
                            loginStatus = FacebookLoginStatus.Idle;

                            call(
                                callback,
                                result(
                                    false,
                                    FacebookOperationStatus.Cancelled,
                                    requestId,
                                    "",
                                    "",
                                    "",
                                    "",
                                    "",
                                    Collections.emptyList(),
                                    Collections.emptyList()
                                )
                            );
                        }

                        @Override
                        public void onError(FacebookException exception)
                        {
                            loginStatus = FacebookLoginStatus.Failed;
                            call(
                                callback,
                                failure(requestId, errorMessage(exception))
                            );
                        }
                    }
                );

                loginManager.logInWithReadPermissions(
                    currentActivity,
                    requested
                );
            }
            catch (Exception exception)
            {
                loginStatus = FacebookLoginStatus.Failed;
                call(callback, failure(requestId, errorMessage(exception)));
            }
        });
    }

    public void fb_request_publish_permissions(
        List<String> permissions,
        final GMFunction callback)
    {
        int requestId = nextRequestId();

        call(
            callback,
            failure(
                requestId,
                "Facebook publish permissions are not supported by the current extension API."
            )
        );
    }

    public void fb_refresh_access_token(final GMFunction callback)
    {
        final int requestId = nextRequestId();
        AccessToken current = AccessToken.getCurrentAccessToken();

        if (current == null || current.isExpired())
        {
            call(
                callback,
                failure(
                    requestId,
                    "A logged-in Facebook user is required before refreshing the access token."
                )
            );
            return;
        }

        AccessToken.refreshCurrentAccessTokenAsync(
            new AccessToken.AccessTokenRefreshCallback()
            {
                @Override
                public void OnTokenRefreshed(AccessToken token)
                {
                    if (token == null || token.isExpired())
                    {
                        loginStatus = FacebookLoginStatus.Failed;
                        call(
                            callback,
                            failure(
                                requestId,
                                "Facebook returned no active access token."
                            )
                        );
                        return;
                    }

                    loginStatus = FacebookLoginStatus.Authorised;

                    call(
                        callback,
                        result(
                            true,
                            FacebookOperationStatus.Success,
                            requestId,
                            "",
                            safe(token.getToken()),
                            safe(token.getUserId()),
                            "",
                            "",
                            Collections.emptyList(),
                            Collections.emptyList()
                        )
                    );
                }

                @Override
                public void OnTokenRefreshFailed(
                    FacebookException exception)
                {
                    loginStatus = FacebookLoginStatus.Failed;
                    call(callback, failure(requestId, errorMessage(exception)));
                }
            }
        );
    }

    public void fb_graph_request(
        String graphPath,
        FacebookHttpMethod method,
        List<FacebookNamedValue> parameters,
        final GMFunction callback)
    {
        final int requestId = nextRequestId();

        if (!requireReady(callback, requestId))
            return;

        if (graphPath == null || graphPath.trim().isEmpty())
        {
            call(callback, failure(requestId, "Graph path is empty."));
            return;
        }

        AccessToken token = AccessToken.getCurrentAccessToken();
        if (token == null || token.isExpired())
        {
            call(
                callback,
                failure(requestId, "Facebook user is not logged in.")
            );
            return;
        }

        final Bundle bundle = namedValuesToBundle(parameters);
        final HttpMethod httpMethod;

        if (method == null)
            method = FacebookHttpMethod.Get;

        switch (method)
        {
            case Get:
                httpMethod = HttpMethod.GET;
                break;

            case Delete:
                httpMethod = HttpMethod.DELETE;
                break;

            case Post:
            default:
                httpMethod = HttpMethod.POST;
                break;
        }

        GraphRequest request = new GraphRequest(
            token,
            graphPath.trim(),
            bundle,
            httpMethod,
            (GraphResponse response) ->
            {
                if (response == null)
                {
                    call(
                        callback,
                        failure(requestId, "Facebook Graph response is null.")
                    );
                    return;
                }

                if (response.getError() != null)
                {
                    call(
                        callback,
                        failure(
                            requestId,
                            safe(response.getError().getErrorMessage())
                        )
                    );
                    return;
                }

                call(
                    callback,
                    result(
                        true,
                        FacebookOperationStatus.Success,
                        requestId,
                        "",
                        fb_access_token(),
                        fb_user_id(),
                        safe(response.getRawResponse()),
                        "",
                        Collections.emptyList(),
                        Collections.emptyList()
                    )
                );
            }
        );

        request.executeAsync();
    }

    public void fb_dialog(
        String linkUrl,
        final GMFunction callback)
    {
        final int requestId = nextRequestId();

        if (!requireReady(callback, requestId))
            return;

        final Activity currentActivity = activity();
        if (currentActivity == null)
        {
            call(callback, failure(requestId, "Activity is null."));
            return;
        }

        if (linkUrl == null || linkUrl.trim().isEmpty())
        {
            call(callback, failure(requestId, "Share URL is empty."));
            return;
        }

        currentActivity.runOnUiThread(() ->
        {
            try
            {
                Uri contentUri = Uri.parse(linkUrl.trim());

                if (contentUri.getScheme() == null)
                {
                    call(callback, failure(requestId, "Share URL has no scheme."));
                    return;
                }

                ShareLinkContent content =
                    new ShareLinkContent.Builder()
                        .setContentUrl(contentUri)
                        .build();

                ShareDialog dialog = new ShareDialog(currentActivity);
                dialog.registerCallback(
                    callbackManager,
                    new FacebookCallback<Sharer.Result>()
                    {
                        @Override
                        public void onSuccess(Sharer.Result shareResult)
                        {
                            call(
                                callback,
                                result(
                                    true,
                                    FacebookOperationStatus.Success,
                                    requestId,
                                    "",
                                    fb_access_token(),
                                    fb_user_id(),
                                    "",
                                    shareResult != null
                                        ? safe(shareResult.getPostId())
                                        : "",
                                    Collections.emptyList(),
                                    Collections.emptyList()
                                )
                            );
                        }

                        @Override
                        public void onCancel()
                        {
                            call(
                                callback,
                                result(
                                    false,
                                    FacebookOperationStatus.Cancelled,
                                    requestId,
                                    "",
                                    "",
                                    "",
                                    "",
                                    "",
                                    Collections.emptyList(),
                                    Collections.emptyList()
                                )
                            );
                        }

                        @Override
                        public void onError(FacebookException exception)
                        {
                            call(
                                callback,
                                failure(requestId, errorMessage(exception))
                            );
                        }
                    }
                );

                dialog.show(content);
            }
            catch (Exception exception)
            {
                call(callback, failure(requestId, errorMessage(exception)));
            }
        });
    }

    @Override
    public void fb_send_event(
        FacebookAppEvent event,
        double value,
        List<FacebookEventParameterValue> parameters)
    {
        String eventName = standardEventName(event);
        AppEventsLogger logger = appEventsLogger();

        if (logger == null
            || eventName.isEmpty()
            || Double.isNaN(value)
            || Double.isInfinite(value))
        {
            Log.w(TAG, "Ignoring invalid Facebook App Event request.");
            return;
        }

        logger.logEvent(
            eventName,
            value,
            eventValuesToBundle(parameters)
        );
    }

    @Override
    public void fb_send_custom_event(
        String eventName,
        double value,
        List<FacebookNamedValue> parameters)
    {
        AppEventsLogger logger = appEventsLogger();

        if (logger == null
            || eventName == null
            || eventName.trim().isEmpty()
            || Double.isNaN(value)
            || Double.isInfinite(value))
        {
            Log.w(TAG, "Ignoring invalid custom Facebook App Event request.");
            return;
        }

        logger.logEvent(
            eventName.trim(),
            value,
            namedValuesToBundle(parameters)
        );
    }

    @Override
    public void fb_send_purchase(
        double amount,
        String currency,
        List<FacebookNamedValue> parameters)
    {
        AppEventsLogger logger = appEventsLogger();

        if (logger == null
            || Double.isNaN(amount)
            || Double.isInfinite(amount)
            || amount < 0.0)
        {
            Log.w(TAG, "Ignoring invalid Facebook purchase request.");
            return;
        }

        String currencyCode = safe(currency).trim().toUpperCase(Locale.US);
        if (currencyCode.length() != 3)
        {
            Log.w(TAG, "Facebook purchase currency must be a 3-letter code.");
            return;
        }

        try
        {
            logger.logPurchase(
                BigDecimal.valueOf(amount),
                Currency.getInstance(currencyCode),
                namedValuesToBundle(parameters)
            );
        }
        catch (Exception exception)
        {
            Log.e(TAG, "Could not log Facebook purchase.", exception);
        }
    }

    public void fb_flush_events()
    {
        AppEventsLogger logger = appEventsLogger();

        if (logger != null)
            logger.flush();
    }

    public void fb_set_event_user_id(String userId)
    {
        AppEventsLogger.setUserID(
            userId == null || userId.trim().isEmpty()
                ? null
                : userId.trim()
        );
    }

    public String fb_get_event_user_id()
    {
        return safe(AppEventsLogger.getUserID());
    }

    public void fb_clear_event_user_id()
    {
        AppEventsLogger.clearUserID();
    }

    private Bundle namedValuesToBundle(
        List<FacebookNamedValue> parameters)
    {
        Bundle bundle = new Bundle();

        if (parameters == null)
            return bundle;

        for (FacebookNamedValue parameter : parameters)
        {
            if (parameter == null)
                continue;

            String name = safe(parameter.name()).trim();
            if (name.isEmpty())
                continue;

            if (parameter.use_number())
                bundle.putDouble(name, parameter.number_value());
            else
                bundle.putString(name, safe(parameter.string_value()));
        }

        return bundle;
    }

    private Bundle eventValuesToBundle(
        List<FacebookEventParameterValue> parameters)
    {
        Bundle bundle = new Bundle();

        if (parameters == null)
            return bundle;

        for (FacebookEventParameterValue parameter : parameters)
        {
            if (parameter == null)
                continue;

            String name = standardParameterName(parameter.key());
            if (name.isEmpty())
                continue;

            if (parameter.use_number())
                bundle.putDouble(name, parameter.number_value());
            else
                bundle.putString(name, safe(parameter.string_value()));
        }

        return bundle;
    }

    private String standardEventName(FacebookAppEvent event)
    {
        if (event == null)
            return "";

        switch (event)
        {
            case AchievedLevel:
                return AppEventsConstants.EVENT_NAME_ACHIEVED_LEVEL;
            case AddedPaymentInfo:
                return AppEventsConstants.EVENT_NAME_ADDED_PAYMENT_INFO;
            case AddedToCart:
                return AppEventsConstants.EVENT_NAME_ADDED_TO_CART;
            case AddedToWishlist:
                return AppEventsConstants.EVENT_NAME_ADDED_TO_WISHLIST;
            case CompletedRegistration:
                return AppEventsConstants.EVENT_NAME_COMPLETED_REGISTRATION;
            case CompletedTutorial:
                return AppEventsConstants.EVENT_NAME_COMPLETED_TUTORIAL;
            case InitiatedCheckout:
                return AppEventsConstants.EVENT_NAME_INITIATED_CHECKOUT;
            case Rated:
                return AppEventsConstants.EVENT_NAME_RATED;
            case Searched:
                return AppEventsConstants.EVENT_NAME_SEARCHED;
            case SpentCredits:
                return AppEventsConstants.EVENT_NAME_SPENT_CREDITS;
            case UnlockedAchievement:
                return AppEventsConstants.EVENT_NAME_UNLOCKED_ACHIEVEMENT;
            case ViewedContent:
                return AppEventsConstants.EVENT_NAME_VIEWED_CONTENT;
            case Contact:
                return AppEventsConstants.EVENT_NAME_CONTACT;
            case CustomizeProduct:
                return AppEventsConstants.EVENT_NAME_CUSTOMIZE_PRODUCT;
            case Donate:
                return AppEventsConstants.EVENT_NAME_DONATE;
            case FindLocation:
                return AppEventsConstants.EVENT_NAME_FIND_LOCATION;
            case Schedule:
                return AppEventsConstants.EVENT_NAME_SCHEDULE;
            case StartTrial:
                return AppEventsConstants.EVENT_NAME_START_TRIAL;
            case SubmitApplication:
                return AppEventsConstants.EVENT_NAME_SUBMIT_APPLICATION;
            case Subscribe:
                return AppEventsConstants.EVENT_NAME_SUBSCRIBE;
            case AdImpression:
                return AppEventsConstants.EVENT_NAME_AD_IMPRESSION;
            case AdClick:
                return AppEventsConstants.EVENT_NAME_AD_CLICK;
            default:
                return "";
        }
    }

    private String standardParameterName(
        FacebookAppEventParameter key)
    {
        if (key == null)
            return "";

        switch (key)
        {
            case Content:
                return AppEventsConstants.EVENT_PARAM_CONTENT;
            case AdType:
                return AppEventsConstants.EVENT_PARAM_AD_TYPE;
            case ContentId:
                return AppEventsConstants.EVENT_PARAM_CONTENT_ID;
            case ContentType:
                return AppEventsConstants.EVENT_PARAM_CONTENT_TYPE;
            case Currency:
                return AppEventsConstants.EVENT_PARAM_CURRENCY;
            case Description:
                return AppEventsConstants.EVENT_PARAM_DESCRIPTION;
            case Level:
                return AppEventsConstants.EVENT_PARAM_LEVEL;
            case MaxRatingValue:
                return AppEventsConstants.EVENT_PARAM_MAX_RATING_VALUE;
            case NumItems:
                return AppEventsConstants.EVENT_PARAM_NUM_ITEMS;
            case PaymentInfoAvailable:
                return AppEventsConstants.EVENT_PARAM_PAYMENT_INFO_AVAILABLE;
            case RegistrationMethod:
                return AppEventsConstants.EVENT_PARAM_REGISTRATION_METHOD;
            case SearchString:
                return AppEventsConstants.EVENT_PARAM_SEARCH_STRING;
            case Success:
                return AppEventsConstants.EVENT_PARAM_SUCCESS;
            case OrderId:
                return AppEventsConstants.EVENT_PARAM_ORDER_ID;
            default:
                return "";
        }
    }

    @Override
    public void onActivityResult(
        int requestCode,
        int resultCode,
        Intent data)
    {
        super.onActivityResult(requestCode, resultCode, data);

        if (callbackManager != null)
            callbackManager.onActivityResult(requestCode, resultCode, data);
    }
}