// ##### extgen :: Auto-generated file do not edit!! #####

package ${YYAndroidPackageName}.records;

import ${YYAndroidPackageName}.GMExtWire;
import ${YYAndroidPackageName}.codecs.*;

import java.nio.ByteBuffer;

public record FacebookEventParameterValue(int key, String string_value, double number_value, boolean use_number) implements GMExtWire.ITypedStruct
{
    public static final int CODEC_ID = 0;
    @Override
    public void encode(ByteBuffer b)
    {
        FacebookEventParameterValueCodec.write(b, this);
    }
}
