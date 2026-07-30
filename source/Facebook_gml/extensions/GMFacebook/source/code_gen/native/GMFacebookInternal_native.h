// ##### extgen :: Auto-generated file do not edit!! #####

#pragma once
#include <cstdint>
#include <string_view>
#include <vector>
#include <array>
#include <optional>
#include "core/GMExtWire.h"

namespace gm_consts
{
}


namespace gm_enums
{
    enum class FacebookLoginStatus : std::int32_t
    {
        Idle = 0,
        Processing = 1,
        Failed = 2,
        Authorised = 3
    };

    enum class FacebookOperationStatus : std::int32_t
    {
        Success = 0,
        Cancelled = 1,
        Error = 2
    };

    enum class FacebookHttpMethod : std::int32_t
    {
        Get = 0,
        Post = 1,
        Delete = 2
    };

    enum class FacebookAppEvent : std::int32_t
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
        ViewedContent = 113,
        Contact = 114,
        CustomizeProduct = 115,
        Donate = 116,
        FindLocation = 117,
        Schedule = 118,
        StartTrial = 119,
        SubmitApplication = 120,
        Subscribe = 121,
        AdImpression = 122,
        AdClick = 123
    };

    enum class FacebookAppEventParameter : std::int32_t
    {
        Content = 1001,
        AdType = 1002,
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
        Success = 1013,
        OrderId = 1014
    };

}


namespace gm_structs
{
    struct FacebookEventParameterValue;
    struct FacebookNamedValue;
    struct FacebookCallbackResult;

    struct FacebookEventParameterValue
    {
        gm_enums::FacebookAppEventParameter key;
        std::string string_value;
        double number_value;
        bool use_number;
    };

    struct FacebookNamedValue
    {
        std::string name;
        std::string string_value;
        double number_value;
        bool use_number;
    };

    struct FacebookCallbackResult
    {
        bool success;
        gm_enums::FacebookOperationStatus status;
        std::int32_t request_id;
        std::string error_message;
        std::string access_token;
        std::string user_id;
        std::string response_text;
        std::string post_id;
        std::vector<std::string> granted_permissions;
        std::vector<std::string> declined_permissions;
    };

}

namespace gm::wire::codec
{
    template<>
    inline void writeValue<gm_structs::FacebookEventParameterValue>(gm::byteio::IByteWriter& _buf, const gm_structs::FacebookEventParameterValue& obj)
    {
        gm::wire::codec::writeValue(_buf, obj.key);
        gm::wire::codec::writeValue(_buf, obj.string_value);
        gm::wire::codec::writeValue(_buf, obj.number_value);
        gm::wire::codec::writeValue(_buf, obj.use_number);
    }

    template<>
    inline gm_structs::FacebookEventParameterValue readValue<gm_structs::FacebookEventParameterValue>(gm::byteio::BufferReader& _buf)
    {
        gm_structs::FacebookEventParameterValue obj;
        obj.key = gm::wire::codec::readValue<gm_enums::FacebookAppEventParameter>(_buf);
        obj.string_value = gm::wire::codec::readValue<std::string>(_buf);
        obj.number_value = gm::wire::codec::readValue<double>(_buf);
        obj.use_number = gm::wire::codec::readValue<bool>(_buf);
        return obj;
    }

    template<>
    inline void writeValue<gm_structs::FacebookNamedValue>(gm::byteio::IByteWriter& _buf, const gm_structs::FacebookNamedValue& obj)
    {
        gm::wire::codec::writeValue(_buf, obj.name);
        gm::wire::codec::writeValue(_buf, obj.string_value);
        gm::wire::codec::writeValue(_buf, obj.number_value);
        gm::wire::codec::writeValue(_buf, obj.use_number);
    }

    template<>
    inline gm_structs::FacebookNamedValue readValue<gm_structs::FacebookNamedValue>(gm::byteio::BufferReader& _buf)
    {
        gm_structs::FacebookNamedValue obj;
        obj.name = gm::wire::codec::readValue<std::string>(_buf);
        obj.string_value = gm::wire::codec::readValue<std::string>(_buf);
        obj.number_value = gm::wire::codec::readValue<double>(_buf);
        obj.use_number = gm::wire::codec::readValue<bool>(_buf);
        return obj;
    }

