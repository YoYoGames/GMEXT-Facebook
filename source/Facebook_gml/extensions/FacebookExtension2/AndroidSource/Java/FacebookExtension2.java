
package ${YYAndroidPackageName};

import ${YYAndroidPackageName}.RunnerActivity;
import com.yoyogames.runner.RunnerJNILib;

import android.content.Intent;
import android.util.Log;
import android.app.Application;
import android.app.Activity;
import android.app.AlertDialog;
import android.app.Dialog;
import android.content.Context;
import android.content.IntentFilter;
import android.content.SharedPreferences;
import android.content.pm.PackageManager;
import android.content.res.Configuration;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.os.Bundle;
import android.util.Log;
import java.lang.Exception;

import java.lang.NullPointerException;
import java.lang.reflect.Field;
import java.net.URLConnection;
import java.net.URL;
import java.net.MalformedURLException;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.Iterator;
import java.util.List;
import java.util.Collection;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Set;
import android.net.Uri;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.view.Window;
import android.view.ViewGroup.LayoutParams;
import android.view.WindowManager;
import android.view.KeyEvent;
import android.view.MotionEvent;
import android.view.Menu;
import android.view.MenuItem;

import com.facebook.*;
import com.facebook.login.LoginManager;
import com.facebook.login.LoginResult;
import com.facebook.share.model.GameRequestContent;
import com.facebook.share.widget.GameRequestDialog;
import com.facebook.share.model.ShareLinkContent;
import com.facebook.share.widget.ShareDialog;
import com.facebook.share.Sharer;
import com.facebook.appevents.AppEventsLogger;
import com.facebook.appevents.AppEventsConstants;
import com.facebook.internal.ServerProtocol;

public class FacebookExtension2 extends RunnerSocial {
	// Facebook communication settings
	public static final String STATUS_IDLE = "IDLE";
	public static final String STATUS_PROCESSING = "PROCESSING";
	public static final String STATUS_FAILED = "FAILED";
	public static final String STATUS_AUTHORISED = "AUTHORISED";
	private static final int EVENT_OTHER_SOCIAL = 70;

	// App Events (re-defined from extension macros)
	public static final int FacebookExtension2_EVENT_ACHIEVED_LEVEL = 101;
	public static final int FacebookExtension2_EVENT_ADDED_PAYMENT_INFO = 102;
	public static final int FacebookExtension2_EVENT_ADDED_TO_CART = 103;
	public static final int FacebookExtension2_EVENT_ADDED_TO_WISHLIST = 104;
	public static final int FacebookExtension2_EVENT_COMPLETED_REGISTRATION = 105;
	public static final int FacebookExtension2_EVENT_COMPLETED_TUTORIAL = 106;
	public static final int FacebookExtension2_EVENT_INITIATED_CHECKOUT = 107;
	public static final int FacebookExtension2_EVENT_RATED = 109;
	public static final int FacebookExtension2_EVENT_SEARCHED = 110;
	public static final int FacebookExtension2_EVENT_SPENT_CREDITS = 111;
	public static final int FacebookExtension2_EVENT_UNLOCKED_ACHIEVEMENT = 112;
	public static final int FacebookExtension2_EVENT_VIEWED_CONTENT = 113;

	// App event parameters (re-defined from extension macros)
	public static final int FacebookExtension2_PARAM_CONTENT_ID = 1003;
	public static final int FacebookExtension2_PARAM_CONTENT_TYPE = 1004;
	public static final int FacebookExtension2_PARAM_CURRENCY = 1005;
	public static final int FacebookExtension2_PARAM_DESCRIPTION = 1006;
	public static final int FacebookExtension2_PARAM_LEVEL = 1007;
	public static final int FacebookExtension2_PARAM_MAX_RATING_VALUE = 1008;
	public static final int FacebookExtension2_PARAM_NUM_ITEMS = 1009;
	public static final int FacebookExtension2_PARAM_PAYMENT_INFO_AVAILABLE = 1010;
	public static final int FacebookExtension2_PARAM_REGISTRATION_METHOD = 1011;
	public static final int FacebookExtension2_PARAM_SEARCH_STRING = 1012;
	public static final int FacebookExtension2_PARAM_SUCCESS = 1013;

