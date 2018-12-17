//
//  Constants.h
//  NewPeek2
//
//  Created by Tyler on 5/4/14.
//  Copyright (c) 2014 Delaware consulting. All rights reserved.
//

#define kWebsiteURL @"http://www.memiao.cn"

#define kAdmobID @"ca-app-pub-6282500486283906/1866508272"

#define kBaiduAdID @"fdd21c59"

#define RGB(r, g, b) [UIColor colorWithRed:(r) / 255.0 green:(g) / 255.0 blue:(b) / 255.0 alpha:1]
#define RGBA(r, g, b, a) [UIColor colorWithRed:(r) / 255.0 green:(g) / 255.0 blue:(b) / 255.0 alpha:(a)]

#pragma mark -
#pragma mark  判断设备尺寸  iPhone
/******************************************
 
 判断设备尺寸  iPhone
 
 *****************************************/

//判断是否为iPhone4S
#define iPhone4S ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
//判断设备是否为iPhone5S
#define iPhone5S ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
//判断设备是否为iPhone6
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6Zoomed ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

//判断设备是否为iPhone6Plus
#define iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6PlusZoomed ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) : NO)

#pragma mark -
#pragma mark  判断设备尺寸  iPad
/******************************************
 
 判断设备尺寸  iPad
 
 *****************************************/


//判断设备是否为   iPad 1， iPad2，iPad mini
#define iPadCommon ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(768, 1024), [[UIScreen mainScreen] currentMode].size) : NO)

//判断设备是否为   New iPad，iPad 4
#define iPadRetina ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1536, 2048), [[UIScreen mainScreen] currentMode].size) : NO)
//屏幕适配，全局的宽
#define Screen_height   [[UIScreen mainScreen] bounds].size.height
#define Screen_width    [[UIScreen mainScreen] bounds].size.width


#define GE_iOS6 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0 ? YES : NO)
#define GE_iOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ? YES : NO)
#define GE_iOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 ? YES : NO)

//Weak
#define MLWeakObject(obj) __typeof__(obj) __weak
#define MLWeakSelf MLWeakObject(self)

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#define kAppDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)

#define kCheckMarkGif @"checkmark.gif"

#define kTimerInteval 10

#define kCollectionPaging 3

#define kWechatTokenJsonKey @"WechatTokenJsonKey"
#define kWechatUserJsonKey @"WechatUserJsonKey"

//Image Caches

#define kImageCachesFolderName @"FreshAir_Images"

//Database

#define kEnglishDatabaseName @"Peek2_EN.db"
#define kChineseDatabaseName @"Peek2_CH.db"

//init ad const
#define kAdverURL @"adverURL"

#define kItemVisibiltyArray [NSMutableArray arrayWithObjects:Localize(@"general_visible"), Localize(@"general_hidden"), nil]
#define kContentTypeArray [NSMutableArray arrayWithObjects:@"collection_collection_type",@"collection_item_type", nil]
#define kPublicTypeArray [NSMutableArray arrayWithObjects:Localize(@"collection_private_type"), Localize(@"collection_public_type"), nil]
#define kGenderArray [NSMutableArray arrayWithObjects:Localize(@"userinfo_male"), Localize(@"userinfo_female"), Localize(@"userinfo_nosay"), nil]
#define kEighteenArray [NSMutableArray arrayWithObjects:Localize(@"general_no"), Localize(@"general_yes"), nil]
#define kAllowUploadArray [NSMutableArray arrayWithObjects:Localize(@"collection_all"), Localize(@"collection_owner"), nil]
#define kCoverTypeArray [NSMutableArray arrayWithObjects:Localize(@"collection_random_covertype"), Localize(@"collection_choose_covertype"), Localize(@"collection_custom_covertype"), nil]

//Enum

typedef NS_ENUM(NSInteger, DeviceStatus) {
    DeviceStatusNormal,
    DeviceStatusUpdating,
    DeviceStatusOffline
};

