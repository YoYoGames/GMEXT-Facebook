// ##### extgen :: Auto-generated file do not edit!! #####

package ${YYAndroidPackageName}.enums;

public enum FacebookOperationStatus
{
    Success((int)0),
    Cancelled((int)1),
    Error((int)2);

    private final int value;
    private FacebookOperationStatus(int v)
    {
        this.value = v;
    }
    public int value()
    {
        return this.value;
    }
    public static FacebookOperationStatus from(int v)
    {
        switch (v)
        {
            case 0:
                return FacebookOperationStatus.Success;
            case 1:
                return FacebookOperationStatus.Cancelled;
            case 2:
                return FacebookOperationStatus.Error;
            default:
                throw new IllegalArgumentException("Unknown FacebookOperationStatus value: " + v);
        }
    }
}