	public static String msLoginStatus = STATUS_IDLE;
	public static String msUserId = "";
	public static double msInitialized = 0;
	private static int msRequestId = 1;
	private static boolean mbPermissionsRequestInProgress = false;
	private static boolean HaveRequestedUserId = false;

	private CallbackManager callbackManager = null;
	private LoginManager loginManager = null;

	private class FacebookLoginCallback implements FacebookCallback<LoginResult> {
		private int m_requestId;

		FacebookLoginCallback(int _requestId) {
			m_requestId = _requestId;
		}

		public int getRequestId() {
			return m_requestId;
		}

		@Override
		public void onSuccess(LoginResult loginResult) {
			// App code
			Log.i("yoyo", "Login onSuccess: result:" + loginResult);

			int dsMapIndex = RunnerJNILib.jCreateDsMap(null, null, null);
			RunnerJNILib.dsMapAddInt(dsMapIndex, "requestId", m_requestId);
			RunnerJNILib.dsMapAddString(dsMapIndex, "type", "facebook_login_result");
			RunnerJNILib.dsMapAddString(dsMapIndex, "status", "success");

			AccessToken token = AccessToken.getCurrentAccessToken();
			if (token != null) {
				if (!token.isExpired()) {
					Set permissions = token.getPermissions();

					Iterator<String> it = permissions.iterator();
					while (it.hasNext()) {
						RunnerJNILib.dsMapAddString(dsMapIndex, it.next(), "granted");
					}

					permissions = token.getDeclinedPermissions();
					it = permissions.iterator();
					while (it.hasNext()) {
						RunnerJNILib.dsMapAddString(dsMapIndex, it.next(), "declined");
					}
				}
			}

			RunnerJNILib.CreateAsynEventWithDSMap(dsMapIndex, EVENT_OTHER_SOCIAL);
			fb_set_status(STATUS_AUTHORISED);
		}

		@Override
		public void onCancel() {
			// App code
			Log.i("yoyo", "Login onCancel");

			int dsMapIndex = RunnerJNILib.jCreateDsMap(null, null, null);
			RunnerJNILib.dsMapAddInt(dsMapIndex, "requestId", m_requestId);
			RunnerJNILib.dsMapAddString(dsMapIndex, "type", "facebook_login_result");
			RunnerJNILib.dsMapAddString(dsMapIndex, "status", "cancelled");
			RunnerJNILib.CreateAsynEventWithDSMap(dsMapIndex, EVENT_OTHER_SOCIAL);
			fb_set_status(STATUS_FAILED);
		}

		@Override
		public void onError(FacebookException exception) {
			// App code
			Log.i("yoyo", "Login onError: exception:" + exception);

			int dsMapIndex = RunnerJNILib.jCreateDsMap(null, null, null);
			RunnerJNILib.dsMapAddInt(dsMapIndex, "requestId", m_requestId);
			RunnerJNILib.dsMapAddString(dsMapIndex, "type", "facebook_login_result");
			RunnerJNILib.dsMapAddString(dsMapIndex, "status", "error");
			RunnerJNILib.dsMapAddString(dsMapIndex, "exception", exception.getMessage());
			RunnerJNILib.CreateAsynEventWithDSMap(dsMapIndex, EVENT_OTHER_SOCIAL);
			fb_set_status(STATUS_FAILED);
		}
	};

	private int getNewRequestId() {
		return msRequestId++;
	}

