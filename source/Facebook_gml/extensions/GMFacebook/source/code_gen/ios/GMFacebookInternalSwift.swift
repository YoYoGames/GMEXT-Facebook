import Foundation
import os.log
import CxxStdlib

open class GMFacebookInternalSwift
{
    internal var __dispatch_queue: GMDispatchQueue = GMDispatchQueue()

    public init()
    {
    }

    open func fb_initialize(callback: GMFunction)
    {
        // default stub for fb_initialize
    }

    open func fb_ready() -> Bool
    {
        // default stub for fb_ready
        return false
    }

    open func fb_status() -> FacebookLoginStatus
    {
        // default stub for fb_status
        return FacebookLoginStatus(rawValue: 0)!
    }

    open func fb_is_logged_in() -> Bool
    {
        // default stub for fb_is_logged_in
        return false
    }

    open func fb_user_id() -> String
    {
        // default stub for fb_user_id
        return ""
    }

    open func fb_access_token() -> String
    {
        // default stub for fb_access_token
        return ""
    }

    open func fb_logout()
    {
        // default stub for fb_logout
    }

    open func fb_set_auto_log_app_events_enabled(enabled: Bool)
    {
        // default stub for fb_set_auto_log_app_events_enabled
    }

    open func fb_auto_log_app_events_enabled() -> Bool
    {
        // default stub for fb_auto_log_app_events_enabled
        return false
    }

    open func fb_set_advertiser_id_collection_enabled(enabled: Bool)
    {
        // default stub for fb_set_advertiser_id_collection_enabled
    }

    open func fb_advertiser_id_collection_enabled() -> Bool
    {
        // default stub for fb_advertiser_id_collection_enabled
        return false
    }

    open func fb_set_event_data_usage_limited(enabled: Bool)
    {
        // default stub for fb_set_event_data_usage_limited
    }

    open func fb_event_data_usage_limited() -> Bool
    {
        // default stub for fb_event_data_usage_limited
        return false
    }

    open func fb_set_data_processing_options(options: [String], country: Int32, state: Int32)
    {
        // default stub for fb_set_data_processing_options
    }

    open func fb_check_permission(permission: String) -> Bool
    {
        // default stub for fb_check_permission
        return false
    }

    open func fb_login(permissions: [String], callback: GMFunction)
    {
        // default stub for fb_login
    }

    open func fb_request_read_permissions(permissions: [String], callback: GMFunction)
    {
        // default stub for fb_request_read_permissions
    }

    open func fb_request_publish_permissions(permissions: [String], callback: GMFunction)
    {
        // default stub for fb_request_publish_permissions
    }

    open func fb_refresh_access_token(callback: GMFunction)
    {
        // default stub for fb_refresh_access_token
    }

    open func fb_graph_request(graph_path: String, method: FacebookHttpMethod, parameters: [FacebookNamedValue], callback: GMFunction)
    {
        // default stub for fb_graph_request
    }

    open func fb_dialog(link_url: String, callback: GMFunction)
    {
        // default stub for fb_dialog
    }

    open func fb_send_event(event: FacebookAppEvent, value: Double, parameters: [FacebookEventParameterValue])
    {
        // default stub for fb_send_event
    }

    open func fb_send_custom_event(event_name: String, value: Double, parameters: [FacebookNamedValue])
    {
        // default stub for fb_send_custom_event
    }

    open func fb_send_purchase(amount: Double, currency: String, parameters: [FacebookNamedValue])
    {
        // default stub for fb_send_purchase
    }

    open func fb_flush_events()
    {
        // default stub for fb_flush_events
    }

    open func fb_set_event_user_id(user_id: String)
    {
        // default stub for fb_set_event_user_id
    }

    open func fb_get_event_user_id() -> String
    {
        // default stub for fb_get_event_user_id
        return ""
    }

    open func fb_clear_event_user_id()
    {
        // default stub for fb_clear_event_user_id
    }

    public func __EXT_SWIFT__fb_initialize(_ __arg_buffer: UnsafeMutablePointer<CChar>?, arg1 __arg_buffer_length: Double) -> Double
    {
        do
        {
            var __br = BufferReader(base: UnsafeRawPointer(__arg_buffer!), size: Int(__arg_buffer_length))

            // field: callback, type: Function
            let callback: GMFunction = try __br.readGMFunction(__dispatch_queue)

            self.fb_initialize(callback: callback)
            return 0.0
        }
        catch
        {
            os_log("Corrupted buffer when calling 'fb_initialize'", log: .default, type: .error)
            return -1
        }
    }