typedef NS_ENUM(NSInteger, DeviceConnectionStatus) {
    DeviceConnectionStatusConnected,
    DeviceConnectionStatusDisconnected,
    DeviceConnectionStatusUnknow
};

typedef NS_ENUM (NSInteger, LocationAccessErrorType) {
    LocationAccessErrorTypeNormall,
    LocationAccessErrorTypeDeny,
    LocationAccessErrorTypeCommonError
};

typedef NS_ENUM (NSInteger, SocialType) {
    SocialTypeFacebook = 1,
    SocialTypeTwitter,
    SocialTypeSinaWeibo,
    SocialTypeQQ
};

typedef NS_ENUM (NSInteger, RelayPeepType) {
    RelayPeepTypeUnRelay,
    RelayPeepTypeRelay
};

typedef NS_ENUM(NSInteger, PlusIconType) {
    PlusIconTypeBlue,
    PlusIconTypeGreen,
    PlusIconTypeOrange,
    PlusIconTypeGray
};

typedef NS_ENUM(NSInteger, VoteType) {
    VoteTypeRandom,
    VoteTypeDirectAgree,
    VoteTypeDirectDrop
};

typedef NS_ENUM(NSInteger, CollectionParentType) {
    CollectionParentTypeInCategory,
    CollectionParentTypeInCollection
};

typedef NS_ENUM(NSInteger, CollectionContentType) {
    CollectionContentTypeCollection,
    CollectionContentTypeItem
};

typedef NS_ENUM(NSInteger, AllowUploadType) {
    AllowUploadTypeAll,
    AllowUploadTypeOwner
};

typedef NS_ENUM (NSInteger, ItemVisibiltyType) {
    ItemVisibiltyTypeVisible,
    ItemVisibiltyTypeHidden
};

typedef NS_ENUM (NSInteger, AccessType) {
    AccessTypePrivate,
    AccessTypePublic,
    AccessTypeMembership
};

typedef NS_ENUM (NSInteger, PreviousPosition) {
    PreviousPositionHome,
    PreviousPositionMyCollection,
    PreviousPositionCollection,
    PreviousPositionItem,
    PreviousPositionChampion,
    PreviousPositionMyPeeps
};

typedef NS_ENUM (NSInteger, ErrorType) {
    ErrorTypeNull,
    ErrorTypeTimeout,
    ErrorTypeNONetwork,
    ErrorTypeServerError
};

typedef NS_ENUM(NSInteger, HttpStatusType) {
    HttpStatusTypeOK,
    HttpStatusTypeTimeout,
    HttpStatusTypeNONetwork,
    HttpStatusTypeServerError,
    HttpStatusTypeNoDevice
};

typedef NS_ENUM(NSInteger, CoverType) {
    CoverTypeRandom,
    CoverTypeChoose,
    CoverTypeCustom
};

typedef NS_ENUM(NSInteger, ErrorMessageType) {
    ErrorMessageTypeNoDevice,
    ErrorMessageTypeFoundError,
    ErrorMessageTypeNormal
};

typedef NS_ENUM(NSInteger, EditType) {
    EditTypeRename,
    EditTypeNew
};

typedef NS_ENUM(NSInteger, AuthorityType) {
    AuthorityTypeUnknow,
    AuthorityTypeAdmin,
    AuthorityTypeGuest
};

//wind panel display tag
typedef NS_ENUM(NSInteger, CtrlWindButtonTagType) {
    CtrlWindButtonTagTypeIntelligence = 3000,
    CtrlWindButtonTagTypeFix,
    CtrlWindButtonTagTypeCustom
};

//wind mode set tag
typedef NS_ENUM(NSInteger, WindButtonModeTagType) {
    WindButtonModeTagTypeIntelligence = 4000,
    WindButtonModeTagTypeFix,
    WindButtonModeTagTypeCustom
};

typedef NS_ENUM(NSInteger, AFNetworkReachabilityStatus) {
    AFNetworkReachabilityStatusUnknown          = -1,
    AFNetworkReachabilityStatusNotReachable     = 0,
    AFNetworkReachabilityStatusReachableViaWWAN = 1,
    AFNetworkReachabilityStatusReachableViaWiFi = 2,
};

