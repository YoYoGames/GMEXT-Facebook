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
    ViewedContent((int)113),
    Contact((int)114),
    CustomizeProduct((int)115),
    Donate((int)116),
    FindLocation((int)117),
    Schedule((int)118),
    StartTrial((int)119),
    SubmitApplication((int)120),
    Subscribe((int)121),
    AdImpression((int)122),
    AdClick((int)123);

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
            case 114:
                return FacebookAppEvent.Contact;
            case 115:
                return FacebookAppEvent.CustomizeProduct;
            case 116:
                return FacebookAppEvent.Donate;
            case 117:
                return FacebookAppEvent.FindLocation;
            case 118:
                return FacebookAppEvent.Schedule;
            case 119:
                return FacebookAppEvent.StartTrial;
            case 120:
                return FacebookAppEvent.SubmitApplication;
            case 121:
                return FacebookAppEvent.Subscribe;
            case 122:
                return FacebookAppEvent.AdImpression;
            case 123:
                return FacebookAppEvent.AdClick;
            default:
                throw new IllegalArgumentException("Unknown FacebookAppEvent value: " + v);
        }
    }
}