    template<>
    inline void writeValue<gm_structs::FacebookCallbackResult>(gm::byteio::IByteWriter& _buf, const gm_structs::FacebookCallbackResult& obj)
    {
        gm::wire::codec::writeValue(_buf, obj.success);
        gm::wire::codec::writeValue(_buf, obj.status);
        gm::wire::codec::writeValue(_buf, obj.request_id);
        gm::wire::codec::writeValue(_buf, obj.error_message);
        gm::wire::codec::writeValue(_buf, obj.access_token);
        gm::wire::codec::writeValue(_buf, obj.user_id);
        gm::wire::codec::writeValue(_buf, obj.response_text);
        gm::wire::codec::writeValue(_buf, obj.post_id);
        gm::wire::codec::writeValue(_buf, obj.granted_permissions);
        gm::wire::codec::writeValue(_buf, obj.declined_permissions);
    }

    template<>
    inline gm_structs::FacebookCallbackResult readValue<gm_structs::FacebookCallbackResult>(gm::byteio::BufferReader& _buf)
    {
        gm_structs::FacebookCallbackResult obj;
        obj.success = gm::wire::codec::readValue<bool>(_buf);
        obj.status = gm::wire::codec::readValue<gm_enums::FacebookOperationStatus>(_buf);
        obj.request_id = gm::wire::codec::readValue<std::int32_t>(_buf);
        obj.error_message = gm::wire::codec::readValue<std::string>(_buf);
        obj.access_token = gm::wire::codec::readValue<std::string>(_buf);
        obj.user_id = gm::wire::codec::readValue<std::string>(_buf);
        obj.response_text = gm::wire::codec::readValue<std::string>(_buf);
        obj.post_id = gm::wire::codec::readValue<std::string>(_buf);
        obj.granted_permissions = gm::wire::codec::readVector<std::string>(_buf);
        obj.declined_permissions = gm::wire::codec::readVector<std::string>(_buf);
        return obj;
    }

}

namespace gm::wire::details
{
    template<>
    struct gm_struct_traits<gm_structs::FacebookEventParameterValue>
    {
        static constexpr bool is_gm_struct = true;
        static constexpr std::uint32_t codec_id = 0;
    };

    template<>
    struct gm_struct_traits<gm_structs::FacebookNamedValue>
    {
        static constexpr bool is_gm_struct = true;
        static constexpr std::uint32_t codec_id = 1;
    };

    template<>
    struct gm_struct_traits<gm_structs::FacebookCallbackResult>
    {
        static constexpr bool is_gm_struct = true;
        static constexpr std::uint32_t codec_id = 2;
    };

}

void fb_initialize(const gm::wire::GMFunction& callback);
bool fb_ready();
gm_enums::FacebookLoginStatus fb_status();
bool fb_is_logged_in();
std::string fb_user_id();
std::string fb_access_token();
void fb_logout();
void fb_set_auto_log_app_events_enabled(bool enabled);
bool fb_auto_log_app_events_enabled();
void fb_set_advertiser_id_collection_enabled(bool enabled);
bool fb_advertiser_id_collection_enabled();
void fb_set_event_data_usage_limited(bool enabled);
bool fb_event_data_usage_limited();
void fb_set_data_processing_options(const std::vector<std::string_view>& options, std::int32_t country, std::int32_t state);
bool fb_check_permission(std::string_view permission);
void fb_login(const std::vector<std::string_view>& permissions, const gm::wire::GMFunction& callback);
void fb_request_read_permissions(const std::vector<std::string_view>& permissions, const gm::wire::GMFunction& callback);
void fb_request_publish_permissions(const std::vector<std::string_view>& permissions, const gm::wire::GMFunction& callback);
void fb_refresh_access_token(const gm::wire::GMFunction& callback);
void fb_graph_request(std::string_view graph_path, gm_enums::FacebookHttpMethod method, const std::vector<gm_structs::FacebookNamedValue>& parameters, const gm::wire::GMFunction& callback);
void fb_dialog(std::string_view link_url, const gm::wire::GMFunction& callback);
void fb_send_event(gm_enums::FacebookAppEvent event, double value, const std::vector<gm_structs::FacebookEventParameterValue>& parameters);
void fb_send_custom_event(std::string_view event_name, double value, const std::vector<gm_structs::FacebookNamedValue>& parameters);
void fb_send_purchase(double amount, std::string_view currency, const std::vector<gm_structs::FacebookNamedValue>& parameters);
void fb_flush_events();
void fb_set_event_user_id(std::string_view user_id);
std::string fb_get_event_user_id();
void fb_clear_event_user_id();