#define kDefaultRoomName @"Default Room"

//Images

#define kWarningImage ImageFromResources(@"dropdown-alert.png")

//HTML

#define kHTMLFramework @"<html><head><meta http-equiv='Content-Type' content='text/html; charset=utf-8'/><title></title><style>img{max-width:100%;}</style></head><body style='margin:5'>{Content}</body></html>"

#define kToken @"QZ3RkTfsx23s3sd2224"

//locaion station
#define kCityNameKey @"kCityNameKey"
#define kStationNameKey @"kStationNameKey"
#define kStationCodeKey @"kStationCodeKey"

#define PM25_AIRPROPERITY_DES_LABEL_FIRST  @"空气质量优"
#define PM25_AIRPROPERITY_DES_LABEL_SECOND  @"空气质量良"
#define PM25_AIRPROPERITY_DES_LABEL_THIRD  @"空气轻度污染"
#define PM25_AIRPROPERITY_DES_LABEL_FOURTH  @"空气中度污染"
#define PM25_AIRPROPERITY_DES_LABEL_FIVE  @"空气重度污染"
#define PM25_AIRPROPERITY_DES_LABEL_SIX  @"严重污染"
#define PM25_AIRPROPERITY_DES_LABEL_SEVEN  @"不宜人类生存"


#define PM25_BACKGROUND_COLOR_FIRST  [UIColor colorWithRed:((255) / 255.0f) green:((255) / 255.0f) blue:((255) / 255.0f) alpha:1.0f]
#define PM25_BACKGROUND_COLOR_SECOND  [UIColor colorWithRed:((139) / 255.0f) green:((195) / 255.0f) blue:((74) / 255.0f) alpha:1.0f]
#define PM25_BACKGROUND_COLOR_THIRD  [UIColor colorWithRed:((223) / 255.0f) green:((196) / 255.0f) blue:((43) / 255.0f) alpha:1.0f]
#define PM25_BACKGROUND_COLOR_FOURTH  [UIColor colorWithRed:((251) / 255.0f) green:((140) / 255.0f) blue:((0) / 255.0f) alpha:1.0f]
#define PM25_BACKGROUND_COLOR_FIVE  [UIColor colorWithRed:((229) / 255.0f) green:((57) / 255.0f) blue:((53) / 255.0f) alpha:1.0f]
#define PM25_BACKGROUND_COLOR_SIX  [UIColor colorWithRed:((97) / 255.0f) green:((98) / 255.0f) blue:((131) / 255.0f) alpha:1.0f]
#define PM25_BACKGROUND_COLOR_SEVEN  [UIColor colorWithRed:((61) / 255.0f) green:((60) / 255.0f) blue:((52) / 255.0f) alpha:1.0f]


//splash advertisment
typedef NS_ENUM(NSInteger, ADDeviceType) {
    ADDeviceTypeIOS = 1,
    ADDeviceTypeAndroid
};

typedef NS_ENUM(NSInteger, iOSScreenType) {
    iOSScreenType4S,
    iOSScreenType5,
    iOSScreenType47,
    iOSScreenTypePlus,
    iOSScreenTypeX,
    iOSScreenTypePad
};

#define k360ADeviceType @"0103"

#define kSplashJsonFileName @"SplashJsonFileName.json"
#define kDefaultHomeID @"00000000-0000-00000000-0000-11111111"

// -4, setting
#define kPurifieManufacturer @"00000020-0000-1000-8000-0026BB765291"
#define kPurifieModel @"00000021-0000-1000-8000-0026BB765291"
#define kPurifieSerial @"00000030-0000-1000-8000-0026BB765291"
#define kPurifieFirmware @"00000052-0000-1000-8000-0026BB765291"



#define kGetHomeNotification @"GetHomeNotification"
//-3,---------------------------------------------------
#define kPurifier @"Accessory"
//-2,---------------------------------------------------
#define kPurifierSerialNumber @"00000030-0000-1000-8000-0026BB765291"

