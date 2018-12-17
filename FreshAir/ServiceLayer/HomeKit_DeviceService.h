//
//  DeviceService.h
//  FreshAir
//
//  Created by mars on 29/06/2017.
//  Copyright © 2017 mars. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HomeKit_DevicesRequest, HomeKit_DeviceRequest, HomeKit_AboutViewController, HomeKit_WatchInfoOutdoorRequest, HomeKit_Pm25CityStationRequest, HomeKit_MainViewController, HomeKit_DetailViewController, XLinkDevice, HistoryInfoRequest;

@interface HomeKit_DeviceService : NSObject

@property (nonatomic, strong) HomeKit_AboutViewController *vcAbout;
@property (nonatomic, strong) HomeKit_MainViewController *vcMain;
@property (nonatomic, strong) HomeKit_DetailViewController *vcDetail;

//when import device
@property (nonatomic, strong) NSMutableArray *rooms;
@property (nonatomic, strong) NSMutableArray *services;
@property (nonatomic, assign) NSInteger indexService;
@property (nonatomic, assign) NSInteger indexRoom;

@property (nonatomic, strong) NSMutableArray *maXLinkDevices;

@property (nonatomic, assign) BOOL hasGotXLinkList;


//for 静默升级
@property (nonatomic, strong) NSMutableArray *maDidCheckedUpgrade;

+ (HomeKit_DeviceService *)sharedInstance;

#pragma mark - location
- (NSDictionary *)fetchLocalSavedLocationWithHomeID:(NSString *)pHomeID;
- (void)saveLocationWithCityName:(NSString *)pCityName
                     stationName:(NSString *)pStationName
                     stationCode:(NSString *)pStationCode
                          homeID:(NSString *)pHomeID;

#pragma mark - Login
//- (void)executeRequestForLoginWithOpenId:(NSString *)pOpenId
//                                 unionId:(NSString *)pUnionId
//                                nickName:(NSString *)pNickName
//                              headimgurl:(NSString *)pHeadimgurl
//                         completionBlock:(ServiceCompletionBlock)pCompletionBlock
- (void)loginWithOpenId:(NSString *)pOpenId
                unionId:(NSString *)pUnionId
               nickName:(NSString *)pNickName
             headimgurl:(NSString *)pHeadimgurl
        completionBlock:(ServiceCompletionBlock)pCompletionBlock;

#pragma mark - Methods
- (void)searchOutdoorPMInfoWithRequest:(HomeKit_WatchInfoOutdoorRequest *)pRequest
                       completionBlock:(ServiceCompletionBlock)pCompletionBlock;
#pragma mark - 6 查询周边城市
- (void)fetchSearchNearCityWithRequest:(NSString *)pRequest
                       completionBlock:(ServiceCompletionBlock)pCompletionBlock;
#pragma mark - 7 查询城市 监测站
- (void)fetchPm25CityStationWithRequest:(HomeKit_Pm25CityStationRequest *)pRequest
                        completionBlock:(ServiceCompletionBlock)pCompletionBlock;

#pragma mark - 10 设备7天数据比对
- (void)fetchHistoryInfosWithRequest:(HistoryInfoRequest *)pRequest
                     completionBlock:(ServiceCompletionBlock)pCompletionBlock;


#pragma mark - xLink service

- (void)refreshXLinkDevice:(XLinkDevice *)pXLinkDevice
                       uid:(NSString *)pUID
                    openID:(NSString *)pOpenID
                      time:(NSInteger)pTime
           completionBlock:(ServiceCompletionBlock)pCompletionBlock;

//1 通过uId获取设备列表
- (void)getAllDevicesWithUID:(NSString *)pUID
                      openID:(NSString *)pOpenID
             completionBlock:(ServiceCompletionBlock)pCompletionBlock;

#pragma mark - xlink 新设备绑定
//5   添加绑定任务
- (void)insertDeviceBoundWithPID:(NSString *)pId
                          openID:(NSString *)pOpenID
                 completionBlock:(ServiceCompletionBlock)pCompletionBlock;
//6  绑定设备
- (void)reBindingDeviceWithPID:(NSString *)pId
                           did:(NSString *)pDID
                          cDId:(NSString *)pCDId
                            sn:(NSString *)pSN
                      platform:(NSString *)pPlatform
                           uId:(NSString *)pUID
                        openID:(NSString *)pOpenID
               completionBlock:(ServiceCompletionBlock)pCompletionBlock;

//7 保存绑定设备信息
- (void)updateBoundDeviceAddressAreaWithPID:(NSString *)pId
                                     openID:(NSString *)pOpenID
                                    address:(NSString *)pAddress
                                       area:(NSString *)pArea
                                 deivceName:(NSString *)pDeivceName
                            completionBlock:(ServiceCompletionBlock)pCompletionBlock;

//8 查询用户信息 - 电话号码
- (void)searchCustomerInfoWithOpenID:(NSString *)pOpenID
                     completionBlock:(ServiceCompletionBlock)pCompletionBlock;

//9 保存用户电话号码
- (void)saveUserInfoProjectWithOpenID:(NSString *)pOpenID
                          phoneNumber:(NSString *)pPhoneNumber
                      completionBlock:(ServiceCompletionBlock)pCompletionBlock;

