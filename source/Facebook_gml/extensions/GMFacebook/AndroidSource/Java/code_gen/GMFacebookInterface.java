// ##### extgen :: Auto-generated file do not edit!! #####

package ${YYAndroidPackageName};
import ${YYAndroidPackageName}.GMExtWire.GMFunction;
import ${YYAndroidPackageName}.GMExtWire.GMValue;
import ${YYAndroidPackageName}.enums.*;
import ${YYAndroidPackageName}.records.*;

import java.util.List;

public interface GMFacebookInterface {
    public void fb_initialize(GMFunction callback);
    public boolean fb_ready();
    public FacebookLoginStatus fb_status();
    public boolean fb_is_logged_in();
    public String fb_user_id();
    public String fb_access_token();
    public void fb_logout();
    public void fb_set_auto_log_app_events_enabled(boolean enabled);
    public boolean fb_auto_log_app_events_enabled();
    public void fb_set_advertiser_id_collection_enabled(boolean enabled);
    public boolean fb_advertiser_id_collection_enabled();
    public void fb_set_event_data_usage_limited(boolean enabled);
    public boolean fb_event_data_usage_limited();
    public void fb_set_data_processing_options(java.util.List<String> options, int country, int state);
    public boolean fb_check_permission(String permission);
    public void fb_login(java.util.List<String> permissions, GMFunction callback);
    public void fb_request_read_permissions(java.util.List<String> permissions, GMFunction callback);
    public void fb_request_publish_permissions(java.util.List<String> permissions, GMFunction callback);
    public void fb_refresh_access_token(GMFunction callback);
    public void fb_graph_request(String graph_path, FacebookHttpMethod method, java.util.List<FacebookNamedValue> parameters, GMFunction callback);
    public void fb_dialog(String link_url, GMFunction callback);
    public boolean fb_send_event(FacebookAppEvent event, double value, java.util.List<FacebookEventParameterValue> parameters);
    public boolean fb_send_custom_event(String event_name, double value, java.util.List<FacebookNamedValue> parameters);
    public boolean fb_send_purchase(double amount, String currency, java.util.List<FacebookNamedValue> parameters);
    public void fb_flush_events();
    public void fb_set_event_user_id(String user_id);
    public String fb_get_event_user_id();
    public void fb_clear_event_user_id();
}