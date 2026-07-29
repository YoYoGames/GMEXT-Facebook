// ##### extgen :: Auto-generated file do not edit!! #####

package ${YYAndroidPackageName};

import java.nio.ByteBuffer;
import java.util.*;
import ${YYAndroidPackageName}.GMExtWire;
import ${YYAndroidPackageName}.GMExtWire.GMFunction;
import ${YYAndroidPackageName}.GMExtWire.GMValue;
import ${YYAndroidPackageName}.records.*;
import ${YYAndroidPackageName}.codecs.*;
import ${YYAndroidPackageName}.enums.*;

public abstract class GMFacebookInternal extends RunnerSocial implements GMFacebookInterface {

    private final GMExtWire.DispatchQueue __dispatch_queue = new GMExtWire.DispatchQueue();
    public double __EXT_NATIVE__GMFacebook_invocation_handler(ByteBuffer __ret_buffer, double __ret_buffer_length)
    {
        return __dispatch_queue.fetch(__ret_buffer);
    }

    public double __EXT_NATIVE__fb_initialize(ByteBuffer __arg_buffer, double __arg_buffer_length)
    {
        GMExtWire.order(__arg_buffer);

        // field: callback, type: Function
        GMFunction callback = GMExtWire.readGMFunction(__arg_buffer, __dispatch_queue);

        fb_initialize(callback);
        return 0;
    }

    public double __EXT_NATIVE__fb_ready()
    {
        boolean __result = fb_ready();
        return __result ? 1.0 : 0.0;
    }

    public double __EXT_NATIVE__fb_status(ByteBuffer __ret_buffer, double __ret_buffer_length)
    {
        FacebookLoginStatus __result = fb_status();

        GMExtWire.order(__ret_buffer);
        // return: __result, type: enum FacebookLoginStatus
        GMExtWire.writeI32(__ret_buffer, __result.value());

        return 0;
    }

    public double __EXT_NATIVE__fb_is_logged_in()
    {
        boolean __result = fb_is_logged_in();
        return __result ? 1.0 : 0.0;
    }

    public String __EXT_NATIVE__fb_user_id()
    {
        String __result = fb_user_id();
        return __result;
    }

    public String __EXT_NATIVE__fb_access_token()
    {
        String __result = fb_access_token();
        return __result;
    }

    public double __EXT_NATIVE__fb_logout()
    {
        fb_logout();
        return 0;
    }

    public double __EXT_NATIVE__fb_set_auto_log_app_events_enabled(double enabled)
    {
        fb_set_auto_log_app_events_enabled(enabled != 0);
        return 0;
    }

    public double __EXT_NATIVE__fb_auto_log_app_events_enabled()
    {
        boolean __result = fb_auto_log_app_events_enabled();
        return __result ? 1.0 : 0.0;
    }

    public double __EXT_NATIVE__fb_set_advertiser_id_collection_enabled(double enabled)
    {
        fb_set_advertiser_id_collection_enabled(enabled != 0);
        return 0;
    }

    public double __EXT_NATIVE__fb_advertiser_id_collection_enabled()
    {
        boolean __result = fb_advertiser_id_collection_enabled();
        return __result ? 1.0 : 0.0;
    }

    public double __EXT_NATIVE__fb_set_event_data_usage_limited(double enabled)
    {
        fb_set_event_data_usage_limited(enabled != 0);
        return 0;
    }

    public double __EXT_NATIVE__fb_event_data_usage_limited()
    {
        boolean __result = fb_event_data_usage_limited();
        return __result ? 1.0 : 0.0;
    }

    public double __EXT_NATIVE__fb_set_data_processing_options(ByteBuffer __arg_buffer, double __arg_buffer_length)
    {
        GMExtWire.order(__arg_buffer);

        // field: options, type: String[]
        java.util.List<String> options = GMExtWire.readList(__arg_buffer, bb -> GMExtWire.readString(bb));

        // field: country, type: Int32
        int country = GMExtWire.readI32(__arg_buffer);

        // field: state, type: Int32
        int state = GMExtWire.readI32(__arg_buffer);

        fb_set_data_processing_options(options, country, state);
        return 0;
    }

    public double __EXT_NATIVE__fb_check_permission(String permission)
    {
        boolean __result = fb_check_permission(permission);
        return __result ? 1.0 : 0.0;
    }

    public double __EXT_NATIVE__fb_login(ByteBuffer __arg_buffer, double __arg_buffer_length)
    {
        GMExtWire.order(__arg_buffer);

        // field: permissions, type: String[]
        java.util.List<String> permissions = GMExtWire.readList(__arg_buffer, bb -> GMExtWire.readString(bb));

        // field: callback, type: Function
        GMFunction callback = GMExtWire.readGMFunction(__arg_buffer, __dispatch_queue);

        fb_login(permissions, callback);
        return 0;
    }

    public double __EXT_NATIVE__fb_request_read_permissions(ByteBuffer __arg_buffer, double __arg_buffer_length)
    {
        GMExtWire.order(__arg_buffer);

        // field: permissions, type: String[]
        java.util.List<String> permissions = GMExtWire.readList(__arg_buffer, bb -> GMExtWire.readString(bb));

        // field: callback, type: Function
        GMFunction callback = GMExtWire.readGMFunction(__arg_buffer, __dispatch_queue);

        fb_request_read_permissions(permissions, callback);
        return 0;
    }

