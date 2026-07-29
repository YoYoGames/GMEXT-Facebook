// ##### extgen :: Auto-generated file do not edit!! #####

#include "GMFacebookInternal_native.h"
#include "GMFacebookInternal_exports.h"

using namespace gm_structs;
using namespace gm::wire::codec;

static gm::runtime::DispatchQueue __dispatch_queue;

// Internal function used for fetching dispatched function calls to GML
GMEXPORT double __EXT_NATIVE__GMFacebook_invocation_handler(char* __ret_buffer, double __ret_buffer_length)
{
    gm::byteio::BufferWriter __bw{ __ret_buffer, static_cast<size_t>(__ret_buffer_length) };
    return __dispatch_queue.fetch(__bw);
}

GMEXPORT double __EXT_NATIVE__fb_initialize(char* __arg_buffer, double __arg_buffer_length)
{
    gm::byteio::BufferReader __br{__arg_buffer, static_cast<size_t>(__arg_buffer_length)};

    // field: callback, type: Function
    gm::wire::GMFunction callback = gm::wire::codec::readFunction(__br, &__dispatch_queue);

    fb_initialize(callback);
    return 0;
}

GMEXPORT double __EXT_NATIVE__fb_ready()
{
    auto&& __result = fb_ready();
    return static_cast<double>(__result);
}

GMEXPORT double __EXT_NATIVE__fb_status(char* __ret_buffer, double __ret_buffer_length)
{
    auto&& __result = fb_status();
    gm::byteio::BufferWriter __bw{__ret_buffer, static_cast<size_t>(__ret_buffer_length)};

    // return: __result, type: enum FacebookLoginStatus
    gm::wire::codec::writeValue(__bw, __result);
    return 0;
}

GMEXPORT double __EXT_NATIVE__fb_is_logged_in()
{
    auto&& __result = fb_is_logged_in();
    return static_cast<double>(__result);
}

GMEXPORT char* __EXT_NATIVE__fb_user_id()
{
    static std::string __result;
    __result = fb_user_id();
    return (char*)__result.c_str();
}

GMEXPORT char* __EXT_NATIVE__fb_access_token()
{
    static std::string __result;
    __result = fb_access_token();
    return (char*)__result.c_str();
}

GMEXPORT double __EXT_NATIVE__fb_logout()
{
    fb_logout();
    return 0;
}

GMEXPORT double __EXT_NATIVE__fb_set_auto_log_app_events_enabled(double enabled)
{
    fb_set_auto_log_app_events_enabled(static_cast<bool>(enabled));
    return 0;
}

GMEXPORT double __EXT_NATIVE__fb_auto_log_app_events_enabled()
{
    auto&& __result = fb_auto_log_app_events_enabled();
    return static_cast<double>(__result);
}

GMEXPORT double __EXT_NATIVE__fb_set_advertiser_id_collection_enabled(double enabled)
{
    fb_set_advertiser_id_collection_enabled(static_cast<bool>(enabled));
    return 0;
}

GMEXPORT double __EXT_NATIVE__fb_advertiser_id_collection_enabled()
{
    auto&& __result = fb_advertiser_id_collection_enabled();
    return static_cast<double>(__result);
}

GMEXPORT double __EXT_NATIVE__fb_set_event_data_usage_limited(double enabled)
{
    fb_set_event_data_usage_limited(static_cast<bool>(enabled));
    return 0;
}

GMEXPORT double __EXT_NATIVE__fb_event_data_usage_limited()
{
    auto&& __result = fb_event_data_usage_limited();
    return static_cast<double>(__result);
}

GMEXPORT double __EXT_NATIVE__fb_set_data_processing_options(char* __arg_buffer, double __arg_buffer_length)
{
    gm::byteio::BufferReader __br{__arg_buffer, static_cast<size_t>(__arg_buffer_length)};

    // field: options, type: String[]
    std::vector<std::string_view> options = gm::wire::codec::readVector<std::string_view>(__br);

    // field: country, type: Int32
    std::int32_t country = gm::wire::codec::readValue<std::int32_t>(__br);

    // field: state, type: Int32
    std::int32_t state = gm::wire::codec::readValue<std::int32_t>(__br);

    fb_set_data_processing_options(options, country, state);
    return 0;
}

GMEXPORT double __EXT_NATIVE__fb_check_permission(char* permission)
{
    auto&& __result = fb_check_permission(permission);
    return static_cast<double>(__result);
}

GMEXPORT double __EXT_NATIVE__fb_login(char* __arg_buffer, double __arg_buffer_length)
{
    gm::byteio::BufferReader __br{__arg_buffer, static_cast<size_t>(__arg_buffer_length)};

    // field: permissions, type: String[]
    std::vector<std::string_view> permissions = gm::wire::codec::readVector<std::string_view>(__br);

    // field: callback, type: Function
    gm::wire::GMFunction callback = gm::wire::codec::readFunction(__br, &__dispatch_queue);

    fb_login(permissions, callback);
    return 0;
}

GMEXPORT double __EXT_NATIVE__fb_request_read_permissions(char* __arg_buffer, double __arg_buffer_length)
{
    gm::byteio::BufferReader __br{__arg_buffer, static_cast<size_t>(__arg_buffer_length)};

    // field: permissions, type: String[]
    std::vector<std::string_view> permissions = gm::wire::codec::readVector<std::string_view>(__br);

    // field: callback, type: Function
    gm::wire::GMFunction callback = gm::wire::codec::readFunction(__br, &__dispatch_queue);

    fb_request_read_permissions(permissions, callback);
    return 0;
}

