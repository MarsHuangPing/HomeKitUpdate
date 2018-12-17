//
//  HttpManager.m
//  NewPeek2
//
//  Created by Tyler on 13-4-1.
//  Copyright (c) 2013年 Delaware consulting. All rights reserved.
//

#define kTimeout 15

#define BaseURL @"http://smartmaintenance.airburgzen.cn:89/"


#define AdverBaseURL @"http://airburgzen.cn:90/"
#define kSplashAdverPath @"Redirect/api/EmoRedirect/GetNewUrl?"

//login
#define kLoginPath @"ApiServer/ProjectV2/api/DeviceInfo/BindOpenIdBingPro?token=QZ3RkTfsx23s3sd2224"

#define kSearchOutdoorPMInfoPath @"AbleCloudService/AppService/api/CustomerInfoApi/GetOutdoorInfoByAreaAndStation?"
//6 查询周边城市
#define kGetSearchNearCityPath @"AbleCloudService/HtmlClient/Device/api/BoundDeviceInfo/SearchDeviceOtherArea?token=QZ3RkTfsx23s3sd2224"

// 7 查询城市 监测站
#define kSearchStationByAreaPath @"AbleCloudService/Pm25INCity/api/Pm25CityStation/SearchStationByArea?"

// 10 设备7天数据比对
#define kGetHistoryPm25Path @"AbleCloudService/api/HistoryPm25/GetHistoryPm25?"

//xLink service
//1 通过uId获取设备列表
#define kGetAllDevices @"/ApiServer/ProjectV2/api/DeviceInfo/GetAllDevicesProjectV2"

//2 通过uId获取设备列表
#define kGetSingleDevice @"/ApiServer/ProjectV2/api/DeviceInfo/GetSingleDeviceProjectV2"

//5   添加绑定任务
#define kInsertDeviceBound @"/ApiServer/ProjectV2/api/DeviceInfo/InsertDeviceBoundProjectV2"

//6  绑定设备
#define kReBindingDevice @"/ApiServer/ProjectV2/api/DeviceInfo/ReBindingDeviceProjectV2"

//7 保存绑定设备信息
#define kUpdateBoundDeviceAddressArea @"/ApiServer/ProjectV2/api/DeviceInfo/UpdateBoundDeviceAddressAreaProjectV2"

//8 查询用户信息 - 电话号码
#define kSearchCustomerInfo @"/ApiServer/ProjectV2/api/CustomerInfoApi/SearchCustomerInfo"

//9 保存用户电话号码
#define kSaveUserInfoProject @"/ApiServer/ProjectV2/api/CustomerInfoApi/SaveUserInfoProjectV2"

//15 由sn换mac
#define kGetXlinkDeviceInfoBySn @"/ApiServer/ProjectV2/api/DeviceInfo/GetXlinkDeviceInfoBySn"

//14 设备休眠
#define kSleepDevice @"/ApiServer/ProjectV2/api/DeviceInfo/SleepDeviceProjectV2"


//13 风机开关
#define kOpenAndCloseFan @"/ApiServer/ProjectV2/api/DeviceInfo/OpenAndCloseFanProjectV2"

//9 辅热开关
#define kOpenClosePtc @"/ApiServer/ProjectV2/api/DeviceInfo/OpenClosePtcProjectV2"

//11 屏幕亮度调节
#define kModifyDeviceScreen @"/ApiServer/ProjectV2/api/DeviceInfo/ModifyDeviceScreenProjectV2"

//8 设置风速
#define kSetDeivecSpeed @"/ApiServer/ProjectV2/api/DeviceInfo/SetDeivecSpeedProjectV2"

//检查是否绑定
#define kIsDeviceBound @"/ApiServer/ProjectV2/api/DeviceInfo/IsDeviceBoundProjectV2"


#import "HomeKit_HttpManager.h"
#import "NSString+ML.h"
#import "NSObject+ML.h"
#import "AFNetworking.h"

#import "HomeKit_LanguageManager.h"

@interface HomeKit_HttpManager ()
{
    NSURL *_baseURL;
}

@end

