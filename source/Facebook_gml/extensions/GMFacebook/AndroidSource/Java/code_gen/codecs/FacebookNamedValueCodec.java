// ##### extgen :: Auto-generated file do not edit!! #####

package ${YYAndroidPackageName}.codecs;

import java.nio.ByteBuffer;

import ${YYAndroidPackageName}.GMExtWire;
import ${YYAndroidPackageName}.records.*;

public final class FacebookNamedValueCodec {
    private FacebookNamedValueCodec()
    {
    }
    public static FacebookNamedValue read(ByteBuffer b)
    {
        String name = GMExtWire.readString(b);

        String string_value = GMExtWire.readString(b);

        double number_value = GMExtWire.readF64(b);

        boolean use_number = GMExtWire.readBool(b);

        return new FacebookNamedValue(name, string_value, number_value, use_number);
    }

    public static void write(ByteBuffer b, FacebookNamedValue obj)
    {
        GMExtWire.writeString(b, obj.name());

        GMExtWire.writeString(b, obj.string_value());

        GMExtWire.writeF64(b, obj.number_value());

        GMExtWire.writeBool(b, obj.use_number());

    }
}