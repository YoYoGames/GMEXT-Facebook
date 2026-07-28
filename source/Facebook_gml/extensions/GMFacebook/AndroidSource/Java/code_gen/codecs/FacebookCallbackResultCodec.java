// ##### extgen :: Auto-generated file do not edit!! #####

package ${YYAndroidPackageName}.codecs;

import java.nio.ByteBuffer;

import ${YYAndroidPackageName}.GMExtWire;
import ${YYAndroidPackageName}.records.*;

public final class FacebookCallbackResultCodec {
    private FacebookCallbackResultCodec()
    {
    }
    public static FacebookCallbackResult read(ByteBuffer b)
    {
        boolean success = GMExtWire.readBool(b);

        int status = GMExtWire.readI32(b);

        int request_id = GMExtWire.readI32(b);

        String error_message = GMExtWire.readString(b);

        String access_token = GMExtWire.readString(b);

        String user_id = GMExtWire.readString(b);

        String response_text = GMExtWire.readString(b);

        String post_id = GMExtWire.readString(b);

        return new FacebookCallbackResult(success, status, request_id, error_message, access_token, user_id, response_text, post_id);
    }

    public static void write(ByteBuffer b, FacebookCallbackResult obj)
    {
        GMExtWire.writeBool(b, obj.success());

        GMExtWire.writeI32(b, obj.status());

        GMExtWire.writeI32(b, obj.request_id());

        GMExtWire.writeString(b, obj.error_message());

        GMExtWire.writeString(b, obj.access_token());

        GMExtWire.writeString(b, obj.user_id());

        GMExtWire.writeString(b, obj.response_text());

        GMExtWire.writeString(b, obj.post_id());

    }
}