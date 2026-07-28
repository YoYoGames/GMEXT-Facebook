// ##### extgen :: Auto-generated file do not edit!! #####

package ${YYAndroidPackageName}.records;

import ${YYAndroidPackageName}.GMExtWire;
import ${YYAndroidPackageName}.codecs.*;

import java.nio.ByteBuffer;

public record FacebookCallbackResult(boolean success, int status, int request_id, String error_message, String access_token, String user_id, String response_text, String post_id) implements GMExtWire.ITypedStruct
{
    public static final int CODEC_ID = 2;
    @Override
    public void encode(ByteBuffer b)
    {
        FacebookCallbackResultCodec.write(b, this);
    }
}
