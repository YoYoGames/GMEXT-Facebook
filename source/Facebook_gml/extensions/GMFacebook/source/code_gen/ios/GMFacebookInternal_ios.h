// ##### extgen :: Auto-generated file do not edit!! #####

#pragma once
#import <Foundation/Foundation.h>

@interface GMFacebookInternal : NSObject
- (double)__EXT_NATIVE__fb_initialize:(char*)__arg_buffer arg1:(double)__arg_buffer_length;
- (double)__EXT_NATIVE__fb_ready;
- (double)__EXT_NATIVE__fb_status:(char*)__ret_buffer arg1:(double)__ret_buffer_length;
- (char*)__EXT_NATIVE__fb_user_id;
- (char*)__EXT_NATIVE__fb_access_token;
- (double)__EXT_NATIVE__fb_logout;
- (double)__EXT_NATIVE__fb_set_auto_log_app_events_enabled:(double)enabled;
- (double)__EXT_NATIVE__fb_set_advertiser_id_collection_enabled:(double)enabled;
- (double)__EXT_NATIVE__fb_check_permission:(char*)permission;
- (double)__EXT_NATIVE__fb_login:(char*)__arg_buffer arg1:(double)__arg_buffer_length;
- (double)__EXT_NATIVE__fb_request_read_permissions:(char*)__arg_buffer arg1:(double)__arg_buffer_length;
- (double)__EXT_NATIVE__fb_request_publish_permissions:(char*)__arg_buffer arg1:(double)__arg_buffer_length;
- (double)__EXT_NATIVE__fb_refresh_access_token:(char*)__arg_buffer arg1:(double)__arg_buffer_length;
- (double)__EXT_NATIVE__fb_graph_request:(char*)__arg_buffer arg1:(double)__arg_buffer_length;
- (double)__EXT_NATIVE__fb_dialog:(char*)__arg_buffer arg1:(double)__arg_buffer_length;
- (double)__EXT_NATIVE__fb_send_event:(char*)__arg_buffer arg1:(double)__arg_buffer_length;
- (double)__EXT_NATIVE__fb_send_custom_event:(char*)__arg_buffer arg1:(double)__arg_buffer_length;
- (double)__EXT_NATIVE__GMFacebook_invocation_handler:(char*)__ret_buffer arg1:(double)__ret_buffer_length;
@end