@implementation HomeKit_HttpManager

#pragma mark - Singleton

- (id)init
{
    if (self = [super init]) {
        
    }
    
    return self;
}

+ (HomeKit_HttpManager *)sharedInstance
{
    static HomeKit_HttpManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[HomeKit_HttpManager alloc] init];
    });
    
    return sharedInstance;
}

#pragma mark - Common HttpRequest

- (NSMutableURLRequest *)retrieveRequestWithMethod:(NSString *)pMethod
                                              path:(NSString *)pPath
                                            params:(NSDictionary *)pParams
{
    
    
    
    NSMutableString *apiPath = [NSMutableString string];
    [apiPath appendString:BaseURL];
    [apiPath appendString:pPath];
    
    if([[pMethod lowercaseString] isEqualToString:@"get"]){
        
        NSInteger count = 0;
        for(NSString *key in pParams.allKeys){
            if(count != 0){ [apiPath appendString:@"&"]; }
            [apiPath appendString:key];
            [apiPath appendString:@"="];
            [apiPath appendString:pParams[key]];
            count++;
        }
        
    }
    else{
        [apiPath appendString:[NSString stringWithFormat:@"?token=%@", kToken]];
    }
    
    
    NSMutableURLRequest *result = [[AFJSONRequestSerializer serializer] requestWithMethod:pMethod
                                                                                URLString:[apiPath ml_urlEncode]
                                                                               parameters:[[pMethod lowercaseString] isEqualToString:@"get"]?nil:pParams
                                                                                    error:nil];
    [result setTimeoutInterval:kTimeout];
    [result setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    
    return result;
}

- (NSMutableURLRequest *)retrieveSplashAdverRequestWithMethod:(NSString *)pMethod
                                                         path:(NSString *)pPath
                                                       params:(NSDictionary *)pParams
{
    
    
    
    NSMutableString *apiPath = [NSMutableString string];
    [apiPath appendString:AdverBaseURL];
    [apiPath appendString:pPath];
    
    if([[pMethod lowercaseString] isEqualToString:@"get"]){
        
        NSInteger count = 0;
        for(NSString *key in pParams.allKeys){
            if(count != 0){ [apiPath appendString:@"&"]; }
            [apiPath appendString:key];
            [apiPath appendString:@"="];
            [apiPath appendString:[NSString stringWithFormat:@"%@", pParams[key]]];
            count++;
        }
        
    }
    
    
    NSMutableURLRequest *result = [[AFJSONRequestSerializer serializer] requestWithMethod:pMethod
                                                                                URLString:[apiPath ml_urlEncode]
                                                                               parameters:[[pMethod lowercaseString] isEqualToString:@"get"]?nil:pParams
                                                                                    error:nil];
    [result setTimeoutInterval:kTimeout];
    [result setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    
    return result;
}

- (void)downloadFileWithURL:(NSURL *)pURL
                   fileName:(NSString *)pFileName
                       size:(NSInteger)pSize
            completionBlock:(void (^)(BOOL result))pCompletionBlock
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:pURL];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:pFileName];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:filePath.path error:&error];
        NSInteger fileSize = 0;
        if (fileAttributes != nil) {
            fileSize = [[fileAttributes objectForKey:NSFileSize] ml_intValue];

        }
        NSLog(@"File downloaded to: %@", filePath);
        pCompletionBlock(error == nil && fileSize/1000 >= pSize);
    }];
    [downloadTask resume];
}

#pragma mark - splash advertisment
- (NSMutableURLRequest *)fetchkSplashAdvertisementRequestWithParams:(NSDictionary *)pParams
{
    return [self retrieveSplashAdverRequestWithMethod:@"GET"
                                                 path:kSplashAdverPath
                                               params:pParams];
}

#pragma mark - 5 查询城市 监测站的PM
- (NSMutableURLRequest *)fetchkSearchOutdoorPMInfoRequestWithParams:(NSDictionary *)pParams
{
    return [self retrieveRequestWithMethod:@"GET"
                                      path:kSearchOutdoorPMInfoPath
                                    params:pParams];
}

