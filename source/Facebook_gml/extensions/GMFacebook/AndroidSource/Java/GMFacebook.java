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
import com.facebook.Profile;
import com.facebook.appevents.AppEventsConstants;
import com.facebook.appevents.AppEventsLogger;
import com.facebook.login.LoginManager;
import com.facebook.login.LoginResult;
import com.facebook.share.Sharer;
import com.facebook.share.model.ShareLinkContent;
import com.facebook.share.widget.ShareDialog;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
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
            try
            {
                String appId =
                    currentActivity.getString(R.string.facebook_app_id);
                String clientToken =
                    currentActivity.getString(R.string.facebook_client_token);

                FacebookSdk.setApplicationId(appId);
                FacebookSdk.setClientToken(clientToken);

                Runnable finish = () ->
                {
                    try
                    {
                        FacebookSdk.fullyInitialize();
                        callbackManager = CallbackManager.Factory.create();
                        loginManager = LoginManager.getInstance();

                        AccessToken token = AccessToken.getCurrentAccessToken();
                        ready = true;
                        loginStatus =
                            token != null && !token.isExpired()
                                ? FacebookLoginStatus.Authorised
                                : FacebookLoginStatus.Idle;

                        call(callback, success(0));
                    }
                    catch (Exception exception)
                    {
                        ready = false;
                        loginStatus = FacebookLoginStatus.Failed;
                        call(callback, failure(0, exception.getMessage()));
                    }
                };

                if (FacebookSdk.isInitialized())
                {
                    finish.run();
                }
                else
                {
                    FacebookSdk.sdkInitialize(
                        currentActivity.getApplicationContext(),
                        finish::run
                    );
                }
            }
            catch (Exception exception)
            {
                ready = false;
                loginStatus = FacebookLoginStatus.Failed;
                call(callback, failure(0, exception.getMessage()));
            }
        });
    }

    public boolean fb_ready()
    {
        return ready;
    }

    public FacebookLoginStatus fb_status()
    {
        return loginStatus;
    }

    public String fb_user_id()
    {
        try
        {
            AccessToken token = AccessToken.getCurrentAccessToken();
            if (token != null && !token.isExpired())
                return safe(token.getUserId());

            Profile profile = Profile.getCurrentProfile();
            return profile != null ? safe(profile.getId()) : "";
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
        if (loginManager != null)
            loginManager.logOut();

        loginStatus = FacebookLoginStatus.Idle;
    }

    public void fb_set_auto_log_app_events_enabled(boolean enabled)
    {
        FacebookSdk.setAutoLogAppEventsEnabled(enabled);
    }

    public void fb_set_advertiser_id_collection_enabled(boolean enabled)
    {
        FacebookSdk.setAdvertiserIDCollectionEnabled(enabled);
    }

    public boolean fb_check_permission(String permission)
    {
        AccessToken token = AccessToken.getCurrentAccessToken();

        return token != null
            && !token.isExpired()
            && token.getPermissions().contains(permission);
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
            loginManager.registerCallback(
                callbackManager,
                new FacebookCallback<LoginResult>()
                {
                    @Override
                    public void onSuccess(LoginResult loginResult)
                    {
                        loginStatus = FacebookLoginStatus.Authorised;

                        AccessToken token = loginResult.getAccessToken();
                        Set<String> grantedSet =
                            token != null
                                ? token.getPermissions()
                                : Collections.emptySet();
                        Set<String> declinedSet =
                            token != null
                                ? token.getDeclinedPermissions()
                                : Collections.emptySet();

                        call(
                            callback,
                            result(
                                true,
                                FacebookOperationStatus.Success,
                                requestId,
                                "",
                                token != null ? token.getToken() : "",
                                token != null ? token.getUserId() : "",
                                "",
                                "",
                                new ArrayList<>(grantedSet),
                                new ArrayList<>(declinedSet)
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
                        call(callback, failure(requestId, exception.getMessage()));
                    }
                }
            );

            loginManager.logInWithReadPermissions(
                currentActivity,
                requested
            );
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

        if (current == null)
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
                    loginStatus = FacebookLoginStatus.Authorised;

                    call(
                        callback,
                        result(
                            true,
                            FacebookOperationStatus.Success,
                            requestId,
                            "",
                            token != null ? token.getToken() : "",
                            token != null ? token.getUserId() : "",
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
                    call(callback, failure(requestId, exception.getMessage()));
                }
            }
        );
    }

    public void fb_graph_request(
        String graphPath,
        List<FacebookHttpMethod> methods,
        List<FacebookNamedValue> parameters,
        final GMFunction callback)
    {
        FacebookHttpMethod method =
            methods != null && !methods.isEmpty()
                ? methods.get(0)
                : FacebookHttpMethod.Get;

        fb_graph_request(
            graphPath,
            method,
            parameters,
            callback
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
            safe(graphPath),
            bundle,
            httpMethod,
            (GraphResponse response) ->
            {
                if (response == null)
                {
                    call(callback, failure(requestId, "Facebook Graph response is null."));
                    return;
                }

                if (response.getError() != null)
                {
                    call(
                        callback,
                        failure(
                            requestId,
                            response.getError().getErrorMessage()
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

        currentActivity.runOnUiThread(() ->
        {
            try
            {
                ShareLinkContent content =
                    new ShareLinkContent.Builder()
                        .setContentUrl(Uri.parse(safe(linkUrl)))
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
                                failure(requestId, exception.getMessage())
                            );
                        }
                    }
                );

                dialog.show(content);
            }
            catch (Exception exception)
            {
                call(callback, failure(requestId, exception.getMessage()));
            }
        });
    }

    @Override
    public boolean fb_send_event(
        List<FacebookAppEvent> events,
        double value,
        List<FacebookEventParameterValue> parameters)
    {
        if (events == null || events.isEmpty())
            return false;

        return fb_send_event(
            events.get(0),
            value,
            parameters
        );
    }

    public boolean fb_send_event(
        FacebookAppEvent event,
        double value,
        List<FacebookEventParameterValue> parameters)
    {
        String eventName = standardEventName(event);
        if (eventName.isEmpty())
            return false;

        AppEventsLogger logger =
            AppEventsLogger.newLogger(activity());

        logger.logEvent(
            eventName,
            value,
            eventValuesToBundle(parameters)
        );

        return true;
    }

    public boolean fb_send_custom_event(
        String eventName,
        double value,
        List<FacebookNamedValue> parameters)
    {
        if (eventName == null || eventName.trim().isEmpty())
            return false;

        AppEventsLogger logger =
            AppEventsLogger.newLogger(activity());

        logger.logEvent(
            eventName,
            value,
            namedValuesToBundle(parameters)
        );

        return true;
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

            String name = safe(parameter.name());
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
            default:
                return "";
        }
    }

    private String standardParameterName(int key)
    {
        switch (key)
        {
            case 1003:
                return AppEventsConstants.EVENT_PARAM_CONTENT_ID;
            case 1004:
                return AppEventsConstants.EVENT_PARAM_CONTENT_TYPE;
            case 1005:
                return AppEventsConstants.EVENT_PARAM_CURRENCY;
            case 1006:
                return AppEventsConstants.EVENT_PARAM_DESCRIPTION;
            case 1007:
                return AppEventsConstants.EVENT_PARAM_LEVEL;
            case 1008:
                return AppEventsConstants.EVENT_PARAM_MAX_RATING_VALUE;
            case 1009:
                return AppEventsConstants.EVENT_PARAM_NUM_ITEMS;
            case 1010:
                return AppEventsConstants.EVENT_PARAM_PAYMENT_INFO_AVAILABLE;
            case 1011:
                return AppEventsConstants.EVENT_PARAM_REGISTRATION_METHOD;
            case 1012:
                return AppEventsConstants.EVENT_PARAM_SEARCH_STRING;
            case 1013:
                return AppEventsConstants.EVENT_PARAM_SUCCESS;
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