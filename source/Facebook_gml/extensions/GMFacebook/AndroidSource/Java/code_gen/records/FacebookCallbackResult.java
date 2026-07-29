// ##### extgen :: Auto-generated file do not edit!! #####

package ${YYAndroidPackageName}.records;

import ${YYAndroidPackageName}.GMExtWire;
import ${YYAndroidPackageName}.codecs.*;
import ${YYAndroidPackageName}.enums.*;

import java.nio.ByteBuffer;
import java.util.List;

public record FacebookCallbackResult(boolean success, FacebookOperationStatus status, int request_id, String error_message, String access_token, String user_id, String response_text, String post_id, java.util.List<String> granted_permissions, java.util.List<String> declined_permissions) implements GMExtWire.ITypedStruct
{
    public static final int CODEC_ID = 2;
    @Override
    public void encode(ByteBuffer b)
    {
        FacebookCallbackResultCodec.write(b, this);
    }
}
