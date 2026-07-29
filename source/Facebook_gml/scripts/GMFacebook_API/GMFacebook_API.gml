// ##### extgen :: Auto-generated file do not edit!! #####

// #####################################################################
// # Macros
// #####################################################################

// #####################################################################
// # Enums
// #####################################################################

enum FacebookLoginStatus
{
    Idle = 0,
    Processing = 1,
    Failed = 2,
    Authorised = 3
}

enum FacebookOperationStatus
{
    Success = 0,
    Cancelled = 1,
    Error = 2
}

enum FacebookHttpMethod
{
    Get = 0,
    Post = 1,
    Delete = 2
}

enum FacebookAppEvent
{
    AchievedLevel = 101,
    AddedPaymentInfo = 102,
    AddedToCart = 103,
    AddedToWishlist = 104,
    CompletedRegistration = 105,
    CompletedTutorial = 106,
    InitiatedCheckout = 107,
    Rated = 109,
    Searched = 110,
    SpentCredits = 111,
    UnlockedAchievement = 112,
    ViewedContent = 113
}

enum FacebookAppEventParameter
{
    ContentId = 1003,
    ContentType = 1004,
    Currency = 1005,
    Description = 1006,
    Level = 1007,
    MaxRatingValue = 1008,
    NumItems = 1009,
    PaymentInfoAvailable = 1010,
    RegistrationMethod = 1011,
    SearchString = 1012,
    Success = 1013
}

// #####################################################################
// # Constructors
// #####################################################################

/**
 * @returns {Struct.FacebookEventParameterValue}
 */
function FacebookEventParameterValue() constructor
{
    /**
     * Internally generated hash for quick validation
     * @ignore
     */
    static __uid = 2509545595;

    self.key = undefined;
    self.string_value = undefined;
    self.number_value = undefined;
    self.use_number = undefined;

}

/**
 * @returns {Struct.FacebookNamedValue}
 */
function FacebookNamedValue() constructor
{
    /**
     * Internally generated hash for quick validation
     * @ignore
     */
    static __uid = 778246291;

    self.name = undefined;
    self.string_value = undefined;
    self.number_value = undefined;
    self.use_number = undefined;

}

/**
 * @returns {Struct.FacebookCallbackResult}
 */
function FacebookCallbackResult() constructor
{
    /**
     * Internally generated hash for quick validation
     * @ignore
     */
    static __uid = 4206203691;

    self.success = undefined;
    self.status = undefined;
    self.request_id = undefined;
    self.error_message = undefined;
    self.access_token = undefined;
    self.user_id = undefined;
    self.response_text = undefined;
    self.post_id = undefined;
    self.granted_permissions = undefined;
    self.declined_permissions = undefined;

}

// #####################################################################
// # Codecs
// #####################################################################

/**
 * @func __FacebookEventParameterValue_encode(_inst, _buffer, _offset, _where)
 * @param {Struct.FacebookEventParameterValue} _inst
 * @param {Id.Buffer} _buffer
 * @param {Real} _offset
 * @param {String} _where
 * @ignore
 */
function __FacebookEventParameterValue_encode(_inst, _buffer, _offset, _where = _GMFUNCTION_)
{
    buffer_seek(_buffer, buffer_seek_start, _offset);
    with (_inst)
    {
        // field: key, type: Int32
        if (!is_numeric(self.key)) show_error($"{_where} :: self.key expected number", true);
        buffer_write(_buffer, buffer_s32, self.key);

        // field: string_value, type: String
        if (!is_string(self.string_value)) show_error($"{_where} :: self.string_value expected string", true);
        buffer_write(_buffer, buffer_u32, string_byte_length(self.string_value));
        buffer_write(_buffer, buffer_string, self.string_value);

        // field: number_value, type: Float64
        if (!is_numeric(self.number_value)) show_error($"{_where} :: self.number_value expected number", true);
        buffer_write(_buffer, buffer_f64, self.number_value);

        // field: use_number, type: Bool
        if (!is_bool(self.use_number)) show_error($"{_where} :: self.use_number expected bool", true);
        buffer_write(_buffer, buffer_bool, self.use_number);

    }
}

