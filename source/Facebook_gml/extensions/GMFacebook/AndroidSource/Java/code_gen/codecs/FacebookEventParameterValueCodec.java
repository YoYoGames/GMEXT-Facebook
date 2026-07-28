// ##### extgen :: Auto-generated file do not edit!! #####

package ${YYAndroidPackageName}.codecs;

import java.nio.ByteBuffer;

import ${YYAndroidPackageName}.GMExtWire;
import ${YYAndroidPackageName}.records.*;

public final class FacebookEventParameterValueCodec {
    private FacebookEventParameterValueCodec()
    {
    }
    public static FacebookEventParameterValue read(ByteBuffer b)
    {
        int key = GMExtWire.readI32(b);

        String string_value = GMExtWire.readString(b);

        double number_value = GMExtWire.readF64(b);

        boolean use_number = GMExtWire.readBool(b);

        return new FacebookEventParameterValue(key, string_value, number_value, use_number);
    }

    public static void write(ByteBuffer b, FacebookEventParameterValue obj)
    {
        GMExtWire.writeI32(b, obj.key());

        GMExtWire.writeString(b, obj.string_value());

        GMExtWire.writeF64(b, obj.number_value());

        GMExtWire.writeBool(b, obj.use_number());

    }
}