// ##### extgen :: Auto-generated file do not edit!! #####

package ${YYAndroidPackageName}.enums;

public enum FacebookHttpMethod
{
    Get((int)0),
    Post((int)1),
    Delete((int)2);

    private final int value;
    private FacebookHttpMethod(int v)
    {
        this.value = v;
    }
    public int value()
    {
        return this.value;
    }
    public static FacebookHttpMethod from(int v)
    {
        switch (v)
        {
            case 0:
                return FacebookHttpMethod.Get;
            case 1:
                return FacebookHttpMethod.Post;
            case 2:
                return FacebookHttpMethod.Delete;
            default:
                throw new IllegalArgumentException("Unknown FacebookHttpMethod value: " + v);
        }
    }
}