//-1,---------------------------------------------------
#define kPurifierSystem @"E35C6E00-6B4B-5F6E-BEEA-B3A6ADB9EF5D"

//0,-----------------------------------------------------
//Accessory Name
#define kPurifierName @"00000001-0000-1000-8000-0026BB765291"
//1, ----------------------------------------------------
//Apple-defined Air Purifier Service
//空氣淨化器服務
//public.hap.characteristic.air-purifier.state.current
//Current Air Purifier State
//Format: uint8
//0: Inactive
//1: Idle
//2: Purifying Air
#define kPurifierCurrentState @"000000A9-0000-1000-8000-0026BB765291"

//public.hap.characteristic.air-purifier.state.target
//Target Air Purifier State
//Format: uint8
//0: Manual
//1: Auto
#define kPurifierTargetState @"000000A8-0000-1000-8000-0026BB765291"

//public.hap.characteristic.active
//Active
//Format: uint8
//0: Inactive
//1: Active
#define kPurifieActive @"000000B0-0000-1000-8000-0026BB765291"

//custom.airburg.hap.characteristic.heater-enable
//Heater enable
//Format: bool
//0: disable
//1: enable
#define kPurifieHeaterEnable @"C1000F45-98F7-4031-A24F-F8C9CE5C4906"

//public.hap.characteristic.rotation.speed
//Rotation Speed
//Format: float
//Min:0
//Max.:100
//Step: 1
#define kPurifieSpeed @"00000029-0000-1000-8000-0026BB765291"
#define kPurifieSpeedCustom @"7A0CEBD8-559B-4667-9DB0-96A8CD70051A"
//custom.airburg.hap.characteristic.sleep-mode
//Sleep Mode
//休眠模式
//Format: uint8
//0: Sleep Mode OFF
//1: Sleep Mode On
#define kPurifieSleepMode @"033856A1-4B49-48F6-A9AB-B4E705D02021"

//custom.airburg.hap.characteristic.power-consumption
//Power Consumption
//消耗功率
//Format: uint16
//Min.:0
//Max.:3000
#define kPurifiePowerConsumption @"D7467855-8B65-42EC-98E1-496FF153F342"

//public.hap.characteristic.name
//Name
//Service Name
#define kPurifiePurifierServiceName @"00000023-0000-1000-8000-0026BB765291"

//2, ----------------------------------------------------
//Apple-defined Air Quality Sensor
//空氣品質傳感器
//0000008D-0000-1000-8000-0026BB765291
//public.hap.service.sensor.air-quality

//PM2.5 Air Quality
//空氣品質分類"
//public.hap.characteristic.air-quality
//Format: uint8
//Min:1
//Ma.:5
//Step: 1
//1:"Excent",2:"Good",3:"Fair",4:"Inferior",5:"Poor"
//Paired Read,
//Notify
#define kPurifieAirQuality @"00000095-0000-1000-8000-0026BB765291"

//current PM2.5 micrometer particulate density in micrograms/m3
//public.hap.characteristic.density.pm25
//Format: float
//Min.:0
//Max.:1000
//Paired Read,
//Notify
#define kPurifiePM25 @"000000C6-0000-1000-8000-0026BB765291"

//Service Name
//public.hap.characteristic.name
//Service Name
//Paired Read
#define kPurifieQualitySensorName @"00000023-0000-1000-8000-0026BB765291"



//3,------------------------------------------------------------------
//Carbon Dioxide Sensor
//CO2傳感器
//00000097-0000-1000-8000-0026BB765291
//public.hap.service.sensor.carbon-dioxide

//"CO2 Normal/Abnormal detect
//CO2狀態"
//Format: uint8
//0: Normal
//1: Abnormal
//Paired Read,
//Notify
//public.hap.characteristic.carbon-dioxide.detected
#define kPurifieCo2Detect @"00000092-0000-1000-8000-0026BB765291"