/**
 * @func __FacebookEventParameterValue_decode(_buffer, _offset)
 * @param {Id.Buffer} _buffer
 * @param {Real} _offset
 * @returns {Struct.FacebookEventParameterValue}
 * @ignore
 */
function __FacebookEventParameterValue_decode(_buffer, _offset)
{
    buffer_seek(_buffer, buffer_seek_start, _offset);

    _inst = new FacebookEventParameterValue();
    with (_inst)
    {
        // field: key, type: Int32
        self.key = buffer_read(_buffer, buffer_s32);

        // field: string_value, type: String
        buffer_read(_buffer, buffer_u32);
        self.string_value = buffer_read(_buffer, buffer_string);

        // field: number_value, type: Float64
        self.number_value = buffer_read(_buffer, buffer_f64);

        // field: use_number, type: Bool
        self.use_number = buffer_read(_buffer, buffer_bool);

    }

    return _inst;
}

/**
 * @func __FacebookNamedValue_encode(_inst, _buffer, _offset, _where)
 * @param {Struct.FacebookNamedValue} _inst
 * @param {Id.Buffer} _buffer
 * @param {Real} _offset
 * @param {String} _where
 * @ignore
 */
function __FacebookNamedValue_encode(_inst, _buffer, _offset, _where = _GMFUNCTION_)
{
    buffer_seek(_buffer, buffer_seek_start, _offset);
    with (_inst)
    {
        // field: name, type: String
        if (!is_string(self.name)) show_error($"{_where} :: self.name expected string", true);
        buffer_write(_buffer, buffer_u32, string_byte_length(self.name));
        buffer_write(_buffer, buffer_string, self.name);

        // field: string_value, type: String
        if (!is_string(self.string_value)) show_error($"{_where} :: self.string_value expected string", true);
        buffer_write(_buffer, buffer_u32, string_byte_length(self.string_value));
        buffer_write(_buffer, buffer_string, self.string_value);

        // field: number_value, type: Float64
        if (!is_numeric(self.number_value)) show_error($"{_where} :: self.number_value expected number", true);
        buffer_write(_buffer, buffer_f64, self.number_value);

        // field: use_number, type: Bool
        if (!is_bool(self.use_number)) show_error($"{_where} :: self.use_number expected bool", true);
        buffer_write(_buffer, buffer_bool, self.use_number);

    }
}

/**
 * @func __FacebookNamedValue_decode(_buffer, _offset)
 * @param {Id.Buffer} _buffer
 * @param {Real} _offset
 * @returns {Struct.FacebookNamedValue}
 * @ignore
 */
function __FacebookNamedValue_decode(_buffer, _offset)
{
    buffer_seek(_buffer, buffer_seek_start, _offset);

    _inst = new FacebookNamedValue();
    with (_inst)
    {
        // field: name, type: String
        buffer_read(_buffer, buffer_u32);
        self.name = buffer_read(_buffer, buffer_string);

        // field: string_value, type: String
        buffer_read(_buffer, buffer_u32);
        self.string_value = buffer_read(_buffer, buffer_string);

        // field: number_value, type: Float64
        self.number_value = buffer_read(_buffer, buffer_f64);

        // field: use_number, type: Bool
        self.use_number = buffer_read(_buffer, buffer_bool);

    }

    return _inst;
}

/**
 * @func __FacebookCallbackResult_encode(_inst, _buffer, _offset, _where)
 * @param {Struct.FacebookCallbackResult} _inst
 * @param {Id.Buffer} _buffer
 * @param {Real} _offset
 * @param {String} _where
 * @ignore
 */
