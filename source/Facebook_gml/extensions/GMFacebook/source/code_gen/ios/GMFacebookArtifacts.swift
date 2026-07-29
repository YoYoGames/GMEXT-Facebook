public enum FacebookLoginStatus: Int32
{
    case Idle = 0
    case Processing = 1
    case Failed = 2
    case Authorised = 3
}

public enum FacebookOperationStatus: Int32
{
    case Success = 0
    case Cancelled = 1
    case Error = 2
}

public enum FacebookHttpMethod: Int32
{
    case Get = 0
    case Post = 1
    case Delete = 2
}

public enum FacebookAppEvent: Int32
{
    case AchievedLevel = 101
    case AddedPaymentInfo = 102
    case AddedToCart = 103
    case AddedToWishlist = 104
    case CompletedRegistration = 105
    case CompletedTutorial = 106
    case InitiatedCheckout = 107
    case Rated = 109
    case Searched = 110
    case SpentCredits = 111
    case UnlockedAchievement = 112
    case ViewedContent = 113
    case Contact = 114
    case CustomizeProduct = 115
    case Donate = 116
    case FindLocation = 117
    case Schedule = 118
    case StartTrial = 119
    case SubmitApplication = 120
    case Subscribe = 121
    case AdImpression = 122
    case AdClick = 123
}

public enum FacebookAppEventParameter: Int32
{
    case Content = 1001
    case AdType = 1002
    case ContentId = 1003
    case ContentType = 1004
    case Currency = 1005
    case Description = 1006
    case Level = 1007
    case MaxRatingValue = 1008
    case NumItems = 1009
    case PaymentInfoAvailable = 1010
    case RegistrationMethod = 1011
    case SearchString = 1012
    case Success = 1013
    case OrderId = 1014
}

public struct FacebookEventParameterValue: ITypedStruct
{
    public var key: FacebookAppEventParameter
    public var string_value: String
    public var number_value: Double
    public var use_number: Bool
}

public struct FacebookNamedValue: ITypedStruct
{
    public var name: String
    public var string_value: String
    public var number_value: Double
    public var use_number: Bool
}

public struct FacebookCallbackResult: ITypedStruct
{
    public var success: Bool
    public var status: FacebookOperationStatus
    public var request_id: Int32
    public var error_message: String
    public var access_token: String
    public var user_id: String
    public var response_text: String
    public var post_id: String
    public var granted_permissions: [String]
    public var declined_permissions: [String]
}

extension FacebookEventParameterValue
{
    public static let codecID: UInt32 = 0

    public init<R: IByteReader>(_ r: inout R) throws
    {
        self.key = (FacebookAppEventParameter(rawValue: try r.readRaw(Int32.self))!)
        self.string_value = try r.readRaw(String.self)
        self.number_value = try r.readRaw(Double.self)
        self.use_number = try r.readRaw(Bool.self)
    }

    public func encode<W: IByteWriter>(_ w: inout W) throws
    {
        try w.writeRaw(self.key.rawValue)
        try w.writeRaw(self.string_value)
        try w.writeRaw(self.number_value)
        try w.writeRaw(self.use_number)
    }
}

extension FacebookNamedValue
{
    public static let codecID: UInt32 = 1

    public init<R: IByteReader>(_ r: inout R) throws
    {
        self.name = try r.readRaw(String.self)
        self.string_value = try r.readRaw(String.self)
        self.number_value = try r.readRaw(Double.self)
        self.use_number = try r.readRaw(Bool.self)
    }

    public func encode<W: IByteWriter>(_ w: inout W) throws
    {
        try w.writeRaw(self.name)
        try w.writeRaw(self.string_value)
        try w.writeRaw(self.number_value)
        try w.writeRaw(self.use_number)
    }
}

extension FacebookCallbackResult
{
    public static let codecID: UInt32 = 2

    public init<R: IByteReader>(_ r: inout R) throws
    {
        self.success = try r.readRaw(Bool.self)
        self.status = (FacebookOperationStatus(rawValue: try r.readRaw(Int32.self))!)
        self.request_id = try r.readRaw(Int32.self)
        self.error_message = try r.readRaw(String.self)
        self.access_token = try r.readRaw(String.self)
        self.user_id = try r.readRaw(String.self)
        self.response_text = try r.readRaw(String.self)
        self.post_id = try r.readRaw(String.self)
        self.granted_permissions = try r.readRaw([String].self)
        self.declined_permissions = try r.readRaw([String].self)
    }

    public func encode<W: IByteWriter>(_ w: inout W) throws
    {
        try w.writeRaw(self.success)
        try w.writeRaw(self.status.rawValue)
        try w.writeRaw(self.request_id)
        try w.writeRaw(self.error_message)
        try w.writeRaw(self.access_token)
        try w.writeRaw(self.user_id)
        try w.writeRaw(self.response_text)
        try w.writeRaw(self.post_id)
        try w.writeRawList(self.granted_permissions)
        try w.writeRawList(self.declined_permissions)
    }
}