//"CO2 Density
//CO2濃度"
//Format: float
//Min.: 0
//Max.: 100000
//Paired Read,
//Notify
//public.hap.characteristic.carbon-dioxide.level
#define kPurifieCo2Density @"00000093-0000-1000-8000-0026BB765291"

//CO2 傳感器Name
//public.hap.characteristic.name
#define kPurifieCo2ServiceName @"00000023-0000-1000-8000-0026BB765291"

//4,---------------------------------------------------------
//Temperature Sensor
//溫度傳感器
//public.hap.service.sensor.temperature
//0000008A-0000-1000-8000-0026BB765291
//
//"Current Temperature
//目前溫度"
//public.hap.characteristic.temperature.current
//Format: float
//Min.: 0
//Max.: 100
//Paired Read,
//Notify
#define kPurifieCurrentTemperature @"00000011-0000-1000-8000-0026BB765291"

//溫度傳感器 Name
//public.hap.characteristic.name
//Service Name
#define kPurifieTemperatureServiceName @"000000023-0000-1000-8000-0026BB765291"

//5,---------------------------------------------------
//Humidity Sensor
//濕度傳感器
//public.hap.service.sensor.humidity
//00000082-0000-1000-8000-0026BB765291

//"Current Relative Humidity
//目前相對溼度"
//public.hap.characteristic.relative-humidity.current
//Format: float
//Min.: 0
//Max.: 100
//Paired Read,
//Notify
#define kPurifieCurrentHumidity @"00000010-0000-1000-8000-0026BB765291"

//濕度傳感器 Name
//public.hap.characteristic.name
//Service Name
#define kPurifieHumidityServiceName @"00000023-0000-1000-8000-0026BB765291"

//6,-----------------------------------------------------
//Custome defined Panel Indication  Service
//面板彩燈
//custom.airburg.hap.service.panel-indicator
//8FE34C10-2C8E-4D6B-B5AA-D249E9A71AAD
//
//"Panel Indicator
//面板顯示"
//Format: uint8
//0: Off
//1~8 brightness control
//custom.airburg.hap.characteristic.panel-indicator
//Paired Read,
//Paired Write,
//Notify
#define kPurifieIndication @"7DC5BE19-8B09-4BFC-B156-2AAF199FAED9"

//Name
//public.hap.characteristic.name
//Service Name
#define kPurifieIndicationServiceName @"00000023-0000-1000-8000-0026BB765291"

//7,-----------------------------------------------------
//H13(HEPA) Filter Maintenance
//H13(HEPA)濾網更換
//000000BA-0000-1000-8000-0026BB765291
//public.hap.service.filter-maintenance

//public.hap.characteristic.filter-change.indication
//Format: uint8
//0: Filter does not need to be changed
//1: Filter needs to be changed
//Paired Read,
//Notify
#define kPurifieFilterMaintenance @"000000AC-0000-1000-8000-0026BB765291"

//public.hap.characteristic.name
#define kPurifieFilterMaintenanceServiceName @"00000023-0000-1000-8000-0026BB765291"

//8,-----------------------------------------------------
//Ion Dust Filter Maintenance
//離子集塵濾網更換
//000000BA-0000-1000-8000-0026BB765291
//public.hap.service.filter-maintenance

//public.hap.characteristic.filter-change.indication
//Format: uint8
//0: Filter does not need to be changed
//1: Filter needs to be changed
//Paired Read,
//Notify
#define kPurifieIonDustFilterMaintenance @"000000AC-0000-1000-8000-0026BB765291"

//public.hap.characteristic.name
#define kPurifieIonDustFilterMaintenanceServiceName @"00000023-0000-1000-8000-0026BB765291"

//9,-----------------------------------------------------

//Activatived Carbon Filter Maintenance
//臭氧還原濾網更換
//000000BA-0000-1000-8000-0026BB765291
//public.hap.service.filter-maintenance

//public.hap.characteristic.filter-change.indication
//Format: uint8
//0: Filter does not need to be changed
//1: Filter needs to be changed
//Paired Read,
//Notify
#define kPurifieActivativedCarbonFilterMaintenance @"000000AC-0000-1000-8000-0026BB765291"