function __FacebookCallbackResult_encode(_inst, _buffer, _offset, _where = _GMFUNCTION_)
{
    buffer_seek(_buffer, buffer_seek_start, _offset);
    with (_inst)
    {
        // field: success, type: Bool
        if (!is_bool(self.success)) show_error($"{_where} :: self.success expected bool", true);
        buffer_write(_buffer, buffer_bool, self.success);

        // field: status, type: Int32
        if (!is_numeric(self.status)) show_error($"{_where} :: self.status expected number", true);
        buffer_write(_buffer, buffer_s32, self.status);

        // field: request_id, type: Int32
        if (!is_numeric(self.request_id)) show_error($"{_where} :: self.request_id expected number", true);
        buffer_write(_buffer, buffer_s32, self.request_id);

        // field: error_message, type: String
        if (!is_string(self.error_message)) show_error($"{_where} :: self.error_message expected string", true);
        buffer_write(_buffer, buffer_u32, string_byte_length(self.error_message));
        buffer_write(_buffer, buffer_string, self.error_message);

        // field: access_token, type: String
        if (!is_string(self.access_token)) show_error($"{_where} :: self.access_token expected string", true);
        buffer_write(_buffer, buffer_u32, string_byte_length(self.access_token));
        buffer_write(_buffer, buffer_string, self.access_token);

        // field: user_id, type: String
        if (!is_string(self.user_id)) show_error($"{_where} :: self.user_id expected string", true);
        buffer_write(_buffer, buffer_u32, string_byte_length(self.user_id));
        buffer_write(_buffer, buffer_string, self.user_id);

        // field: response_text, type: String
        if (!is_string(self.response_text)) show_error($"{_where} :: self.response_text expected string", true);
        buffer_write(_buffer, buffer_u32, string_byte_length(self.response_text));
        buffer_write(_buffer, buffer_string, self.response_text);

        // field: post_id, type: String
        if (!is_string(self.post_id)) show_error($"{_where} :: self.post_id expected string", true);
        buffer_write(_buffer, buffer_u32, string_byte_length(self.post_id));
        buffer_write(_buffer, buffer_string, self.post_id);

        // field: granted_permissions, type: String[]
        if (!is_array(self.granted_permissions)) show_error($"{_where} :: self.granted_permissions expected array", true);
        var __length__ = array_length(self.granted_permissions);
        buffer_write(_buffer, buffer_u32, __length__);
        for (var _i = 0; _i < __length__; ++_i)
        {
            if (!is_string(self.granted_permissions[_i])) show_error($"{_where} :: self.granted_permissions[_i] expected string", true);
            buffer_write(_buffer, buffer_u32, string_byte_length(self.granted_permissions[_i]));
            buffer_write(_buffer, buffer_string, self.granted_permissions[_i]);
        }

        // field: declined_permissions, type: String[]
        if (!is_array(self.declined_permissions)) show_error($"{_where} :: self.declined_permissions expected array", true);
        var __length__ = array_length(self.declined_permissions);
        buffer_write(_buffer, buffer_u32, __length__);
        for (var _i = 0; _i < __length__; ++_i)
        {
            if (!is_string(self.declined_permissions[_i])) show_error($"{_where} :: self.declined_permissions[_i] expected string", true);
            buffer_write(_buffer, buffer_u32, string_byte_length(self.declined_permissions[_i]));
            buffer_write(_buffer, buffer_string, self.declined_permissions[_i]);
        }

    }
}

/**
 * @func __FacebookCallbackResult_decode(_buffer, _offset)
 * @param {Id.Buffer} _buffer
 * @param {Real} _offset
 * @returns {Struct.FacebookCallbackResult}
 * @ignore
 */
