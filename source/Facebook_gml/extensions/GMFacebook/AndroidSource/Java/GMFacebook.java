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
import com.facebook.FacebookRequestError;
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
import java.util.Optional;
import java.util.Set;

/**
 * Extension Generator conversion of FacebookExtension2.
 *
 * Meta Android SDK target: 18.2.3.
 * Social Async DS-map events were replaced by per-function GMFunction callbacks.
 * Anything that can fail before Meta's SDK is reached returns a FacebookError
 * synchronously and never fires the callback; the callback then delivers a
 * generated FacebookResult record plus that call's own payload.
 */
public class GMFacebook extends GMFacebookInternal
{
    private static final String TAG = "GMFacebook";

    private volatile boolean ready = false;
    private volatile FacebookLoginStatus loginStatus = FacebookLoginStatus.Idle;

    private CallbackManager callbackManager;
    private LoginManager loginManager;
    private int nextRequestId = 1;

    // At most one login and one share are in flight at a time; a second call is
    // rejected synchronously before the SDK is touched. Holding the callback
    // here rather than only in the SDK listener is what lets a late delivery be
    // recognised and dropped, and what gives fb_reset_pending something to fire.
    private PendingCall pendingLogin;
    private PendingCall pendingShare;

    private static final class PendingCall
    {
        final int requestId;
        final GMFunction callback;

        PendingCall(int requestId, GMFunction callback)
        {
            this.requestId = requestId;
            this.callback = callback;
        }
    }

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

    private static FacebookResult success()
    {
        return new FacebookResult(
            true,
            FacebookOperationStatus.Success,
            Optional.empty(),
            Optional.empty()
        );
    }

    private static FacebookResult cancelled()
    {
        // Backing out of a dialog is not an error, so no message is attached.
        return new FacebookResult(
            false,
            FacebookOperationStatus.Cancelled,
            Optional.empty(),
            Optional.empty()
        );
    }

    private static FacebookResult failure(String errorMessage)
    {
        return failure(errorMessage, Optional.empty());
    }

    // sdkErrorCode carries Meta's own documented Graph API error number, so it
    // is only ever present on a failure that came back from a Graph request.
    private static FacebookResult failure(
        String errorMessage,
        Optional<Integer> sdkErrorCode)
    {
        return new FacebookResult(
            false,
            FacebookOperationStatus.Error,
            Optional.of(safe(errorMessage)),
            sdkErrorCode
        );
    }

    private static FacebookLoginInfo loginInfo(AccessToken token)
    {
        return new FacebookLoginInfo(
            safe(token.getToken()),
            safe(token.getUserId()),
            sortedStrings(token.getPermissions()),
            sortedStrings(token.getDeclinedPermissions())
        );
    }

    private void call(GMFunction callback, Object... args)
    {
        if (callback == null)
            return;

        try
        {
            callback.call(args);
        }
        catch (Exception exception)
        {
            Log.e(TAG, "Could not invoke GML callback.", exception);
        }
    }

    private FacebookError readyError()
    {
        return ready && callbackManager != null && loginManager != null
            ? FacebookError.Ok
            : FacebookError.NotInitialized;
    }

    // Claims the login slot and allocates the request id in one critical
    // section. Doing it in two took the lock twice, so a second caller could
    // pass the Processing check before the first had written it.
    private synchronized int beginLogin(GMFunction callback)
    {
        if (pendingLogin != null)
            return -1;

        int requestId = nextRequestId();
        pendingLogin = new PendingCall(requestId, callback);
        loginStatus = FacebookLoginStatus.Processing;
        return requestId;
    }

    private synchronized int beginShare(GMFunction callback)
    {
        if (pendingShare != null)
            return -1;

        int requestId = nextRequestId();
        pendingShare = new PendingCall(requestId, callback);
        return requestId;
    }

    // Returns the held callback only when the ids match, so a delivery for a
    // request that fb_reset_pending already abandoned finds nothing and is
    // dropped instead of firing a second time.
    private synchronized GMFunction takePendingLogin(int requestId)
    {
        if (pendingLogin == null || pendingLogin.requestId != requestId)
            return null;

        GMFunction callback = pendingLogin.callback;
        pendingLogin = null;
        return callback;
    }

    private synchronized GMFunction takePendingShare(int requestId)
    {
        if (pendingShare == null || pendingShare.requestId != requestId)
            return null;

        GMFunction callback = pendingShare.callback;
        pendingShare = null;
        return callback;
    }