//public.hap.characteristic.name
#define kPurifieActivativedCarbonFilterMaintenanceServiceName @"00000023-0000-1000-8000-0026BB765291"

//10,-----------------------------------------------------
//PreFilter Maintenance
//前置粗效濾網更換
//000000BA-0000-1000-8000-0026BB765291
//public.hap.service.filter-maintenance

//public.hap.characteristic.filter-change.indication
//Format: uint8
//0: Filter does not need to be changed
//1: Filter needs to be changed
//Paired Read,
//Notify
#define kPurifiePreFilterMaintenance @"000000AC-0000-1000-8000-0026BB765291"

//public.hap.characteristic.name
#define kPurifiePreFilterMaintenanceServiceName @"00000023-0000-1000-8000-0026BB765291"

//11,-----------------------------------------------------
//Dust Bag Filter Maintenance
//尘袋濾網更換
//000000BA-0000-1000-8000-0026BB765291
//public.hap.service.filter-maintenance

//public.hap.characteristic.filter-change.indication
//Format: uint8
//0: Filter does not need to be changed
//1: Filter needs to be changed
//Paired Read,
//Notify
#define kPurifieDustBagFilterMaintenance @"000000AC-0000-1000-8000-0026BB765291"

//public.hap.characteristic.name
#define kPurifieDustBagFilterMaintenanceServiceName @"00000023-0000-1000-8000-0026BB765291"

//12,-----------------------------------------------------
//Custom-defined system diagnostics
//custom.phytrex.hap.service.system-diagnostic
//系統自檢服務
//custom.airburg.hap.service.system-diagnostic
//286FBBE0-6B41-45BB-8646-685573DD5E94

//"PM2.5 Sensor Error
//PM2.5傳感器故障警告"
//Format: unit8
//0: No Error
//1: Error
//Paired Read,
//Notify
//custom.airburg.hap.characteristic.pm25-error
#define kPurifieCustomDefinedSystemDiagnostics_PM25SensorError @"9EE5650F-0783-4375-8F76-2BD842C0BDF7"

//"Motor Error
//風機故障警告"
//Format: unit8
//0: No Error
//1: Error
//Paired Read,
//Notify
//custom.airburg.hap.characteristic.motor-error
#define kPurifieCustomDefinedSystemDiagnostics_MotorSensorError @"A00E1A6B-0864-4A88-B4C1-E907EC2C381B"

//"Display Error
//顯示屏故障警告"
//Format: unit8
//0: No Error
//1: Error
//Paired Read,
//Notify
//custom.airburg.hap.characteristic.display-error
#define kPurifieCustomDefinedSystemDiagnostics_DisplaySensorError @"6A8FECD8-0D7B-49A3-87B3-AD1785E7B491"

//Service Name
//public.hap.characteristic.name
#define kPurifieCustomDefinedSystemDiagnosticsServiceName @"00000023-0000-1000-8000-0026BB765291"


//13,---------------------------------------------------------
#define kPurifieErrorMessage @"error001-0000-1000-8000-0026BB765291"

//14, ota
//"custom.airburg.hap.characteristic.start-upgrade
#define kPurifieStartUpgrade @"FF6F58D2-B705-460B-BAFB-5AE9063B3B59"//@"B35A1ADE-EEFA-4C83-8CD1-5DD7732423AE"//@"FF6F58D2-B705-460B-BAFB-5AE9063B3B59"
//"custom.airburg.hap.characteristic.upgrade-progress
#define kPurifieUpgradeProgress @"4EF78115-F355-4103-BC5E-340F3112AD52"
//"custom.airburg.hap.characteristic.upgrade-result
#define kPurifieUpgradeResult @"11C9B70B-8E36-4B3D-B120-2D76286D49C4"


//custom.airburg.hap.characteristic.start-upgrade
#define kPurifieUpgradeTypeIndication @"B35A1ADE-EEFA-4C83-8CD1-5DD7732423AE"