	private ArrayList<String> dsListToStringArray(int dsListId) {

		ArrayList<String> arrayList = new ArrayList<String>();

		Log.i("yoyo", "dsListToStringArray. List ID: " + dsListId);
		int listCount = RunnerJNILib.dsListGetSize(dsListId);
		if (listCount == 0) {
			Log.i("yoyo", "DS list size is zero");
			return arrayList;
		}

		Log.i("yoyo", "ds_list size: " + listCount);
		for (int listIdx = 0; listIdx < listCount; ++listIdx) {
			String currentItem = RunnerJNILib.dsListGetValueString(dsListId, listIdx);
			arrayList.add(currentItem);

			Log.i("yoyo", "Added item to string array: " + currentItem);
		}

		return arrayList;
	}

	private String getFacebookSDKVersion() {
		String sdkVersion = null;
		ClassLoader classLoader = getClass().getClassLoader();
		Class<?> cls;

		try {
			cls = classLoader.loadClass("com.facebook.FacebookSdkVersion");
			Field field = cls.getField("BUILD");
			sdkVersion = String.valueOf(field.get(null));
		} catch (ClassNotFoundException e) {
			// error
		} catch (NoSuchFieldException e) {
			// error
		} catch (IllegalArgumentException e) {
			// error
		} catch (IllegalAccessException e) {
			// error
		}

		return sdkVersion;
	}

	public void fb_init() {
		if (msInitialized == 1)
			return;
		final Activity activity = RunnerActivity.CurrentActivity;

		// Disable automatic Facebook SDK initialization
		FacebookSdk.setAutoInitEnabled(false);

		try {
			// Set Facebook App ID and Client Token
			FacebookSdk.setApplicationId(activity.getResources().getString(R.string.facebook_app_id));
			FacebookSdk.setClientToken(activity.getResources().getString(R.string.facebook_client_token));

			// Initialize Facebook SDK
			FacebookSdk.sdkInitialize(activity.getApplicationContext(), new FacebookSdk.InitializeCallback() {
				@Override
				public void onInitialized() {
					// SDK initialized, proceed with other setup
					// Since this is a background thread, switch to main thread avoid ANR
					activity.runOnUiThread(new Runnable() {
						@Override
						public void run() {
							// Optionally, activate App Events
							// AppEventsLogger.activateApp(activity);
							callbackManager = CallbackManager.Factory.create();
							// This is required to mark the SDK as fully initialized
							FacebookSdk.fullyInitialize();
							msInitialized = 1;
							Log.i("yoyo", "Facebook SDK initialized successfully.");
						}
					});
				}
			});
		} catch (Exception e) {
			Log.i("yoyo", "Error initializing Facebook SDK: " + e.getMessage());
		}
	}