//15 由sn换mac
- (void)getXlinkDeviceInfoBySnWithSN:(NSString *)pSN
                     completionBlock:(ServiceCompletionBlock)pCompletionBlock;

//14 设备休眠
//#define kSleepDevice @"/ApiServer/ProjectV2/api/DeviceInfo/SleepDeviceProjectV2"
//- (NSMutableURLRequest *)sleepDevice:(NSDictionary *)pParams;
//{
//    "uid":"",
//    "pId":"",
//    "platform":"",
//    "openId":"",
//    "deviceType":"",
//    "dId":"",
//    "sendData":""
//}
- (void)sleepDeviceWithOpenID:(NSString *)pOpenID
                          uid:(NSString *)pUID
                          pId:(NSString *)pPID
                     platform:(NSString *)pPlatform
                   deviceType:(NSString *)pDeviceType
                          dId:(NSString *)pDID
                     sendData:(NSString *)pSendData
              completionBlock:(ServiceCompletionBlock)pCompletionBlock;

//13 风机开关
//#define kOpenAndCloseFan @"/ApiServer/ProjectV2/api/DeviceInfo/OpenAndCloseFanProjectV2"
//{
//    "uid":"",
//    "pId":"",
//    "platform":"",
//    "openId":"",
//    "deviceType":"",
//    "dId":"",
//    "isOpen":"",
//}
- (void)openAndCloseFanWithOpenID:(NSString *)pOpenID
                              uid:(NSString *)pUID
                              pId:(NSString *)pPID
                         platform:(NSString *)pPlatform
                       deviceType:(NSString *)pDeviceType
                              dId:(NSString *)pDID
                           isOpen:(NSString *)pIsOpen
                  completionBlock:(ServiceCompletionBlock)pCompletionBlock;

//9 辅热开关
//#define kOpenClosePtc @"/ApiServer/ProjectV2/api/DeviceInfo/OpenClosePtcProjectV2"
//- (NSMutableURLRequest *)openClosePtc:(NSDictionary *)pParams;
//{
//    "uid":"",
//    "pId":"",
//    "platform":"",
//    "openId":"",
//    "sendData":"",
//    "deviceType":"",
//    "dId":"",
//    "isOpen":"",
//
//}

- (void)openClosePtcWithOpenID:(NSString *)pOpenID
                           uid:(NSString *)pUID
                           pId:(NSString *)pPID
                      platform:(NSString *)pPlatform
                    deviceType:(NSString *)pDeviceType
                           dId:(NSString *)pDID
                        isOpen:(NSString *)pIsOpen
                      sendData:(NSString *)pSendData
               completionBlock:(ServiceCompletionBlock)pCompletionBlock;

//11 屏幕亮度调节
//#define kModifyDeviceScreen @"/ApiServer/ProjectV2/api/DeviceInfo/ModifyDeviceScreenProjectV2"
//- (NSMutableURLRequest *)modifyDeviceScreen:(NSDictionary *)pParams;
//{
//    "uid":"",
//    "pId":"",
//    "platform":"",
//    "openId":"",
//    "sendData":"",
//    "deviceType":"",
//    "dId":"",
//}
- (void)modifyDeviceScreenWithOpenID:(NSString *)pOpenID
                                 uid:(NSString *)pUID
                                 pId:(NSString *)pPID
                            platform:(NSString *)pPlatform
                          deviceType:(NSString *)pDeviceType
                                 dId:(NSString *)pDID
                            sendData:(NSString *)pSendData
                     completionBlock:(ServiceCompletionBlock)pCompletionBlock;

//8 设置风速
//#define kSetDeivecSpeed @"/ApiServer/ProjectV2/api/DeviceInfo/SetDeivecSpeedProjectV2"
//- (NSMutableURLRequest *)setDeivecSpeed:(NSDictionary *)pParams
//{
//    "uid":"",
//    "pId":"",
//    "platform":"",
//    "openId":"",
//    "minSpeed":"",
//    "maxSpeed":"",
//    "sendData":"",
//    "deviceType":"",
//    "dId":"",
//}

- (void)setDeivecSpeedWithOpenID:(NSString *)pOpenID
                             uid:(NSString *)pUID
                             pId:(NSString *)pPID
                        platform:(NSString *)pPlatform
                      deviceType:(NSString *)pDeviceType
                             dId:(NSString *)pDID
                        sendData:(NSString *)pSendData
                        minSpeed:(NSString *)pMinSpeed
                        maxSpeed:(NSString *)pMaxSpeed
                 completionBlock:(ServiceCompletionBlock)pCompletionBlock;



- (NSString *)airQualityDescriptionWithValue:(NSInteger)pValue;
- (void)checkIfXLinkServiceWithSerial:(NSString *)pSerial
                                 pId:(NSString *)pPId
                     completionBlock:(ServiceCompletionBlock)pCompletionBlock;

- (void)checkIfXLinkServiceByOtherBind:(NSString *)PID completionBlock:(ServiceCompletionBlock)pCompletionBlock;

@end
