// ##### extgen :: Auto-generated file do not edit!! #####

package ${YYAndroidPackageName}.records;

import ${YYAndroidPackageName}.GMExtWire;
import ${YYAndroidPackageName}.GMExtWire.GMValue;
import ${YYAndroidPackageName}.codecs.*;
import ${YYAndroidPackageName}.enums.*;

import java.nio.ByteBuffer;

public record FacebookEventParameterValue(FacebookAppEventParameter key, String string_value, double number_value, boolean use_number) implements GMExtWire.ITypedStruct
{
    public static final int CODEC_ID = 0;
    @Override
    public void encode(GMExtWire.IByteWriter b)
    {
        FacebookEventParameterValueCodec.write(b, this);
    }
}