	public double fb_send_event(double _eventId, double _eventValue, double _eventParamsDsList) {
		AppEventsLogger logger = AppEventsLogger.newLogger(RunnerActivity.CurrentActivity);

		// Parse event type
		String eventTypeParsed = "";
		switch ((int) (_eventId)) {
			case FacebookExtension2_EVENT_ACHIEVED_LEVEL:
				eventTypeParsed = AppEventsConstants.EVENT_NAME_ACHIEVED_LEVEL;
				break;
			case FacebookExtension2_EVENT_ADDED_PAYMENT_INFO:
				eventTypeParsed = AppEventsConstants.EVENT_NAME_ADDED_PAYMENT_INFO;
				break;
			case FacebookExtension2_EVENT_ADDED_TO_CART:
				eventTypeParsed = AppEventsConstants.EVENT_NAME_ADDED_TO_CART;
				break;
			case FacebookExtension2_EVENT_ADDED_TO_WISHLIST:
				eventTypeParsed = AppEventsConstants.EVENT_NAME_ADDED_TO_WISHLIST;
				break;
			case FacebookExtension2_EVENT_COMPLETED_REGISTRATION:
				eventTypeParsed = AppEventsConstants.EVENT_NAME_COMPLETED_REGISTRATION;
				break;
			case FacebookExtension2_EVENT_COMPLETED_TUTORIAL:
				eventTypeParsed = AppEventsConstants.EVENT_NAME_COMPLETED_TUTORIAL;
				break;
			case FacebookExtension2_EVENT_INITIATED_CHECKOUT:
				eventTypeParsed = AppEventsConstants.EVENT_NAME_INITIATED_CHECKOUT;
				break;
			case FacebookExtension2_EVENT_RATED:
				eventTypeParsed = AppEventsConstants.EVENT_NAME_RATED;
				break;
			case FacebookExtension2_EVENT_SEARCHED:
				eventTypeParsed = AppEventsConstants.EVENT_NAME_SEARCHED;
				break;
			case FacebookExtension2_EVENT_SPENT_CREDITS:
				eventTypeParsed = AppEventsConstants.EVENT_NAME_SPENT_CREDITS;
				break;
			case FacebookExtension2_EVENT_UNLOCKED_ACHIEVEMENT:
				eventTypeParsed = AppEventsConstants.EVENT_NAME_UNLOCKED_ACHIEVEMENT;
				break;
			case FacebookExtension2_EVENT_VIEWED_CONTENT:
				eventTypeParsed = AppEventsConstants.EVENT_NAME_VIEWED_CONTENT;
				break;

			default:
				Log.i("yoyo", "Invalid event type passed to fb_send_event data: " + _eventId);
				return 0.0;
		}

		// Parse parameters
		Bundle paramsBundle = new Bundle();
		if (_eventParamsDsList >= 0.0) {
			// Check if the list contains key/value pairs
			int len = RunnerJNILib.dsListGetSize((int) _eventParamsDsList);
			if (len >= 2 && len % 2 == 0) {
				for (int i = 0; i < len; i += 2) {
					// Parse ds list key as double
					int paramKey = (int) (RunnerJNILib.dsListGetValueDouble((int) _eventParamsDsList, i));
					String paramKeyParsed = null;

					// Parse param key
					switch (paramKey) {
						case FacebookExtension2_PARAM_CONTENT_ID:
							paramKeyParsed = AppEventsConstants.EVENT_PARAM_CONTENT_ID;
							break;
						case FacebookExtension2_PARAM_CONTENT_TYPE:
							paramKeyParsed = AppEventsConstants.EVENT_PARAM_CONTENT_TYPE;
							break;
						case FacebookExtension2_PARAM_CURRENCY:
							paramKeyParsed = AppEventsConstants.EVENT_PARAM_CURRENCY;
							break;
						case FacebookExtension2_PARAM_DESCRIPTION:
							paramKeyParsed = AppEventsConstants.EVENT_PARAM_DESCRIPTION;
							break;
						case FacebookExtension2_PARAM_LEVEL:
							paramKeyParsed = AppEventsConstants.EVENT_PARAM_LEVEL;
							break;
						case FacebookExtension2_PARAM_MAX_RATING_VALUE:
							paramKeyParsed = AppEventsConstants.EVENT_PARAM_MAX_RATING_VALUE;
							break;
						case FacebookExtension2_PARAM_NUM_ITEMS:
							paramKeyParsed = AppEventsConstants.EVENT_PARAM_NUM_ITEMS;
							break;
						case FacebookExtension2_PARAM_PAYMENT_INFO_AVAILABLE:
							paramKeyParsed = AppEventsConstants.EVENT_PARAM_PAYMENT_INFO_AVAILABLE;
							break;
						case FacebookExtension2_PARAM_REGISTRATION_METHOD:
							paramKeyParsed = AppEventsConstants.EVENT_PARAM_REGISTRATION_METHOD;
							break;
						case FacebookExtension2_PARAM_SEARCH_STRING:
							paramKeyParsed = AppEventsConstants.EVENT_PARAM_SEARCH_STRING;
							break;
						case FacebookExtension2_PARAM_SUCCESS:
							paramKeyParsed = AppEventsConstants.EVENT_PARAM_SUCCESS;
							break;

						default:
							Log.i("yoyo", "Invalid parameter passed to fb_send_event data: " + paramKey);
							break;
					}

					if (paramKeyParsed != null) {
						// Parse param value
						String paramValAsStr = RunnerJNILib.dsListGetValueString((int) _eventParamsDsList, i + 1);
						if (paramValAsStr != null) {
							paramsBundle.putString(paramKeyParsed, paramValAsStr);
							Log.i("yoyo", "Added to bundle as string. " + paramKeyParsed + " : " + paramValAsStr);
						} else {
							double paramValAsDouble = RunnerJNILib.dsListGetValueDouble((int) _eventParamsDsList,
									i + 1);
							paramsBundle.putDouble(paramKeyParsed, paramValAsDouble);
							Log.i("yoyo", "Added to bundle as double. " + paramKeyParsed + " : " + paramValAsDouble);
						}
					}
				}
			}
		}

		// Send app event
		logger.logEvent(eventTypeParsed, _eventValue, paramsBundle);
		return 1.0;
	}
	
