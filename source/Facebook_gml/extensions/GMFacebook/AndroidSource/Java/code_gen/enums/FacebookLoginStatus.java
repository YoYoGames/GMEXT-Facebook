// ##### extgen :: Auto-generated file do not edit!! #####

package ${YYAndroidPackageName}.enums;

public enum FacebookLoginStatus
{
    Idle((int)0),
    Processing((int)1),
    Failed((int)2),
    Authorised((int)3);

    private final int value;
    private FacebookLoginStatus(int v)
    {
        this.value = v;
    }
    public int value()
    {
        return this.value;
    }
    public static FacebookLoginStatus from(int v)
    {
        switch (v)
        {
            case 0:
                return FacebookLoginStatus.Idle;
            case 1:
                return FacebookLoginStatus.Processing;
            case 2:
                return FacebookLoginStatus.Failed;
            case 3:
                return FacebookLoginStatus.Authorised;
            default:
                throw new IllegalArgumentException("Unknown FacebookLoginStatus value: " + v);
        }
    }
}