function __FacebookCallbackResult_decode(_buffer, _offset)
{
    buffer_seek(_buffer, buffer_seek_start, _offset);

    _inst = new FacebookCallbackResult();
    with (_inst)
    {
        // field: success, type: Bool
        self.success = buffer_read(_buffer, buffer_bool);

        // field: status, type: Int32
        self.status = buffer_read(_buffer, buffer_s32);

        // field: request_id, type: Int32
        self.request_id = buffer_read(_buffer, buffer_s32);

        // field: error_message, type: String
        buffer_read(_buffer, buffer_u32);
        self.error_message = buffer_read(_buffer, buffer_string);

        // field: access_token, type: String
        buffer_read(_buffer, buffer_u32);
        self.access_token = buffer_read(_buffer, buffer_string);

        // field: user_id, type: String
        buffer_read(_buffer, buffer_u32);
        self.user_id = buffer_read(_buffer, buffer_string);

        // field: response_text, type: String
        buffer_read(_buffer, buffer_u32);
        self.response_text = buffer_read(_buffer, buffer_string);

        // field: post_id, type: String
        buffer_read(_buffer, buffer_u32);
        self.post_id = buffer_read(_buffer, buffer_string);

        // field: granted_permissions, type: String[]
        var __length__ = buffer_read(_buffer, buffer_u32);
        self.granted_permissions = array_create(__length__);
        for (var _i = 0; _i < __length__; ++_i)
        {
            buffer_read(_buffer, buffer_u32);
            self.granted_permissions[_i] = buffer_read(_buffer, buffer_string);
        }

        // field: declined_permissions, type: String[]
        var __length__ = buffer_read(_buffer, buffer_u32);
        self.declined_permissions = array_create(__length__);
        for (var _i = 0; _i < __length__; ++_i)
        {
            buffer_read(_buffer, buffer_u32);
            self.declined_permissions[_i] = buffer_read(_buffer, buffer_string);
        }

    }

    return _inst;
}

// #####################################################################
// # Functions
// #####################################################################

/**
 * @param {Function} _callback
 */
function fb_initialize(_callback)
{
    var __available__ = __GMFacebook_is_available();
    if (!__available__) return;

    var __dispatcher__ = __GMFacebook_get_dispatcher();

    var __args_buffer = __ext_core_get_args_buffer();

    // param: _callback, type: Function
    if (!is_callable(_callback)) show_error($"{_GMFUNCTION_} :: _callback expected callable type", true);
    var _callback_handle = __ext_core_function_register(_callback, __dispatcher__);
    buffer_write(__args_buffer, buffer_u64, _callback_handle);

    var __return_value__ = __fb_initialize(buffer_get_address(__args_buffer), buffer_tell(__args_buffer));

    return __return_value__;
}

// Skipping function fb_ready (no wrapper is required)


/**
 * @returns {Enum.FacebookLoginStatus}
 */
function fb_status()
{
    var __available__ = __GMFacebook_is_available();
    if (!__available__) return;

    var __ret_buffer = __ext_core_get_ret_buffer();

    var __return_value__ = __fb_status(buffer_get_address(__ret_buffer), buffer_get_size(__ret_buffer));

    var __result__ = undefined;
    __result__ = buffer_read(__ret_buffer, buffer_s32);
    return __result__;
}

// Skipping function fb_user_id (no wrapper is required)


// Skipping function fb_access_token (no wrapper is required)


// Skipping function fb_logout (no wrapper is required)


// Skipping function fb_set_auto_log_app_events_enabled (no wrapper is required)


// Skipping function fb_set_advertiser_id_collection_enabled (no wrapper is required)


// Skipping function fb_check_permission (no wrapper is required)


/**
 * @param {Array[String]} _permissions
 * @param {Function} _callback
 */
function fb_login(_permissions, _callback)
{
    var __available__ = __GMFacebook_is_available();
    if (!__available__) return;

    var __dispatcher__ = __GMFacebook_get_dispatcher();

    var __args_buffer = __ext_core_get_args_buffer();

    // param: _permissions, type: String[]
    if (!is_array(_permissions)) show_error($"{_GMFUNCTION_} :: _permissions expected array", true);
    var __length__ = array_length(_permissions);
    buffer_write(__args_buffer, buffer_u32, __length__);
    for (var _i = 0; _i < __length__; ++_i)
    {
        if (!is_string(_permissions[_i])) show_error($"{_GMFUNCTION_} :: _permissions[_i] expected string", true);
        buffer_write(__args_buffer, buffer_u32, string_byte_length(_permissions[_i]));
        buffer_write(__args_buffer, buffer_string, _permissions[_i]);
    }

    // param: _callback, type: Function
    if (!is_callable(_callback)) show_error($"{_GMFUNCTION_} :: _callback expected callable type", true);
    var _callback_handle = __ext_core_function_register(_callback, __dispatcher__);
    buffer_write(__args_buffer, buffer_u64, _callback_handle);

    var __return_value__ = __fb_login(buffer_get_address(__args_buffer), buffer_tell(__args_buffer));

    return __return_value__;
}