	public double fb_send_event(String _eventId, double _eventValue, double _eventParamsDsList) {
		AppEventsLogger logger = AppEventsLogger.newLogger(RunnerActivity.CurrentActivity);
Log.i("yoyo","_eventId: " + _eventId);
		// Parse event type
		String eventTypeParsed = _eventId;

		// Parse parameters
		Bundle paramsBundle = new Bundle();
		if (_eventParamsDsList >= 0.0) {
			// Check if the list contains key/value pairs
			int len = RunnerJNILib.dsListGetSize((int) _eventParamsDsList);
			if (len >= 2 && len % 2 == 0) {
				for (int i = 0; i < len; i += 2) {
					// Parse ds list key as double
					String paramKey = (RunnerJNILib.dsListGetValueString((int) _eventParamsDsList, i));
					String paramKeyParsed = null;
					
					paramKeyParsed = paramKey;
Log.i("yoyo","paramKeyParsed: " + paramKeyParsed);
					if (paramKeyParsed != null) {
						// Parse param value
						String paramValAsStr = RunnerJNILib.dsListGetValueString((int) _eventParamsDsList, i + 1);
						if (paramValAsStr != null) {
							paramsBundle.putString(paramKeyParsed, paramValAsStr);
							Log.i("yoyo", "Added to bundle as string. " + paramKeyParsed + " : " + paramValAsStr);
						} else {
							double paramValAsDouble = RunnerJNILib.dsListGetValueDouble((int) _eventParamsDsList,
									i + 1);
							paramsBundle.putDouble(paramKeyParsed, paramValAsDouble);
							Log.i("yoyo", "Added to bundle as double. " + paramKeyParsed + " : " + paramValAsDouble);
						}
					}
				}
			}
		}

		// Send app event
		logger.logEvent(eventTypeParsed, _eventValue, paramsBundle);
		return 1.0;
	}

	public String fb_user_id() {
		try {
			if (Profile.getCurrentProfile() != null) {
				Profile profile = Profile.getCurrentProfile();
				return profile.getId();
			}
		} catch (Exception e) {
			return "";
		}

		return "";
	}

	public String fb_status() {
		return msLoginStatus;
	}

	private double fb_login(double permissions_list) {
		Log.i("yoyo", "fb_login called! Permissions list ID: " + permissions_list);

		loginManager = LoginManager.getInstance();

		fb_set_status(STATUS_PROCESSING);

		return fb_request_permissions(permissions_list, PERMISSION_TYPE_READ);
	}

	public double fb_login(double permissions_list, double loginType) {
		return fb_login(permissions_list);
	}

	private static void fb_set_status(String newState) {
		Log.i("yoyo", "Facebook login status: " + msLoginStatus);
		msLoginStatus = newState;
	}

	public Boolean fb_check_permission(String _permission) {
		AccessToken token = AccessToken.getCurrentAccessToken();
		if (token != null) {
			if (!token.isExpired()) {
				Log.i("yoyo", "About to check for permission:" + _permission);
				Set permissions = token.getPermissions();

				Iterator<String> it = permissions.iterator();
				while (it.hasNext()) {
					Log.i("yoyo", "Found permission:" + it.next());
				}

				if (permissions.contains(_permission)) {
					Log.i("yoyo", "Permission found");
					return true;
				}
			}
		}

		Log.i("yoyo", "Permission not found");
		return false;
	}

