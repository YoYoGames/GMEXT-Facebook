// ##### extgen :: Auto-generated file do not edit!! #####

package ${YYAndroidPackageName}.codecs;

import java.nio.ByteBuffer;

import ${YYAndroidPackageName}.GMExtWire;
import ${YYAndroidPackageName}.GMExtWire.GMValue;
import java.util.List;
import ${YYAndroidPackageName}.enums.*;
import ${YYAndroidPackageName}.records.*;

public final class FacebookCallbackResultCodec {
    private FacebookCallbackResultCodec()
    {
    }
    public static FacebookCallbackResult read(ByteBuffer b)
    {
        boolean success = GMExtWire.readBool(b);

        FacebookOperationStatus status = FacebookOperationStatus.from(GMExtWire.readI32(b));

        int request_id = GMExtWire.readI32(b);

        String error_message = GMExtWire.readString(b);

        String access_token = GMExtWire.readString(b);

        String user_id = GMExtWire.readString(b);

        String response_text = GMExtWire.readString(b);

        String post_id = GMExtWire.readString(b);

        java.util.List<String> granted_permissions = GMExtWire.readList(b, bb -> GMExtWire.readString(bb));

        java.util.List<String> declined_permissions = GMExtWire.readList(b, bb -> GMExtWire.readString(bb));

        return new FacebookCallbackResult(success, status, request_id, error_message, access_token, user_id, response_text, post_id, granted_permissions, declined_permissions);
    }

    public static void write(GMExtWire.IByteWriter b, FacebookCallbackResult obj)
    {
        GMExtWire.writeBool(b, obj.success());

        GMExtWire.writeI32(b, obj.status().value());

        GMExtWire.writeI32(b, obj.request_id());

        GMExtWire.writeString(b, obj.error_message());

        GMExtWire.writeString(b, obj.access_token());

        GMExtWire.writeString(b, obj.user_id());

        GMExtWire.writeString(b, obj.response_text());

        GMExtWire.writeString(b, obj.post_id());

        GMExtWire.writeList(b, obj.granted_permissions(), (bb, x) -> GMExtWire.writeString(bb, x));

        GMExtWire.writeList(b, obj.declined_permissions(), (bb, x) -> GMExtWire.writeString(bb, x));

    }
}