    private synchronized PendingCall takeAnyPendingLogin()
    {
        PendingCall pending = pendingLogin;
        pendingLogin = null;
        return pending;
    }

    private synchronized PendingCall takeAnyPendingShare()
    {
        PendingCall pending = pendingShare;
        pendingShare = null;
        return pending;
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

    public FacebookError fb_initialize(final GMFunction callback)
    {
        final Activity currentActivity = activity();

        if (currentActivity == null)
            return FacebookError.ActivityNull;

        currentActivity.runOnUiThread(() ->
        {
            if (ready)
            {
                call(callback, success());
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
                    call(callback, failure("facebook_app_id is empty."));
                    return;
                }

                if (clientToken.isEmpty())
                {
                    call(callback, failure("facebook_client_token is empty."));
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

                            call(callback, success());
                        }
                        catch (Exception exception)
                        {
                            ready = false;
                            loginStatus = FacebookLoginStatus.Failed;
                            call(callback, failure(errorMessage(exception)));
                        }
                    }
                );
            }
            catch (Exception exception)
            {
                ready = false;
                loginStatus = FacebookLoginStatus.Failed;
                call(callback, failure(errorMessage(exception)));
            }
        });

        return FacebookError.Ok;
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

        // Deliberately not gated on ready: the try/catch already covers calling
        // the SDK before initialization. But a login that is still in flight is
        // left alone - reporting Idle while its callback is still held would
        // contradict the LoginInProgress the next fb_login would return.
        // Abandoning one is fb_reset_pending's job.
        synchronized (this)
        {
            if (pendingLogin == null)
                loginStatus = FacebookLoginStatus.Idle;
        }
    }

    public void fb_reset_pending()
    {
        PendingCall login = takeAnyPendingLogin();
        PendingCall share = takeAnyPendingShare();

        // Both takes complete before either callback fires: the fields are
        // guarded by this instance's monitor and a GML callback must never run
        // while it is held.
        if (login != null)
        {
            loginStatus = FacebookLoginStatus.Idle;
            call(login.callback, cancelled(), Optional.empty());
        }

        if (share != null)
            call(share.callback, cancelled(), Optional.empty());
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

    public FacebookError fb_set_event_data_usage_limited(boolean enabled)
    {
        // The SDK's own application context, not the activity's: iOS applies
        // this through Settings.shared whatever the app is doing, and tying it
        // to a live activity made it a silent no-op while backgrounded.
        if (!FacebookSdk.isInitialized())
            return FacebookError.NotInitialized;

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
            return FacebookError.NotInitialized;
        }

        return FacebookError.Ok;
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

    public FacebookError fb_login(
        List<String> permissions,
        final GMFunction callback)
    {
        FacebookError readyError = readyError();
        if (readyError != FacebookError.Ok)
            return readyError;

        final Activity currentActivity = activity();
        if (currentActivity == null)
            return FacebookError.ActivityNull;

        final List<String> requested =
            permissions == null || permissions.isEmpty()
                ? Collections.singletonList("public_profile")
                : new ArrayList<>(permissions);

        final int requestId = beginLogin(callback);
        if (requestId < 0)
            return FacebookError.LoginInProgress;

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
                            GMFunction pending = takePendingLogin(requestId);
                            if (pending == null)
                                return;

                            AccessToken token =
                                loginResult != null
                                    ? loginResult.getAccessToken()
                                    : null;

                            if (token == null || token.isExpired())
                            {
                                loginStatus = FacebookLoginStatus.Failed;
                                call(
                                    pending,
                                    failure(
                                        "Facebook login returned no active access token."
                                    ),
                                    Optional.empty()
                                );
                                return;
                            }

                            loginStatus = FacebookLoginStatus.Authorised;

                            call(
                                pending,
                                success(),
                                Optional.of(loginInfo(token))
                            );
                        }

                        @Override
                        public void onCancel()
                        {
                            GMFunction pending = takePendingLogin(requestId);
                            if (pending == null)
                                return;

                            loginStatus = FacebookLoginStatus.Idle;
                            call(pending, cancelled(), Optional.empty());
                        }

                        @Override
                        public void onError(FacebookException exception)
                        {
                            GMFunction pending = takePendingLogin(requestId);
                            if (pending == null)
                                return;

                            loginStatus = FacebookLoginStatus.Failed;
                            call(
                                pending,
                                failure(errorMessage(exception)),
                                Optional.empty()
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
                GMFunction pending = takePendingLogin(requestId);
                if (pending == null)
                    return;

                loginStatus = FacebookLoginStatus.Failed;
                call(
                    pending,
                    failure(errorMessage(exception)),
                    Optional.empty()
                );
            }
        });

        return FacebookError.Ok;
    }

    public FacebookError fb_refresh_access_token(final GMFunction callback)
    {
        FacebookError readyError = readyError();
        if (readyError != FacebookError.Ok)
            return readyError;

        AccessToken current = AccessToken.getCurrentAccessToken();

        if (current == null || current.isExpired())
            return FacebookError.NotLoggedIn;

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
                            failure("Facebook returned no active access token."),
                            Optional.empty()
                        );
                        return;
                    }

                    loginStatus = FacebookLoginStatus.Authorised;

                    call(
                        callback,
                        success(),
                        Optional.of(loginInfo(token))
                    );
                }

                @Override
                public void OnTokenRefreshFailed(
                    FacebookException exception)
                {
                    loginStatus = FacebookLoginStatus.Failed;
                    call(
                        callback,
                        failure(errorMessage(exception)),
                        Optional.empty()
                    );
                }
            }
        );

        return FacebookError.Ok;
    }

    public FacebookError fb_graph_request(
        String graphPath,
        FacebookHttpMethod method,
        List<FacebookNamedValue> parameters,
        final GMFunction callback)
    {
        FacebookError readyError = readyError();
        if (readyError != FacebookError.Ok)
            return readyError;

        if (graphPath == null || graphPath.trim().isEmpty())
            return FacebookError.InvalidArgument;

        AccessToken token = AccessToken.getCurrentAccessToken();
        if (token == null || token.isExpired())
            return FacebookError.NotLoggedIn;

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
                        failure("Facebook Graph response is null."),
                        Optional.empty()
                    );
                    return;
                }

                FacebookRequestError error = response.getError();

                if (error != null)
                {
                    // Meta's own documented Graph error number - the same value
                    // on both platforms, unlike an SDK-domain NSError code.
                    call(
                        callback,
                        failure(
                            safe(error.getErrorMessage()),
                            Optional.of(error.getErrorCode())
                        ),
                        Optional.empty()
                    );
                    return;
                }

                call(
                    callback,
                    success(),
                    Optional.of(safe(response.getRawResponse()))
                );
            }
        );

        request.executeAsync();
        return FacebookError.Ok;
    }

    public FacebookError fb_dialog(
        String linkUrl,
        final GMFunction callback)
    {
        FacebookError readyError = readyError();
        if (readyError != FacebookError.Ok)
            return readyError;

        final Activity currentActivity = activity();
        if (currentActivity == null)
            return FacebookError.ActivityNull;

        if (linkUrl == null || linkUrl.trim().isEmpty())
            return FacebookError.InvalidArgument;

        // Uri.parse needs no UI thread, so the URL is validated here rather than
        // inside the post - a malformed URL is a caller error and belongs in the
        // synchronous return like every other one.
        final Uri contentUri = Uri.parse(linkUrl.trim());

        if (contentUri.getScheme() == null)
            return FacebookError.InvalidArgument;

        final int requestId = beginShare(callback);
        if (requestId < 0)
            return FacebookError.ShareInProgress;

        currentActivity.runOnUiThread(() ->
        {
            try
            {
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
                            GMFunction pending = takePendingShare(requestId);
                            if (pending == null)
                                return;

                            // Meta only returns a post id when the app holds
                            // publish permissions, so absent is the normal case
                            // rather than a failure to report.
                            String postId =
                                shareResult != null
                                    ? shareResult.getPostId()
                                    : null;

                            call(
                                pending,
                                success(),
                                postId != null && !postId.isEmpty()
                                    ? Optional.of(postId)
                                    : Optional.empty()
                            );
                        }

                        @Override
                        public void onCancel()
                        {
                            GMFunction pending = takePendingShare(requestId);
                            if (pending == null)
                                return;

                            call(pending, cancelled(), Optional.empty());
                        }

                        @Override
                        public void onError(FacebookException exception)
                        {
                            GMFunction pending = takePendingShare(requestId);
                            if (pending == null)
                                return;

                            call(
                                pending,
                                failure(errorMessage(exception)),
                                Optional.empty()
                            );
                        }
                    }
                );

                dialog.show(content);
            }
            catch (Exception exception)
            {
                GMFunction pending = takePendingShare(requestId);
                if (pending == null)
                    return;

                call(
                    pending,
                    failure(errorMessage(exception)),
                    Optional.empty()
                );
            }
        });

        return FacebookError.Ok;
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