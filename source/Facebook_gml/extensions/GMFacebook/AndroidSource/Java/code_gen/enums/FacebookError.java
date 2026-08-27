// ##### extgen :: Auto-generated file do not edit!! #####

package ${YYAndroidPackageName}.enums;

public enum FacebookError
{
    Ok((int)0),
    NotInitialized((int)-1),
    ActivityNull((int)-2),
    NotLoggedIn((int)-3),
    InvalidArgument((int)-4),
    LoginInProgress((int)-5),
    ShareInProgress((int)-6);

    private final int value;
    private FacebookError(int v)
    {
        this.value = v;
    }
    public int value()
    {
        return this.value;
    }
    public static FacebookError from(int v)
    {
        switch (v)
        {
            case 0:
                return FacebookError.Ok;
            case -1:
                return FacebookError.NotInitialized;
            case -2:
                return FacebookError.ActivityNull;
            case -3:
                return FacebookError.NotLoggedIn;
            case -4:
                return FacebookError.InvalidArgument;
            case -5:
                return FacebookError.LoginInProgress;
            case -6:
                return FacebookError.ShareInProgress;
            default:
                throw new IllegalArgumentException("Unknown FacebookError value: " + v);
        }
    }
}