	private final int PERMISSION_TYPE_READ = 1;
	private final int PERMISSION_TYPE_PUBLISH = 2;

	public double fb_request_read_permissions(double permissions_list) {
		return fb_request_permissions(permissions_list, PERMISSION_TYPE_READ);
	}

	public double fb_request_publish_permissions(double permissions_list) {
		return fb_request_permissions(permissions_list, PERMISSION_TYPE_PUBLISH);
	}

	private double fb_request_permissions(double permissions_list, int permission_type) {
		final ArrayList<String> permissions = dsListToStringArray((int) permissions_list);
		final int currentRequestId = getNewRequestId();

		if (loginManager != null) {
			RunnerActivity.ViewHandler.post(new Runnable() {
				public void run() {
					loginManager.registerCallback(callbackManager, new FacebookLoginCallback(currentRequestId));

					switch (permission_type) {
						case PERMISSION_TYPE_PUBLISH:
							loginManager.logInWithPublishPermissions(RunnerActivity.CurrentActivity, permissions);
							break;
						case PERMISSION_TYPE_READ:
							loginManager.logInWithReadPermissions(RunnerActivity.CurrentActivity, permissions);
							break;

					}
				}
			});
		}

		return currentRequestId;
	}

	public String fb_accesstoken() {
		try {
			AccessToken token = AccessToken.getCurrentAccessToken();
			return (token != null && !token.isExpired()) ? token.getToken() : "";
		} catch (Exception e) {
			return "";
		}
	}

	public void fb_logout() {
		if (loginManager != null) {
			loginManager.logOut();
		}
		fb_set_status(STATUS_IDLE);
	}

	public double fb_graph_request(final String graphPath, final String httpMethod, final double paramListId) {
		final int currentRequestId = getNewRequestId();
		final Bundle parameters = buildParamsBundle((int) paramListId);

		Runnable exec = new Runnable() {
			public void run() {
				try {
					if (!httpMethod.equals("GET") && !httpMethod.equals("POST") && !httpMethod.equals("DELETE")) {
						throw new IllegalArgumentException(
								"The httpMethod for a Facebook graph request must be one of 'GET', 'POST' or 'DELETE', value supplied was: "
										+ httpMethod);
					}

					Log.i("yoyo",
							"Making graph API request for path: " + graphPath + " with httpMethod: " + httpMethod);

					HttpMethod httpmethod = HttpMethod.POST;
					if (httpMethod.equals("GET"))
						httpmethod = HttpMethod.GET;
					else if (httpMethod.equals("DELETE"))
						httpmethod = HttpMethod.DELETE;

					GraphRequest request = new GraphRequest(AccessToken.getCurrentAccessToken(), graphPath, parameters,
							httpmethod, new GraphRequest.Callback() {
								public void onCompleted(GraphResponse response) {
									int dsMapIndex = RunnerJNILib.jCreateDsMap(null, null, null);
									RunnerJNILib.dsMapAddInt(dsMapIndex, "requestId", currentRequestId);
									RunnerJNILib.dsMapAddString(dsMapIndex, "type", "fb_graph_request");

									if (response != null) {
										if (response.getError() != null) {
											// Error
											RunnerJNILib.dsMapAddString(dsMapIndex, "status", "error");
											RunnerJNILib.dsMapAddString(dsMapIndex, "exception",
													response.getError().getErrorMessage());
										} else {
											// Success
											RunnerJNILib.dsMapAddString(dsMapIndex, "status", "success");
											RunnerJNILib.dsMapAddString(dsMapIndex, "response_text",
													response.getRawResponse());
										}
									} else {
										// Null response
										RunnerJNILib.dsMapAddString(dsMapIndex, "status", "error");
										RunnerJNILib.dsMapAddString(dsMapIndex, "exception",
												"Unknown error: Graph response is NULL.");
									}

									RunnerJNILib.CreateAsynEventWithDSMap(dsMapIndex, EVENT_OTHER_SOCIAL);
								}
							});

					request.executeAsync();
				} catch (Exception e) {
					int dsMapIndex = RunnerJNILib.jCreateDsMap(null, null, null);
					RunnerJNILib.dsMapAddInt(dsMapIndex, "requestId", currentRequestId);
					RunnerJNILib.dsMapAddString(dsMapIndex, "type", "fb_graph_request");
					RunnerJNILib.dsMapAddString(dsMapIndex, "status", "error");
					RunnerJNILib.dsMapAddString(dsMapIndex, "exception", e.getMessage());
					RunnerJNILib.CreateAsynEventWithDSMap(dsMapIndex, EVENT_OTHER_SOCIAL);
				}
			}
		};

		RunnerActivity.ViewHandler.post(exec);
		return currentRequestId;
	}