    public double __EXT_NATIVE__fb_request_publish_permissions(ByteBuffer __arg_buffer, double __arg_buffer_length)
    {
        GMExtWire.order(__arg_buffer);

        // field: permissions, type: String[]
        java.util.List<String> permissions = GMExtWire.readList(__arg_buffer, bb -> GMExtWire.readString(bb));

        // field: callback, type: Function
        GMFunction callback = GMExtWire.readGMFunction(__arg_buffer, __dispatch_queue);

        fb_request_publish_permissions(permissions, callback);
        return 0;
    }

    public double __EXT_NATIVE__fb_refresh_access_token(ByteBuffer __arg_buffer, double __arg_buffer_length)
    {
        GMExtWire.order(__arg_buffer);

        // field: callback, type: Function
        GMFunction callback = GMExtWire.readGMFunction(__arg_buffer, __dispatch_queue);

        fb_refresh_access_token(callback);
        return 0;
    }

    public double __EXT_NATIVE__fb_graph_request(ByteBuffer __arg_buffer, double __arg_buffer_length)
    {
        GMExtWire.order(__arg_buffer);

        // field: graph_path, type: String
        String graph_path = GMExtWire.readString(__arg_buffer);

        // field: method, type: enum FacebookHttpMethod
        FacebookHttpMethod method = FacebookHttpMethod.from(GMExtWire.readI32(__arg_buffer));

        // field: parameters, type: struct FacebookNamedValue[]
        java.util.List<FacebookNamedValue> parameters = GMExtWire.readList(__arg_buffer, bb -> FacebookNamedValueCodec.read(bb));

        // field: callback, type: Function
        GMFunction callback = GMExtWire.readGMFunction(__arg_buffer, __dispatch_queue);

        fb_graph_request(graph_path, method, parameters, callback);
        return 0;
    }

    public double __EXT_NATIVE__fb_dialog(ByteBuffer __arg_buffer, double __arg_buffer_length)
    {
        GMExtWire.order(__arg_buffer);

        // field: link_url, type: String
        String link_url = GMExtWire.readString(__arg_buffer);

        // field: callback, type: Function
        GMFunction callback = GMExtWire.readGMFunction(__arg_buffer, __dispatch_queue);

        fb_dialog(link_url, callback);
        return 0;
    }

    public double __EXT_NATIVE__fb_send_event(ByteBuffer __arg_buffer, double __arg_buffer_length)
    {
        GMExtWire.order(__arg_buffer);

        // field: event, type: enum FacebookAppEvent
        FacebookAppEvent event = FacebookAppEvent.from(GMExtWire.readI32(__arg_buffer));

        // field: value, type: Float64
        double value = GMExtWire.readF64(__arg_buffer);

        // field: parameters, type: struct FacebookEventParameterValue[]
        java.util.List<FacebookEventParameterValue> parameters = GMExtWire.readList(__arg_buffer, bb -> FacebookEventParameterValueCodec.read(bb));

        boolean __result = fb_send_event(event, value, parameters);
        return __result ? 1.0 : 0.0;
    }

    public double __EXT_NATIVE__fb_send_custom_event(ByteBuffer __arg_buffer, double __arg_buffer_length)
    {
        GMExtWire.order(__arg_buffer);

        // field: event_name, type: String
        String event_name = GMExtWire.readString(__arg_buffer);

        // field: value, type: Float64
        double value = GMExtWire.readF64(__arg_buffer);

        // field: parameters, type: struct FacebookNamedValue[]
        java.util.List<FacebookNamedValue> parameters = GMExtWire.readList(__arg_buffer, bb -> FacebookNamedValueCodec.read(bb));

        boolean __result = fb_send_custom_event(event_name, value, parameters);
        return __result ? 1.0 : 0.0;
    }

    public double __EXT_NATIVE__fb_send_purchase(ByteBuffer __arg_buffer, double __arg_buffer_length)
    {
        GMExtWire.order(__arg_buffer);

        // field: amount, type: Float64
        double amount = GMExtWire.readF64(__arg_buffer);

        // field: currency, type: String
        String currency = GMExtWire.readString(__arg_buffer);

        // field: parameters, type: struct FacebookNamedValue[]
        java.util.List<FacebookNamedValue> parameters = GMExtWire.readList(__arg_buffer, bb -> FacebookNamedValueCodec.read(bb));

        boolean __result = fb_send_purchase(amount, currency, parameters);
        return __result ? 1.0 : 0.0;
    }

    public double __EXT_NATIVE__fb_flush_events()
    {
        fb_flush_events();
        return 0;
    }

    public double __EXT_NATIVE__fb_set_event_user_id(String user_id)
    {
        fb_set_event_user_id(user_id);
        return 0;
    }

    public String __EXT_NATIVE__fb_get_event_user_id()
    {
        String __result = fb_get_event_user_id();
        return __result;
    }

    public double __EXT_NATIVE__fb_clear_event_user_id()
    {
        fb_clear_event_user_id();
        return 0;
    }

}