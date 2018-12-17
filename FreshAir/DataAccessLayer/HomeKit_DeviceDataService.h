//
//  DeviceDataService.h
//  FreshAir
//
//  Created by mars on 29/06/2017.
//  Copyright © 2017 mars. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XLinkDevice, HistoryInfoRequest;

@class HomeKit_DevicesRequest, HomeKit_DeviceRequest, HomeKit_Pm25CityStationRequest, HomeKit_WatchInfoOutdoorRequest;

@interface HomeKit_DeviceDataService : NSObject

#pragma mark - Login
- (void)executeRequestForLoginWithOpenId:(NSString *)pOpenId
                                 unionId:(NSString *)pUnionId
                                nickName:(NSString *)pNickName
                              headimgurl:(NSString *)pHeadimgurl
                         completionBlock:(ServiceCompletionBlock)pCompletionBlock;

//#pragma mark - 5 查询城市 监测站的PM
- (void)executeRequestForSearchOutdoorPMInfoWithRequest:(HomeKit_WatchInfoOutdoorRequest *)pRequest
                                        completionBlock:(ServiceCompletionBlock)pCompletionBlock;

#pragma mark - 7 查询城市 监测站
- (void)executeRequestForSearchStationByAreaWithRequest:(HomeKit_Pm25CityStationRequest *)pRequest
                                        completionBlock:(ServiceCompletionBlock)pCompletionBlock;
#pragma mark - 6 查询周边城市
- (void)executeRequestForSearchNearCityWithCurrentCity:(NSString *)pCurrentCity
                                       completionBlock:(ServiceCompletionBlock)pCompletionBlock;


#pragma mark - 10 设备7天数据比对
- (void)executeRequestForHistoryInfosWithRequest:(HistoryInfoRequest *)pRequest
                                 completionBlock:(ServiceCompletionBlock)pCompletionBlock;

#pragma mark - xLink service
//1 通过uId获取设备列表
//- (NSMutableURLRequest *)getAllDevicesWithParams:(NSDictionary *)pParams;
- (void)executeRequestForGetAllDevicesWithUID:(NSString *)pUID
                              completionBlock:(ServiceCompletionBlock)pCompletionBlock;

//2 通过uId获取设备列表
//- (NSMutableURLRequest *)getSingleDevice:(NSDictionary *)pParams;
- (void)executeRequestForGetSingleDeviceWithUID:(NSString *)pUID
                                         device:(XLinkDevice *)pDevice
                                         openId:(NSString *)pOpenID
                                completionBlock:(ServiceCompletionBlock)pCompletionBlock;


//5   添加绑定任务
//- (NSMutableURLRequest *)insertDeviceBound:(NSDictionary *)pParams;
//{
//    "pId":"",
//    "openId":""
//}

- (void)executeRequestForInsertDeviceBoundWithPID:(NSString *)pId
                                           openID:(NSString *)pOpenID
                                  completionBlock:(ServiceCompletionBlock)pCompletionBlock;

//6  绑定设备
//- (NSMutableURLRequest *)reBindingDevice:(NSDictionary *)pParams;
//{
//    "pId":"",
//    "dId":"",
//    "cDId":"",
//    "sn":"",
//    "platform":"",
//    "uId":"",
//    "openId":""
//}
- (void)executeRequestForReBindingDeviceWithPID:(NSString *)pId
                                            did:(NSString *)pDID
                                           cDId:(NSString *)pCDId
                                             sn:(NSString *)pSN
                                       platform:(NSString *)pPlatform
                                            uId:(NSString *)pUID
                                         openID:(NSString *)pOpenID
                                completionBlock:(ServiceCompletionBlock)pCompletionBlock;

//7 保存绑定设备信息
//- (NSMutableURLRequest *)updateBoundDeviceAddressArea:(NSDictionary *)pParams;
//{
//    "pId":"",
//    "openId":"",
//    "address":"",
//    "area":"",
//    "deivceName":""
//}
- (void)executeRequestForUpdateBoundDeviceAddressAreaWithPID:(NSString *)pId
                                                      openID:(NSString *)pOpenID
                                                     address:(NSString *)pAddress
                                                        area:(NSString *)pArea
                                                  deivceName:(NSString *)pDeivceName
                                             completionBlock:(ServiceCompletionBlock)pCompletionBlock;

//8 查询用户信息 - 电话号码
//- (NSMutableURLRequest *)searchCustomerInfo:(NSDictionary *)pParams
//{
//    "openId":"oE99w0WnUzGCacmAS5SXqe_iUW20"
//}
- (void)executeRequestForSearchCustomerInfoWithOpenID:(NSString *)pOpenID
                                      completionBlock:(ServiceCompletionBlock)pCompletionBlock;

//9 保存用户电话号码
//- (NSMutableURLRequest *)saveUserInfoProject:(NSDictionary *)pParams
//{
//    "openId":"oE99w0WnUzGCacmAS5SXqe_iUW20",
//    "phoneNumber":"13654654395"
//}
- (void)executeRequestForSaveUserInfoProjectWithOpenID:(NSString *)pOpenID
                                           phoneNumber:(NSString *)pPhoneNumber
                                       completionBlock:(ServiceCompletionBlock)pCompletionBlock;

//15 由sn换mac
//- (NSMutableURLRequest *)getXlinkDeviceInfoBySn:(NSDictionary *)pParams
- (void)executeRequestForGetXlinkDeviceInfoBySnWithSN:(NSString *)pSN
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
//    "dId":""
//}
- (void)executeRequestForSleepDeviceWithOpenID:(NSString *)pOpenID
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
- (void)executeRequestForOpenAndCloseFanWithOpenID:(NSString *)pOpenID
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

- (void)executeRequestForOpenClosePtcWithOpenID:(NSString *)pOpenID
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
- (void)executeRequestForModifyDeviceScreenWithOpenID:(NSString *)pOpenID
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

- (void)executeRequestForSetDeivecSpeedWithOpenID:(NSString *)pOpenID
                                              uid:(NSString *)pUID
                                              pId:(NSString *)pPID
                                         platform:(NSString *)pPlatform
                                       deviceType:(NSString *)pDeviceType
                                              dId:(NSString *)pDID
                                         sendData:(NSString *)pSendData
                                         minSpeed:(NSString *)pMinSpeed
                                         maxSpeed:(NSString *)pMaxSpeed
                                  completionBlock:(ServiceCompletionBlock)pCompletionBlock;

//检查是否绑定
//#define kIsDeviceBound @"/ApiServer/ProjectV2/api/DeviceInfo/IsDeviceBoundProjectV2"
//- (NSMutableURLRequest *)isDeviceBound:(NSDictionary *)pParams
- (void)executeRequestForIsDeviceBoundWithPID:(NSString *)pPID
                              completionBlock:(ServiceCompletionBlock)pCompletionBlock;

#pragma mark - 0 登录
- (NSMutableURLRequest *)loginRequestWithParams:(NSDictionary *)pParams;



@end