    public func __EXT_SWIFT__fb_ready() -> Double
    {
        let __result = self.fb_ready()
        return __result ? 1.0 : 0.0
    }

    public func __EXT_SWIFT__fb_status(_ __ret_buffer: UnsafeMutablePointer<CChar>?, arg1 __ret_buffer_length: Double) -> Double
    {
        do
        {
            let __result = self.fb_status()
            var __bw = BufferWriter(base: UnsafeMutableRawPointer(__ret_buffer!), size: Int(__ret_buffer_length))

            // return: __result, type: enum FacebookLoginStatus
            try __bw.writeRaw(__result.rawValue)
            return 0.0
        }
        catch
        {
            os_log("Corrupted buffer when calling 'fb_status'", log: .default, type: .error)
            return -1
        }
    }

    public func __EXT_SWIFT__fb_is_logged_in() -> Double
    {
        let __result = self.fb_is_logged_in()
        return __result ? 1.0 : 0.0
    }

    public func __EXT_SWIFT__fb_user_id() -> String
    {
        let __result = self.fb_user_id()
        return __result
    }

    public func __EXT_SWIFT__fb_access_token() -> String
    {
        let __result = self.fb_access_token()
        return __result
    }

    public func __EXT_SWIFT__fb_logout() -> Double
    {
        self.fb_logout()
        return 0.0
    }

    public func __EXT_SWIFT__fb_set_auto_log_app_events_enabled(_ enabled: Double) -> Double
    {
        self.fb_set_auto_log_app_events_enabled(enabled: enabled != 0)
        return 0.0
    }

    public func __EXT_SWIFT__fb_auto_log_app_events_enabled() -> Double
    {
        let __result = self.fb_auto_log_app_events_enabled()
        return __result ? 1.0 : 0.0
    }

    public func __EXT_SWIFT__fb_set_advertiser_id_collection_enabled(_ enabled: Double) -> Double
    {
        self.fb_set_advertiser_id_collection_enabled(enabled: enabled != 0)
        return 0.0
    }

    public func __EXT_SWIFT__fb_advertiser_id_collection_enabled() -> Double
    {
        let __result = self.fb_advertiser_id_collection_enabled()
        return __result ? 1.0 : 0.0
    }

    public func __EXT_SWIFT__fb_set_event_data_usage_limited(_ enabled: Double) -> Double
    {
        self.fb_set_event_data_usage_limited(enabled: enabled != 0)
        return 0.0
    }

    public func __EXT_SWIFT__fb_event_data_usage_limited() -> Double
    {
        let __result = self.fb_event_data_usage_limited()
        return __result ? 1.0 : 0.0
    }

    public func __EXT_SWIFT__fb_set_data_processing_options(_ __arg_buffer: UnsafeMutablePointer<CChar>?, arg1 __arg_buffer_length: Double) -> Double
    {
        do
        {
            var __br = BufferReader(base: UnsafeRawPointer(__arg_buffer!), size: Int(__arg_buffer_length))

            // field: options, type: String[]
            let options: [String] = try __br.readRaw([String].self)

            // field: country, type: Int32
            let country: Int32 = try __br.readRaw(Int32.self)

            // field: state, type: Int32
            let state: Int32 = try __br.readRaw(Int32.self)

            self.fb_set_data_processing_options(options: options, country: country, state: state)
            return 0.0
        }
        catch
        {
            os_log("Corrupted buffer when calling 'fb_set_data_processing_options'", log: .default, type: .error)
            return -1
        }
    }

    public func __EXT_SWIFT__fb_check_permission(_ permission: String) -> Double
    {
        let __result = self.fb_check_permission(permission: permission)
        return __result ? 1.0 : 0.0
    }