#pragma mark - 7 查询城市 监测站
- (NSMutableURLRequest *)fetchkSearchStationByAreaRequestWithParams:(NSDictionary *)pParams
{
    return [self retrieveRequestWithMethod:@"GET"
                                      path:kSearchStationByAreaPath
                                    params:pParams];
}

#pragma mark - 6 查询周边城市
- (NSMutableURLRequest *)fetchkSearchNearCityRequestWithParams:(NSDictionary *)pParams
{
    return [self retrieveRequestWithMethod:@"POST"
                                      path:kGetSearchNearCityPath
                                    params:pParams];
}

#pragma mark - 10 设备7天数据比对
- (NSMutableURLRequest *)fetchkGetHistoryPm25RequestWithParams:(NSDictionary *)pParams
{
    return [self retrieveRequestWithMethod:@"GET"
                                      path:kGetHistoryPm25Path
                                    params:pParams];
}


//xLink service
//1 通过uId获取设备列表
//#define kGetAllDevices @"/ApiServer/ProjectV2/api/DeviceInfo/GetAllDevicesProjectV2"
//
- (NSMutableURLRequest *)getAllDevicesWithParams:(NSDictionary *)pParams
{
    return [self retrieveRequestWithMethod:@"POST"
                                      path:kGetAllDevices
                                    params:pParams];
}



//2 通过uId获取设备列表
//#define kGetSingleDevice @"/ApiServer/ProjectV2/api/DeviceInfo/GetSingleDeviceProjectV2"
//
- (NSMutableURLRequest *)getSingleDevice:(NSDictionary *)pParams
{
    return [self retrieveRequestWithMethod:@"POST"
                                      path:kGetSingleDevice
                                    params:pParams];
}


//5   添加绑定任务
//#define kInsertDeviceBound @"/ApiServer/ProjectV2/api/DeviceInfo/InsertDeviceBoundProjectV2"
//
- (NSMutableURLRequest *)insertDeviceBound:(NSDictionary *)pParams
{
    return [self retrieveRequestWithMethod:@"POST"
                                      path:kInsertDeviceBound
                                    params:pParams];
}


//6  绑定设备
//#define kReBindingDevice @"/ApiServer/ProjectV2/api/DeviceInfo/ReBindingDeviceProjectV2"
//
- (NSMutableURLRequest *)reBindingDevice:(NSDictionary *)pParams
{
    return [self retrieveRequestWithMethod:@"POST"
                                      path:kReBindingDevice
                                    params:pParams];
}


//7 保存绑定设备信息
//#define kUpdateBoundDeviceAddressArea @"/ApiServer/ProjectV2/api/DeviceInfo/UpdateBoundDeviceAddressAreaProjectV2"
- (NSMutableURLRequest *)updateBoundDeviceAddressArea:(NSDictionary *)pParams
{
    return [self retrieveRequestWithMethod:@"POST"
                                      path:kUpdateBoundDeviceAddressArea
                                    params:pParams];
}

//8 查询用户信息 - 电话号码
//#define kSearchCustomerInfo @"/ApiServer/ProjectV2/api/CustomerInfoApi/SearchCustomerInfo"
- (NSMutableURLRequest *)searchCustomerInfo:(NSDictionary *)pParams
{
    return [self retrieveRequestWithMethod:@"POST"
                                      path:kSearchCustomerInfo
                                    params:pParams];
}


//9 保存用户电话号码
//#define kSaveUserInfoProject @"/ApiServer/ProjectV2/api/CustomerInfoApi/SaveUserInfoProjectV2"
- (NSMutableURLRequest *)saveUserInfoProject:(NSDictionary *)pParams
{
    return [self retrieveRequestWithMethod:@"POST"
                                      path:kSaveUserInfoProject
                                    params:pParams];
}

//15 由sn换mac
//#define kGetXlinkDeviceInfoBySn @"/ApiServer/ProjectV2/api/DeviceInfo/GetXlinkDeviceInfoBySn"
- (NSMutableURLRequest *)getXlinkDeviceInfoBySn:(NSDictionary *)pParams
{
    return [self retrieveRequestWithMethod:@"POST"
                                      path:kGetXlinkDeviceInfoBySn
                                    params:pParams];
}