/**
 * @param {Array[String]} _permissions
 * @param {Function} _callback
 */
function fb_request_read_permissions(_permissions, _callback)
{
    var __available__ = __GMFacebook_is_available();
    if (!__available__) return;

    var __dispatcher__ = __GMFacebook_get_dispatcher();

    var __args_buffer = __ext_core_get_args_buffer();

    // param: _permissions, type: String[]
    if (!is_array(_permissions)) show_error($"{_GMFUNCTION_} :: _permissions expected array", true);
    var __length__ = array_length(_permissions);
    buffer_write(__args_buffer, buffer_u32, __length__);
    for (var _i = 0; _i < __length__; ++_i)
    {
        if (!is_string(_permissions[_i])) show_error($"{_GMFUNCTION_} :: _permissions[_i] expected string", true);
        buffer_write(__args_buffer, buffer_u32, string_byte_length(_permissions[_i]));
        buffer_write(__args_buffer, buffer_string, _permissions[_i]);
    }

    // param: _callback, type: Function
    if (!is_callable(_callback)) show_error($"{_GMFUNCTION_} :: _callback expected callable type", true);
    var _callback_handle = __ext_core_function_register(_callback, __dispatcher__);
    buffer_write(__args_buffer, buffer_u64, _callback_handle);

    var __return_value__ = __fb_request_read_permissions(buffer_get_address(__args_buffer), buffer_tell(__args_buffer));

    return __return_value__;
}

/**
 * @param {Array[String]} _permissions
 * @param {Function} _callback
 */
function fb_request_publish_permissions(_permissions, _callback)
{
    var __available__ = __GMFacebook_is_available();
    if (!__available__) return;

    var __dispatcher__ = __GMFacebook_get_dispatcher();

    var __args_buffer = __ext_core_get_args_buffer();

    // param: _permissions, type: String[]
    if (!is_array(_permissions)) show_error($"{_GMFUNCTION_} :: _permissions expected array", true);
    var __length__ = array_length(_permissions);
    buffer_write(__args_buffer, buffer_u32, __length__);
    for (var _i = 0; _i < __length__; ++_i)
    {
        if (!is_string(_permissions[_i])) show_error($"{_GMFUNCTION_} :: _permissions[_i] expected string", true);
        buffer_write(__args_buffer, buffer_u32, string_byte_length(_permissions[_i]));
        buffer_write(__args_buffer, buffer_string, _permissions[_i]);
    }

    // param: _callback, type: Function
    if (!is_callable(_callback)) show_error($"{_GMFUNCTION_} :: _callback expected callable type", true);
    var _callback_handle = __ext_core_function_register(_callback, __dispatcher__);
    buffer_write(__args_buffer, buffer_u64, _callback_handle);

    var __return_value__ = __fb_request_publish_permissions(buffer_get_address(__args_buffer), buffer_tell(__args_buffer));

    return __return_value__;
}

/**
 * @param {Function} _callback
 */
function fb_refresh_access_token(_callback)
{
    var __available__ = __GMFacebook_is_available();
    if (!__available__) return;

    var __dispatcher__ = __GMFacebook_get_dispatcher();

    var __args_buffer = __ext_core_get_args_buffer();

    // param: _callback, type: Function
    if (!is_callable(_callback)) show_error($"{_GMFUNCTION_} :: _callback expected callable type", true);
    var _callback_handle = __ext_core_function_register(_callback, __dispatcher__);
    buffer_write(__args_buffer, buffer_u64, _callback_handle);

    var __return_value__ = __fb_refresh_access_token(buffer_get_address(__args_buffer), buffer_tell(__args_buffer));

    return __return_value__;
}