    public func __EXT_SWIFT__fb_login(_ __arg_buffer: UnsafeMutablePointer<CChar>?, arg1 __arg_buffer_length: Double) -> Double
    {
        do
        {
            var __br = BufferReader(base: UnsafeRawPointer(__arg_buffer!), size: Int(__arg_buffer_length))

            // field: permissions, type: String[]
            let permissions: [String] = try __br.readRaw([String].self)

            // field: callback, type: Function
            let callback: GMFunction = try __br.readGMFunction(__dispatch_queue)

            self.fb_login(permissions: permissions, callback: callback)
            return 0.0
        }
        catch
        {
            os_log("Corrupted buffer when calling 'fb_login'", log: .default, type: .error)
            return -1
        }
    }

    public func __EXT_SWIFT__fb_request_read_permissions(_ __arg_buffer: UnsafeMutablePointer<CChar>?, arg1 __arg_buffer_length: Double) -> Double
    {
        do
        {
            var __br = BufferReader(base: UnsafeRawPointer(__arg_buffer!), size: Int(__arg_buffer_length))

            // field: permissions, type: String[]
            let permissions: [String] = try __br.readRaw([String].self)

            // field: callback, type: Function
            let callback: GMFunction = try __br.readGMFunction(__dispatch_queue)

            self.fb_request_read_permissions(permissions: permissions, callback: callback)
            return 0.0
        }
        catch
        {
            os_log("Corrupted buffer when calling 'fb_request_read_permissions'", log: .default, type: .error)
            return -1
        }
    }

    public func __EXT_SWIFT__fb_request_publish_permissions(_ __arg_buffer: UnsafeMutablePointer<CChar>?, arg1 __arg_buffer_length: Double) -> Double
    {
        do
        {
            var __br = BufferReader(base: UnsafeRawPointer(__arg_buffer!), size: Int(__arg_buffer_length))

            // field: permissions, type: String[]
            let permissions: [String] = try __br.readRaw([String].self)

            // field: callback, type: Function
            let callback: GMFunction = try __br.readGMFunction(__dispatch_queue)

            self.fb_request_publish_permissions(permissions: permissions, callback: callback)
            return 0.0
        }
        catch
        {
            os_log("Corrupted buffer when calling 'fb_request_publish_permissions'", log: .default, type: .error)
            return -1
        }
    }

    public func __EXT_SWIFT__fb_refresh_access_token(_ __arg_buffer: UnsafeMutablePointer<CChar>?, arg1 __arg_buffer_length: Double) -> Double
    {
        do
        {
            var __br = BufferReader(base: UnsafeRawPointer(__arg_buffer!), size: Int(__arg_buffer_length))

            // field: callback, type: Function
            let callback: GMFunction = try __br.readGMFunction(__dispatch_queue)

            self.fb_refresh_access_token(callback: callback)
            return 0.0
        }
        catch
        {
            os_log("Corrupted buffer when calling 'fb_refresh_access_token'", log: .default, type: .error)
            return -1
        }
    }

    public func __EXT_SWIFT__fb_graph_request(_ __arg_buffer: UnsafeMutablePointer<CChar>?, arg1 __arg_buffer_length: Double) -> Double
    {
        do
        {
            var __br = BufferReader(base: UnsafeRawPointer(__arg_buffer!), size: Int(__arg_buffer_length))

            // field: graph_path, type: String
            let graph_path: String = try __br.readRaw(String.self)

            // field: method, type: enum FacebookHttpMethod
            let method: FacebookHttpMethod = (FacebookHttpMethod(rawValue: try __br.readRaw(Int32.self))!)

            // field: parameters, type: struct FacebookNamedValue[]
            let parameters: [FacebookNamedValue] = try __br.readRaw([FacebookNamedValue].self)

            // field: callback, type: Function
            let callback: GMFunction = try __br.readGMFunction(__dispatch_queue)

            self.fb_graph_request(graph_path: graph_path, method: method, parameters: parameters, callback: callback)
            return 0.0
        }
        catch
        {
            os_log("Corrupted buffer when calling 'fb_graph_request'", log: .default, type: .error)
            return -1
        }
    }

