// ##### extgen :: Auto-generated file do not edit!! #####

package ${YYAndroidPackageName}.enums;

public enum FacebookAppEventParameter
{
    Content((int)1001),
    AdType((int)1002),
    ContentId((int)1003),
    ContentType((int)1004),
    Currency((int)1005),
    Description((int)1006),
    Level((int)1007),
    MaxRatingValue((int)1008),
    NumItems((int)1009),
    PaymentInfoAvailable((int)1010),
    RegistrationMethod((int)1011),
    SearchString((int)1012),
    Success((int)1013),
    OrderId((int)1014);

    private final int value;
    private FacebookAppEventParameter(int v)
    {
        this.value = v;
    }
    public int value()
    {
        return this.value;
    }
    public static FacebookAppEventParameter from(int v)
    {
        switch (v)
        {
            case 1001:
                return FacebookAppEventParameter.Content;
            case 1002:
                return FacebookAppEventParameter.AdType;
            case 1003:
                return FacebookAppEventParameter.ContentId;
            case 1004:
                return FacebookAppEventParameter.ContentType;
            case 1005:
                return FacebookAppEventParameter.Currency;
            case 1006:
                return FacebookAppEventParameter.Description;
            case 1007:
                return FacebookAppEventParameter.Level;
            case 1008:
                return FacebookAppEventParameter.MaxRatingValue;
            case 1009:
                return FacebookAppEventParameter.NumItems;
            case 1010:
                return FacebookAppEventParameter.PaymentInfoAvailable;
            case 1011:
                return FacebookAppEventParameter.RegistrationMethod;
            case 1012:
                return FacebookAppEventParameter.SearchString;
            case 1013:
                return FacebookAppEventParameter.Success;
            case 1014:
                return FacebookAppEventParameter.OrderId;
            default:
                throw new IllegalArgumentException("Unknown FacebookAppEventParameter value: " + v);
        }
    }
}