//14 设备休眠
#define kSleepDevice @"/ApiServer/ProjectV2/api/DeviceInfo/SleepDeviceProjectV2"
- (NSMutableURLRequest *)sleepDevice:(NSDictionary *)pParams
{
    return [self retrieveRequestWithMethod:@"POST"
                                      path:kSleepDevice
                                    params:pParams];
}

//13 风机开关
- (NSMutableURLRequest *)openAndCloseFan:(NSDictionary *)pParams
{
    return [self retrieveRequestWithMethod:@"POST"
                                      path:kOpenAndCloseFan
                                    params:pParams];
}

//9 辅热开关
//#define kOpenClosePtc @"/ApiServer/ProjectV2/api/DeviceInfo/OpenClosePtcProjectV2"
- (NSMutableURLRequest *)openClosePtc:(NSDictionary *)pParams
{
    return [self retrieveRequestWithMethod:@"POST"
                                      path:kOpenClosePtc
                                    params:pParams];
}

//11 屏幕亮度调节
//#define kModifyDeviceScreen @"/ApiServer/ProjectV2/api/DeviceInfo/ModifyDeviceScreenProjectV2"
- (NSMutableURLRequest *)modifyDeviceScreen:(NSDictionary *)pParams
{
    return [self retrieveRequestWithMethod:@"POST"
                                      path:kModifyDeviceScreen
                                    params:pParams];
}

//8 设置风速
//#define kSetDeivecSpeed @"/ApiServer/ProjectV2/api/DeviceInfo/SetDeivecSpeedProjectV2"
- (NSMutableURLRequest *)setDeivecSpeed:(NSDictionary *)pParams
{
    return [self retrieveRequestWithMethod:@"POST"
                                      path:kSetDeivecSpeed
                                    params:pParams];
}

//检查是否绑定
//#define kIsDeviceBound @"/ApiServer/ProjectV2/api/DeviceInfo/IsDeviceBoundProjectV2"
- (NSMutableURLRequest *)isDeviceBound:(NSDictionary *)pParams
{
    return [self retrieveRequestWithMethod:@"POST"
                                      path:kIsDeviceBound
                                    params:pParams];
}

#pragma mark - 0 登录
- (NSMutableURLRequest *)loginRequestWithParams:(NSDictionary *)pParams
{
    return [self retrieveRequestWithMethod:@"POST"
                                      path:kLoginPath
                                    params:pParams];
}


#pragma mark - Common

- (ErrorType)errorType:(NSInteger)pStatusCode
{
    ErrorType result;
    
    switch (pStatusCode) {
        case NSURLErrorTimedOut:
        {
            result = ErrorTypeTimeout;
            
            break;
        }
        case NSURLErrorNetworkConnectionLost:
        case NSURLErrorNotConnectedToInternet:
        {
            result = ErrorTypeNONetwork;
            
            break;
        }
        case NSURLErrorCannotFindHost:
        case NSURLErrorCannotConnectToHost:
        case NSURLErrorBadServerResponse:
        {
            result = ErrorTypeServerError;
            
            break;
        }
        default:
        {
            result = ErrorTypeServerError;
            
            break;
        }
    }
    
    return result;
}

- (HttpStatusType)httpStatusType:(NSInteger)pStatusCode
{
    HttpStatusType result;
    
    switch (pStatusCode) {
        case NSURLErrorTimedOut:
        {
            result = HttpStatusTypeTimeout;
            
            break;
        }
        case NSURLErrorNetworkConnectionLost:
        case NSURLErrorNotConnectedToInternet:
        {
            result = HttpStatusTypeNONetwork;
            
            break;
        }
        case NSURLErrorCannotFindHost:
        case NSURLErrorCannotConnectToHost:
        case NSURLErrorBadServerResponse:
        {
            result = HttpStatusTypeServerError;
            
            break;
        }
        default:
        {
            result = HttpStatusTypeServerError;
            
            break;
        }
    }
    
    return result;
}

@end
