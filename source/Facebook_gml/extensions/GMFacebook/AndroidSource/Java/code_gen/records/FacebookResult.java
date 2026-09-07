// ##### extgen :: Auto-generated file do not edit!! #####

package ${YYAndroidPackageName}.records;

import ${YYAndroidPackageName}.GMExtWire;
import ${YYAndroidPackageName}.GMExtWire.GMValue;
import ${YYAndroidPackageName}.codecs.*;
import ${YYAndroidPackageName}.enums.*;

import java.nio.ByteBuffer;
import java.util.Optional;

public record FacebookResult(boolean success, FacebookOperationStatus status, java.util.Optional<String> error_message, java.util.Optional<Integer> sdk_error_code) implements GMExtWire.ITypedStruct
{
    public static final int CODEC_ID = 2;
    @Override
    public void encode(GMExtWire.IByteWriter b)
    {
        FacebookResultCodec.write(b, this);
    }
}