    public func __EXT_SWIFT__fb_dialog(_ __arg_buffer: UnsafeMutablePointer<CChar>?, arg1 __arg_buffer_length: Double) -> Double
    {
        do
        {
            var __br = BufferReader(base: UnsafeRawPointer(__arg_buffer!), size: Int(__arg_buffer_length))

            // field: link_url, type: String
            let link_url: String = try __br.readRaw(String.self)

            // field: callback, type: Function
            let callback: GMFunction = try __br.readGMFunction(__dispatch_queue)

            self.fb_dialog(link_url: link_url, callback: callback)
            return 0.0
        }
        catch
        {
            os_log("Corrupted buffer when calling 'fb_dialog'", log: .default, type: .error)
            return -1
        }
    }

    public func __EXT_SWIFT__fb_send_event(_ __arg_buffer: UnsafeMutablePointer<CChar>?, arg1 __arg_buffer_length: Double) -> Double
    {
        do
        {
            var __br = BufferReader(base: UnsafeRawPointer(__arg_buffer!), size: Int(__arg_buffer_length))

            // field: event, type: enum FacebookAppEvent
            let event: FacebookAppEvent = (FacebookAppEvent(rawValue: try __br.readRaw(Int32.self))!)

            // field: value, type: Float64
            let value: Double = try __br.readRaw(Double.self)

            // field: parameters, type: struct FacebookEventParameterValue[]
            let parameters: [FacebookEventParameterValue] = try __br.readRaw([FacebookEventParameterValue].self)

            self.fb_send_event(event: event, value: value, parameters: parameters)
            return 0.0
        }
        catch
        {
            os_log("Corrupted buffer when calling 'fb_send_event'", log: .default, type: .error)
            return -1
        }
    }

    public func __EXT_SWIFT__fb_send_custom_event(_ __arg_buffer: UnsafeMutablePointer<CChar>?, arg1 __arg_buffer_length: Double) -> Double
    {
        do
        {
            var __br = BufferReader(base: UnsafeRawPointer(__arg_buffer!), size: Int(__arg_buffer_length))

            // field: event_name, type: String
            let event_name: String = try __br.readRaw(String.self)

            // field: value, type: Float64
            let value: Double = try __br.readRaw(Double.self)

            // field: parameters, type: struct FacebookNamedValue[]
            let parameters: [FacebookNamedValue] = try __br.readRaw([FacebookNamedValue].self)

            self.fb_send_custom_event(event_name: event_name, value: value, parameters: parameters)
            return 0.0
        }
        catch
        {
            os_log("Corrupted buffer when calling 'fb_send_custom_event'", log: .default, type: .error)
            return -1
        }
    }

    public func __EXT_SWIFT__fb_send_purchase(_ __arg_buffer: UnsafeMutablePointer<CChar>?, arg1 __arg_buffer_length: Double) -> Double
    {
        do
        {
            var __br = BufferReader(base: UnsafeRawPointer(__arg_buffer!), size: Int(__arg_buffer_length))

            // field: amount, type: Float64
            let amount: Double = try __br.readRaw(Double.self)

            // field: currency, type: String
            let currency: String = try __br.readRaw(String.self)

            // field: parameters, type: struct FacebookNamedValue[]
            let parameters: [FacebookNamedValue] = try __br.readRaw([FacebookNamedValue].self)

            self.fb_send_purchase(amount: amount, currency: currency, parameters: parameters)
            return 0.0
        }
        catch
        {
            os_log("Corrupted buffer when calling 'fb_send_purchase'", log: .default, type: .error)
            return -1
        }
    }

    public func __EXT_SWIFT__fb_flush_events() -> Double
    {
        self.fb_flush_events()
        return 0.0
    }

    public func __EXT_SWIFT__fb_set_event_user_id(_ user_id: String) -> Double
    {
        self.fb_set_event_user_id(user_id: user_id)
        return 0.0
    }

    public func __EXT_SWIFT__fb_get_event_user_id() -> String
    {
        let __result = self.fb_get_event_user_id()
        return __result
    }

    public func __EXT_SWIFT__fb_clear_event_user_id() -> Double
    {
        self.fb_clear_event_user_id()
        return 0.0
    }

    public func __EXT_SWIFT__GMFacebook_invocation_handler(_ __ret_buffer: UnsafeMutablePointer<CChar>?, arg1 __ret_buffer_length: Double) -> Double
    {
        var __bw = BufferWriter(base: UnsafeMutableRawPointer(__ret_buffer!), size: Int(__ret_buffer_length))
        return __dispatch_queue.fetch(into: &__bw)
    }

}