	private Bundle buildParamsBundle(int dsListId) {
		Bundle paramsBundle = new Bundle();

		if (dsListId < 0) {
			return paramsBundle;
		}

		int listLength = RunnerJNILib.dsListGetSize(dsListId);

		if ((listLength & 0x1) != 0) {
			throw new IllegalArgumentException("There must be an even number of strings forming key-value pairs");
		}

		try {
			// Populate the Bundle parameters with the key-value pairs
			for (int n = 0; n < listLength; n += 2) {
				// Parse param value
				String keyAsString = RunnerJNILib.dsListGetValueString(dsListId, n);
				if (keyAsString == null) {
					Log.i("yoyo", "Unable to add non-string key to bundle.");
					continue;
				}

				String valAsString = RunnerJNILib.dsListGetValueString(dsListId, n + 1);
				if (valAsString != null) {
					paramsBundle.putString(keyAsString, valAsString);
					Log.i("yoyo", "Added to bundle as string. " + keyAsString + " : " + valAsString);
				} else {
					double valAsDouble = RunnerJNILib.dsListGetValueDouble(dsListId, n + 1);
					paramsBundle.putDouble(keyAsString, valAsDouble);
					Log.i("yoyo", "Added to bundle as double. " + keyAsString + " : " + valAsDouble);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		return paramsBundle;
	}

	public double fb_refresh_accesstoken() {
		final int currentRequestId = getNewRequestId();

		if (AccessToken.getCurrentAccessToken() != null) {
			AccessToken.refreshCurrentAccessTokenAsync(new AccessToken.AccessTokenRefreshCallback() {
				@Override
				public void OnTokenRefreshed(AccessToken at) {
					// Success
					int dsMapIndex = RunnerJNILib.jCreateDsMap(null, null, null);
					RunnerJNILib.dsMapAddString(dsMapIndex, "type", "fb_refresh_accesstoken");
					RunnerJNILib.dsMapAddInt(dsMapIndex, "requestId", currentRequestId);
					RunnerJNILib.dsMapAddString(dsMapIndex, "status", "success");
					RunnerJNILib.dsMapAddString(dsMapIndex, "access_token", at.getToken());
					RunnerJNILib.CreateAsynEventWithDSMap(dsMapIndex, EVENT_OTHER_SOCIAL);
				};

				@Override
				public void OnTokenRefreshFailed(FacebookException exception) {
					// Failure - Graph error
					int dsMapIndex = RunnerJNILib.jCreateDsMap(null, null, null);
					RunnerJNILib.dsMapAddString(dsMapIndex, "type", "fb_refresh_accesstoken");
					RunnerJNILib.dsMapAddInt(dsMapIndex, "requestId", currentRequestId);
					RunnerJNILib.dsMapAddString(dsMapIndex, "status", "error");
					RunnerJNILib.dsMapAddString(dsMapIndex, "exception", exception.getMessage());
					RunnerJNILib.CreateAsynEventWithDSMap(dsMapIndex, EVENT_OTHER_SOCIAL);
				};
			});
		} else {
			// Failure - user not logged in
			int dsMapIndex = RunnerJNILib.jCreateDsMap(null, null, null);
			RunnerJNILib.dsMapAddString(dsMapIndex, "type", "fb_refresh_accesstoken");
			RunnerJNILib.dsMapAddInt(dsMapIndex, "requestId", currentRequestId);
			RunnerJNILib.dsMapAddString(dsMapIndex, "status", "error");
			RunnerJNILib.dsMapAddString(dsMapIndex, "exception",
					"User must be logged in before access token can be refreshed.");
			RunnerJNILib.CreateAsynEventWithDSMap(dsMapIndex, EVENT_OTHER_SOCIAL);
		}

		return currentRequestId;
	}

	public int fb_dialog(final String link_url) {
		final int currentRequestId = getNewRequestId();

		RunnerActivity.ViewHandler.post(new Runnable() {
			public void run() {
				ShareLinkContent shareContent = new ShareLinkContent.Builder().setContentUrl(Uri.parse(link_url))
						.build();

				ShareDialog shareDialog = new ShareDialog(RunnerActivity.CurrentActivity);
				shareDialog.registerCallback(callbackManager, new FacebookCallback<ShareDialog.Result>() {
					@Override
					public void onSuccess(Sharer.Result o) {
						Log.i("yoyo", "share dialog success");
						Log.i("yoyo", o.toString());

						int dsMapIndex = RunnerJNILib.jCreateDsMap(null, null, null);
						RunnerJNILib.dsMapAddString(dsMapIndex, "type", "fb_dialog");
						RunnerJNILib.dsMapAddInt(dsMapIndex, "requestId", currentRequestId);
						RunnerJNILib.dsMapAddString(dsMapIndex, "status", "success");

						if (o.getPostId() != null) {
							Log.i("yoyo", "post_id=" + o.getPostId());
							RunnerJNILib.dsMapAddString(dsMapIndex, "postId", o.getPostId());
						}

						RunnerJNILib.CreateAsynEventWithDSMap(dsMapIndex, EVENT_OTHER_SOCIAL);
					}

					@Override
					public void onCancel() {
						Log.i("yoyo", "share dialog  onCancel");

						int dsMapIndex = RunnerJNILib.jCreateDsMap(null, null, null);
						RunnerJNILib.dsMapAddString(dsMapIndex, "type", "fb_dialog");
						RunnerJNILib.dsMapAddInt(dsMapIndex, "requestId", currentRequestId);
						RunnerJNILib.dsMapAddString(dsMapIndex, "status", "cancelled");
						RunnerJNILib.CreateAsynEventWithDSMap(dsMapIndex, EVENT_OTHER_SOCIAL);
					}

					@Override
					public void onError(FacebookException error) {
						Log.i("yoyo", "share dialog error:" + error.getMessage());

						int dsMapIndex = RunnerJNILib.jCreateDsMap(null, null, null);
						RunnerJNILib.dsMapAddString(dsMapIndex, "type", "fb_dialog");
						RunnerJNILib.dsMapAddInt(dsMapIndex, "requestId", currentRequestId);
						RunnerJNILib.dsMapAddString(dsMapIndex, "status", "error");
						RunnerJNILib.dsMapAddString(dsMapIndex, "exception", error.getMessage());
						RunnerJNILib.CreateAsynEventWithDSMap(dsMapIndex, EVENT_OTHER_SOCIAL);
					}
				});

				shareDialog.show(shareContent);
			}
		});

		return currentRequestId;
	}

	public double fb_ready() {
		return msInitialized;
	}

	// Lifecycle methods
	@Override
	public void onActivityResult(int requestCode, int resultCode, Intent intent) {
		Log.i("yoyo", "Got activity request code:" + requestCode + " resultCode:" + resultCode + " data:" + intent);
		if (callbackManager != null)
			callbackManager.onActivityResult(requestCode, resultCode, intent);
	}

}