GMEXPORT double __EXT_NATIVE__fb_request_publish_permissions(char* __arg_buffer, double __arg_buffer_length)
{
    gm::byteio::BufferReader __br{__arg_buffer, static_cast<size_t>(__arg_buffer_length)};

    // field: permissions, type: String[]
    std::vector<std::string_view> permissions = gm::wire::codec::readVector<std::string_view>(__br);

    // field: callback, type: Function
    gm::wire::GMFunction callback = gm::wire::codec::readFunction(__br, &__dispatch_queue);

    fb_request_publish_permissions(permissions, callback);
    return 0;
}

GMEXPORT double __EXT_NATIVE__fb_refresh_access_token(char* __arg_buffer, double __arg_buffer_length)
{
    gm::byteio::BufferReader __br{__arg_buffer, static_cast<size_t>(__arg_buffer_length)};

    // field: callback, type: Function
    gm::wire::GMFunction callback = gm::wire::codec::readFunction(__br, &__dispatch_queue);

    fb_refresh_access_token(callback);
    return 0;
}

GMEXPORT double __EXT_NATIVE__fb_graph_request(char* __arg_buffer, double __arg_buffer_length)
{
    gm::byteio::BufferReader __br{__arg_buffer, static_cast<size_t>(__arg_buffer_length)};

    // field: graph_path, type: String
    std::string_view graph_path = gm::wire::codec::readValue<std::string_view>(__br);

    // field: method, type: enum FacebookHttpMethod
    gm_enums::FacebookHttpMethod method = gm::wire::codec::readValue<gm_enums::FacebookHttpMethod>(__br);

    // field: parameters, type: struct FacebookNamedValue[]
    std::vector<gm_structs::FacebookNamedValue> parameters = gm::wire::codec::readVector<gm_structs::FacebookNamedValue>(__br);

    // field: callback, type: Function
    gm::wire::GMFunction callback = gm::wire::codec::readFunction(__br, &__dispatch_queue);

    fb_graph_request(graph_path, method, parameters, callback);
    return 0;
}

GMEXPORT double __EXT_NATIVE__fb_dialog(char* __arg_buffer, double __arg_buffer_length)
{
    gm::byteio::BufferReader __br{__arg_buffer, static_cast<size_t>(__arg_buffer_length)};

    // field: link_url, type: String
    std::string_view link_url = gm::wire::codec::readValue<std::string_view>(__br);

    // field: callback, type: Function
    gm::wire::GMFunction callback = gm::wire::codec::readFunction(__br, &__dispatch_queue);

    fb_dialog(link_url, callback);
    return 0;
}

GMEXPORT double __EXT_NATIVE__fb_send_event(char* __arg_buffer, double __arg_buffer_length)
{
    gm::byteio::BufferReader __br{__arg_buffer, static_cast<size_t>(__arg_buffer_length)};

    // field: event, type: enum FacebookAppEvent
    gm_enums::FacebookAppEvent event = gm::wire::codec::readValue<gm_enums::FacebookAppEvent>(__br);

    // field: value, type: Float64
    double value = gm::wire::codec::readValue<double>(__br);

    // field: parameters, type: struct FacebookEventParameterValue[]
    std::vector<gm_structs::FacebookEventParameterValue> parameters = gm::wire::codec::readVector<gm_structs::FacebookEventParameterValue>(__br);

    auto&& __result = fb_send_event(event, value, parameters);
    return static_cast<double>(__result);
}

GMEXPORT double __EXT_NATIVE__fb_send_custom_event(char* __arg_buffer, double __arg_buffer_length)
{
    gm::byteio::BufferReader __br{__arg_buffer, static_cast<size_t>(__arg_buffer_length)};

    // field: event_name, type: String
    std::string_view event_name = gm::wire::codec::readValue<std::string_view>(__br);

    // field: value, type: Float64
    double value = gm::wire::codec::readValue<double>(__br);

    // field: parameters, type: struct FacebookNamedValue[]
    std::vector<gm_structs::FacebookNamedValue> parameters = gm::wire::codec::readVector<gm_structs::FacebookNamedValue>(__br);

    auto&& __result = fb_send_custom_event(event_name, value, parameters);
    return static_cast<double>(__result);
}

GMEXPORT double __EXT_NATIVE__fb_send_purchase(char* __arg_buffer, double __arg_buffer_length)
{
    gm::byteio::BufferReader __br{__arg_buffer, static_cast<size_t>(__arg_buffer_length)};

    // field: amount, type: Float64
    double amount = gm::wire::codec::readValue<double>(__br);

    // field: currency, type: String
    std::string_view currency = gm::wire::codec::readValue<std::string_view>(__br);

    // field: parameters, type: struct FacebookNamedValue[]
    std::vector<gm_structs::FacebookNamedValue> parameters = gm::wire::codec::readVector<gm_structs::FacebookNamedValue>(__br);

    auto&& __result = fb_send_purchase(amount, currency, parameters);
    return static_cast<double>(__result);
}

GMEXPORT double __EXT_NATIVE__fb_flush_events()
{
    fb_flush_events();
    return 0;
}

GMEXPORT double __EXT_NATIVE__fb_set_event_user_id(char* user_id)
{
    fb_set_event_user_id(user_id);
    return 0;
}

GMEXPORT char* __EXT_NATIVE__fb_get_event_user_id()
{
    static std::string __result;
    __result = fb_get_event_user_id();
    return (char*)__result.c_str();
}

GMEXPORT double __EXT_NATIVE__fb_clear_event_user_id()
{
    fb_clear_event_user_id();
    return 0;
}