/**
 * @param {String} _graph_path
 * @param {Array[Enum.FacebookHttpMethod]} _method
 * @param {Array[Struct.FacebookNamedValue]} _parameters
 * @param {Function} _callback
 */
function fb_graph_request(_graph_path, _method, _parameters, _callback)
{
    var __available__ = __GMFacebook_is_available();
    if (!__available__) return;

    var __dispatcher__ = __GMFacebook_get_dispatcher();

    var __args_buffer = __ext_core_get_args_buffer();

    // param: _graph_path, type: String
    if (!is_string(_graph_path)) show_error($"{_GMFUNCTION_} :: _graph_path expected string", true);
    buffer_write(__args_buffer, buffer_u32, string_byte_length(_graph_path));
    buffer_write(__args_buffer, buffer_string, _graph_path);

    // param: _method, type: enum FacebookHttpMethod[]
    if (!is_array(_method)) show_error($"{_GMFUNCTION_} :: _method expected array", true);
    var __length__ = array_length(_method);
    buffer_write(__args_buffer, buffer_u32, __length__);
    for (var _i = 0; _i < __length__; ++_i)
    {

        if (!is_numeric(_method[_i])) show_error($"{_GMFUNCTION_} :: _method[_i] expected number", true);
        buffer_write(__args_buffer, buffer_s32, _method[_i]);
    }

    // param: _parameters, type: struct FacebookNamedValue[]
    if (!is_array(_parameters)) show_error($"{_GMFUNCTION_} :: _parameters expected array", true);
    var __length__ = array_length(_parameters);
    buffer_write(__args_buffer, buffer_u32, __length__);
    for (var _i = 0; _i < __length__; ++_i)
    {
        if (_parameters[_i].__uid != 778246291) show_error($"{_GMFUNCTION_} :: _parameters[_i] expected FacebookNamedValue", true);
        __FacebookNamedValue_encode(_parameters[_i], __args_buffer, buffer_tell(__args_buffer), _GMFUNCTION_);
    }

    // param: _callback, type: Function
    if (!is_callable(_callback)) show_error($"{_GMFUNCTION_} :: _callback expected callable type", true);
    var _callback_handle = __ext_core_function_register(_callback, __dispatcher__);
    buffer_write(__args_buffer, buffer_u64, _callback_handle);

    var __return_value__ = __fb_graph_request(buffer_get_address(__args_buffer), buffer_tell(__args_buffer));

    return __return_value__;
}

/**
 * @param {String} _link_url
 * @param {Function} _callback
 */
function fb_dialog(_link_url, _callback)
{
    var __available__ = __GMFacebook_is_available();
    if (!__available__) return;

    var __dispatcher__ = __GMFacebook_get_dispatcher();

    var __args_buffer = __ext_core_get_args_buffer();

    // param: _link_url, type: String
    if (!is_string(_link_url)) show_error($"{_GMFUNCTION_} :: _link_url expected string", true);
    buffer_write(__args_buffer, buffer_u32, string_byte_length(_link_url));
    buffer_write(__args_buffer, buffer_string, _link_url);

    // param: _callback, type: Function
    if (!is_callable(_callback)) show_error($"{_GMFUNCTION_} :: _callback expected callable type", true);
    var _callback_handle = __ext_core_function_register(_callback, __dispatcher__);
    buffer_write(__args_buffer, buffer_u64, _callback_handle);

    var __return_value__ = __fb_dialog(buffer_get_address(__args_buffer), buffer_tell(__args_buffer));

    return __return_value__;
}

/**
 * @param {Array[Enum.FacebookAppEvent]} _event
 * @param {Real} _value
 * @param {Array[Struct.FacebookEventParameterValue]} _parameters
 * @returns {Bool}
 */
