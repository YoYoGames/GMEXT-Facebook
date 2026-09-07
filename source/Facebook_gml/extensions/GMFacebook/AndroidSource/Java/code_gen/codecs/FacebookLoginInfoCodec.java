// ##### extgen :: Auto-generated file do not edit!! #####

package ${YYAndroidPackageName}.codecs;

import java.nio.ByteBuffer;

import ${YYAndroidPackageName}.GMExtWire;
import ${YYAndroidPackageName}.GMExtWire.GMValue;
import java.util.List;
import ${YYAndroidPackageName}.records.*;

public final class FacebookLoginInfoCodec {
    private FacebookLoginInfoCodec()
    {
    }
    public static FacebookLoginInfo read(ByteBuffer b)
    {
        String access_token = GMExtWire.readString(b);

        String user_id = GMExtWire.readString(b);

        java.util.List<String> permissions = GMExtWire.readList(b, bb -> GMExtWire.readString(bb));

        java.util.List<String> declined_permissions = GMExtWire.readList(b, bb -> GMExtWire.readString(bb));

        return new FacebookLoginInfo(access_token, user_id, permissions, declined_permissions);
    }

    public static void write(GMExtWire.IByteWriter b, FacebookLoginInfo obj)
    {
        GMExtWire.writeString(b, obj.access_token());

        GMExtWire.writeString(b, obj.user_id());

        GMExtWire.writeList(b, obj.permissions(), (bb, x) -> GMExtWire.writeString(bb, x));

        GMExtWire.writeList(b, obj.declined_permissions(), (bb, x) -> GMExtWire.writeString(bb, x));

    }
}