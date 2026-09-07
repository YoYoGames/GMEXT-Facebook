// ##### extgen :: Auto-generated file do not edit!! #####

package ${YYAndroidPackageName}.records;

import ${YYAndroidPackageName}.GMExtWire;
import ${YYAndroidPackageName}.GMExtWire.GMValue;
import ${YYAndroidPackageName}.codecs.*;

import java.nio.ByteBuffer;
import java.util.List;

public record FacebookLoginInfo(String access_token, String user_id, java.util.List<String> permissions, java.util.List<String> declined_permissions) implements GMExtWire.ITypedStruct
{
    public static final int CODEC_ID = 3;
    @Override
    public void encode(GMExtWire.IByteWriter b)
    {
        FacebookLoginInfoCodec.write(b, this);
    }
}
