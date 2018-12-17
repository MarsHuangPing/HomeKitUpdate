//
//  HttpManager.h
//  NewPeek2
//
//  Created by Tyler on 13-4-1.
//  Copyright (c) 2013年 Delaware consulting. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeKit_HttpManager : NSObject

+ (HomeKit_HttpManager *)sharedInstance;

#pragma mark - splash advertisment
- (void)downloadFileWithURL:(NSURL *)pURL
                   fileName:(NSString *)pFileName
                       size:(NSInteger)pSize
            completionBlock:(void (^)(BOOL result))pCompletionBlock;
- (NSMutableURLRequest *)fetchkSplashAdvertisementRequestWithParams:(NSDictionary *)pParams;

#pragma mark - 5 查询城市 监测站的PM
- (NSMutableURLRequest *)fetchkSearchOutdoorPMInfoRequestWithParams:(NSDictionary *)pParams;
#pragma mark - 7 查询城市 监测站
- (NSMutableURLRequest *)fetchkSearchStationByAreaRequestWithParams:(NSDictionary *)pParams;
#pragma mark - 6 查询周边城市
- (NSMutableURLRequest *)fetchkSearchNearCityRequestWithParams:(NSDictionary *)pParams;

#pragma mark - 10 设备7天数据比对
- (NSMutableURLRequest *)fetchkGetHistoryPm25RequestWithParams:(NSDictionary *)pParams;

//xLink service
//1 通过uId获取设备列表
//#define kGetAllDevices @"/ApiServer/ProjectV2/api/DeviceInfo/GetAllDevicesProjectV2"
//
- (NSMutableURLRequest *)getAllDevicesWithParams:(NSDictionary *)pParams;
//2 通过uId获取设备列表
//#define kGetSingleDevice @"/ApiServer/ProjectV2/api/DeviceInfo/GetSingleDeviceProjectV2"
//
- (NSMutableURLRequest *)getSingleDevice:(NSDictionary *)pParams;
//5   添加绑定任务
//#define kInsertDeviceBound @"/ApiServer/ProjectV2/api/DeviceInfo/InsertDeviceBoundProjectV2"
//
- (NSMutableURLRequest *)insertDeviceBound:(NSDictionary *)pParams;
//6  绑定设备
//#define kReBindingDevice @"/ApiServer/ProjectV2/api/DeviceInfo/ReBindingDeviceProjectV2"
//
- (NSMutableURLRequest *)reBindingDevice:(NSDictionary *)pParams;
//7 保存绑定设备信息
//#define kUpdateBoundDeviceAddressArea @"/ApiServer/ProjectV2/api/DeviceInfo/UpdateBoundDeviceAddressAreaProjectV2"
- (NSMutableURLRequest *)updateBoundDeviceAddressArea:(NSDictionary *)pParams;

//8 查询用户信息 - 电话号码
//#define kSearchCustomerInfo @"/ApiServer/ProjectV2/api/CustomerInfoApi/SearchCustomerInfo"
- (NSMutableURLRequest *)searchCustomerInfo:(NSDictionary *)pParams;
//9 保存用户电话号码
//#define kSaveUserInfoProject @"/ApiServer/ProjectV2/api/CustomerInfoApi/SaveUserInfoProjectV2"
- (NSMutableURLRequest *)saveUserInfoProject:(NSDictionary *)pParams;
//15 由sn换mac
//#define kGetXlinkDeviceInfoBySn @"/ApiServer/ProjectV2/api/DeviceInfo/GetXlinkDeviceInfoBySn"
- (NSMutableURLRequest *)getXlinkDeviceInfoBySn:(NSDictionary *)pParams;

//14 设备休眠
//#define kSleepDevice @"/ApiServer/ProjectV2/api/DeviceInfo/SleepDeviceProjectV2"
- (NSMutableURLRequest *)sleepDevice:(NSDictionary *)pParams;

//13 风机开关
//#define kOpenAndCloseFan @"/ApiServer/ProjectV2/api/DeviceInfo/OpenAndCloseFanProjectV2"
- (NSMutableURLRequest *)openAndCloseFan:(NSDictionary *)pParams;

//9 辅热开关
//#define kOpenClosePtc @"/ApiServer/ProjectV2/api/DeviceInfo/OpenClosePtcProjectV2"
- (NSMutableURLRequest *)openClosePtc:(NSDictionary *)pParams;

//11 屏幕亮度调节
//#define kModifyDeviceScreen @"/ApiServer/ProjectV2/api/DeviceInfo/ModifyDeviceScreenProjectV2"
- (NSMutableURLRequest *)modifyDeviceScreen:(NSDictionary *)pParams;

//8 设置风速
//#define kSetDeivecSpeed @"/ApiServer/ProjectV2/api/DeviceInfo/SetDeivecSpeedProjectV2"
- (NSMutableURLRequest *)setDeivecSpeed:(NSDictionary *)pParams;

//检查是否绑定
//#define kIsDeviceBound @"/ApiServer/ProjectV2/api/DeviceInfo/IsDeviceBoundProjectV2"
- (NSMutableURLRequest *)isDeviceBound:(NSDictionary *)pParams;

#pragma mark - 0 登录
- (NSMutableURLRequest *)loginRequestWithParams:(NSDictionary *)pParams;

#pragma mark - Common

- (ErrorType)errorType:(NSInteger)pStatusCode;
- (HttpStatusType)httpStatusType:(NSInteger)pStatusCode;

@end
