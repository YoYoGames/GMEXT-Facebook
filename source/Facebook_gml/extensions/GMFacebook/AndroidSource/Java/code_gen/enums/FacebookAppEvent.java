// ##### extgen :: Auto-generated file do not edit!! #####

package ${YYAndroidPackageName}.enums;

public enum FacebookAppEvent
{
    AchievedLevel((int)101),
    AddedPaymentInfo((int)102),
    AddedToCart((int)103),
    AddedToWishlist((int)104),
    CompletedRegistration((int)105),
    CompletedTutorial((int)106),
    InitiatedCheckout((int)107),
    Rated((int)109),
    Searched((int)110),
    SpentCredits((int)111),
    UnlockedAchievement((int)112),
    ViewedContent((int)113);

    private final int value;
    private FacebookAppEvent(int v)
    {
        this.value = v;
    }
    public int value()
    {
        return this.value;
    }
    public static FacebookAppEvent from(int v)
    {
        switch (v)
        {
            case 101:
                return FacebookAppEvent.AchievedLevel;
            case 102:
                return FacebookAppEvent.AddedPaymentInfo;
            case 103:
                return FacebookAppEvent.AddedToCart;
            case 104:
                return FacebookAppEvent.AddedToWishlist;
            case 105:
                return FacebookAppEvent.CompletedRegistration;
            case 106:
                return FacebookAppEvent.CompletedTutorial;
            case 107:
                return FacebookAppEvent.InitiatedCheckout;
            case 109:
                return FacebookAppEvent.Rated;
            case 110:
                return FacebookAppEvent.Searched;
            case 111:
                return FacebookAppEvent.SpentCredits;
            case 112:
                return FacebookAppEvent.UnlockedAchievement;
            case 113:
                return FacebookAppEvent.ViewedContent;
            default:
                throw new IllegalArgumentException("Unknown FacebookAppEvent value: " + v);
        }
    }
}