// ##### extgen :: Auto-generated file do not edit!! #####

#pragma once
#include "core/GMExtUtils.h"

// Internal function used for fetching dispatched function calls to GML
GMEXPORT double __EXT_NATIVE__GMFacebook_invocation_handler(char* __ret_buffer, double __ret_buffer_length);

GMEXPORT double __EXT_NATIVE__fb_initialize(char* __arg_buffer, double __arg_buffer_length);
GMEXPORT double __EXT_NATIVE__fb_ready();
GMEXPORT double __EXT_NATIVE__fb_status(char* __ret_buffer, double __ret_buffer_length);
GMEXPORT double __EXT_NATIVE__fb_is_logged_in();
GMEXPORT char* __EXT_NATIVE__fb_user_id();
GMEXPORT char* __EXT_NATIVE__fb_access_token();
GMEXPORT double __EXT_NATIVE__fb_logout();
GMEXPORT double __EXT_NATIVE__fb_set_auto_log_app_events_enabled(double enabled);
GMEXPORT double __EXT_NATIVE__fb_auto_log_app_events_enabled();
GMEXPORT double __EXT_NATIVE__fb_set_advertiser_id_collection_enabled(double enabled);
GMEXPORT double __EXT_NATIVE__fb_advertiser_id_collection_enabled();
GMEXPORT double __EXT_NATIVE__fb_set_event_data_usage_limited(double enabled);
GMEXPORT double __EXT_NATIVE__fb_event_data_usage_limited();
GMEXPORT double __EXT_NATIVE__fb_set_data_processing_options(char* __arg_buffer, double __arg_buffer_length);
GMEXPORT double __EXT_NATIVE__fb_check_permission(char* permission);
GMEXPORT double __EXT_NATIVE__fb_login(char* __arg_buffer, double __arg_buffer_length);
GMEXPORT double __EXT_NATIVE__fb_request_read_permissions(char* __arg_buffer, double __arg_buffer_length);
GMEXPORT double __EXT_NATIVE__fb_request_publish_permissions(char* __arg_buffer, double __arg_buffer_length);
GMEXPORT double __EXT_NATIVE__fb_refresh_access_token(char* __arg_buffer, double __arg_buffer_length);
GMEXPORT double __EXT_NATIVE__fb_graph_request(char* __arg_buffer, double __arg_buffer_length);
GMEXPORT double __EXT_NATIVE__fb_dialog(char* __arg_buffer, double __arg_buffer_length);
GMEXPORT double __EXT_NATIVE__fb_send_event(char* __arg_buffer, double __arg_buffer_length);
GMEXPORT double __EXT_NATIVE__fb_send_custom_event(char* __arg_buffer, double __arg_buffer_length);
GMEXPORT double __EXT_NATIVE__fb_send_purchase(char* __arg_buffer, double __arg_buffer_length);
GMEXPORT double __EXT_NATIVE__fb_flush_events();
GMEXPORT double __EXT_NATIVE__fb_set_event_user_id(char* user_id);
GMEXPORT char* __EXT_NATIVE__fb_get_event_user_id();
GMEXPORT double __EXT_NATIVE__fb_clear_event_user_id();