function fb_send_event(_event, _value, _parameters)
{
    var __available__ = __GMFacebook_is_available();
    if (!__available__) return;

    var __args_buffer = __ext_core_get_args_buffer();

    // param: _event, type: enum FacebookAppEvent[]
    if (!is_array(_event)) show_error($"{_GMFUNCTION_} :: _event expected array", true);
    var __length__ = array_length(_event);
    buffer_write(__args_buffer, buffer_u32, __length__);
    for (var _i = 0; _i < __length__; ++_i)
    {

        if (!is_numeric(_event[_i])) show_error($"{_GMFUNCTION_} :: _event[_i] expected number", true);
        buffer_write(__args_buffer, buffer_s32, _event[_i]);
    }

    // param: _value, type: Float64
    if (!is_numeric(_value)) show_error($"{_GMFUNCTION_} :: _value expected number", true);
    buffer_write(__args_buffer, buffer_f64, _value);

    // param: _parameters, type: struct FacebookEventParameterValue[]
    if (!is_array(_parameters)) show_error($"{_GMFUNCTION_} :: _parameters expected array", true);
    var __length__ = array_length(_parameters);
    buffer_write(__args_buffer, buffer_u32, __length__);
    for (var _i = 0; _i < __length__; ++_i)
    {
        if (_parameters[_i].__uid != 2509545595) show_error($"{_GMFUNCTION_} :: _parameters[_i] expected FacebookEventParameterValue", true);
        __FacebookEventParameterValue_encode(_parameters[_i], __args_buffer, buffer_tell(__args_buffer), _GMFUNCTION_);
    }

    var __return_value__ = __fb_send_event(buffer_get_address(__args_buffer), buffer_tell(__args_buffer));

    return __return_value__;
}

/**
 * @param {String} _event_name
 * @param {Real} _value
 * @param {Array[Struct.FacebookNamedValue]} _parameters
 * @returns {Bool}
 */
function fb_send_custom_event(_event_name, _value, _parameters)
{
    var __available__ = __GMFacebook_is_available();
    if (!__available__) return;

    var __args_buffer = __ext_core_get_args_buffer();

    // param: _event_name, type: String
    if (!is_string(_event_name)) show_error($"{_GMFUNCTION_} :: _event_name expected string", true);
    buffer_write(__args_buffer, buffer_u32, string_byte_length(_event_name));
    buffer_write(__args_buffer, buffer_string, _event_name);

    // param: _value, type: Float64
    if (!is_numeric(_value)) show_error($"{_GMFUNCTION_} :: _value expected number", true);
    buffer_write(__args_buffer, buffer_f64, _value);

    // param: _parameters, type: struct FacebookNamedValue[]
    if (!is_array(_parameters)) show_error($"{_GMFUNCTION_} :: _parameters expected array", true);
    var __length__ = array_length(_parameters);
    buffer_write(__args_buffer, buffer_u32, __length__);
    for (var _i = 0; _i < __length__; ++_i)
    {
        if (_parameters[_i].__uid != 778246291) show_error($"{_GMFUNCTION_} :: _parameters[_i] expected FacebookNamedValue", true);
        __FacebookNamedValue_encode(_parameters[_i], __args_buffer, buffer_tell(__args_buffer), _GMFUNCTION_);
    }

    var __return_value__ = __fb_send_custom_event(buffer_get_address(__args_buffer), buffer_tell(__args_buffer));

    return __return_value__;
}

/// @ignore
function __GMFacebook_get_decoders()
{
    static __decoders__ = [
        __FacebookEventParameterValue_decode,
        __FacebookNamedValue_decode,
        __FacebookCallbackResult_decode
    ];
    return __decoders__;
}
/// @ignore
function __GMFacebook_get_dispatcher()
{
    static __dispatcher__ = new __GMNativeFunctionDispatcher(__GMFacebook_invocation_handler, __GMFacebook_get_decoders());
    return __dispatcher__;
}
/// @ignore
function __GMFacebook_is_available()
{
    static __available__ = extension_exists("GMFacebook");
    return __available__;
}
