//
//  DeviceDataService.m
//  FreshAir
//
//  Created by mars on 29/06/2017.
//  Copyright © 2017 mars. All rights reserved.
//

#import "HomeKit_DeviceDataService.h"


#import "AFNetworking.h"

#import "HomeKit_HttpManager.h"

#import "HomeKit_DevicesRequest.h"
#import "HomeKit_DevicesResponse.h"
#import "HomeKit_Device.h"

#import "HomeKit_DeviceRequest.h"
#import "HomeKit_DeviceResponse.h"
#import "HomeKit_DeviceDetailInfo.h"
#import "HomeKit_History.h"

#import "HomeKit_WatchInfoOutdoorRequest.h"
#import "HomeKit_WatchInfoOutdoorResponse.h"
#import "HomeKit_WatchInfoOutdoor.h"

#import "HomeKit_Pm25CityStation.h"
#import "HomeKit_Pm25CityStationRequest.h"
#import "HomeKit_Pm25CityStationResponse.h"
#import "HomeKit_ArrayServiceResponse.h"
#import "HomeKit_BooleanResponse.h"
#import "HomeKit_StringResponse.h"

#import "HomeKit_DeviceConverter.h"

#import "XLinkDevice.h"
#import "HomeKit_XLinkDeviceServiceResponse.h"

#import "HistoryInfoRequest.h"
#import "HistoryInfoResponse.h"

#import "HomeKit_CommonAPI.h"

@implementation HomeKit_DeviceDataService


#pragma mark - Login
- (void)executeRequestForLoginWithOpenId:(NSString *)pOpenId
                                 unionId:(NSString *)pUnionId
                                nickName:(NSString *)pNickName
                              headimgurl:(NSString *)pHeadimgurl
                         completionBlock:(ServiceCompletionBlock)pCompletionBlock
{
    NSDictionary *dicParams = @{
                                @"openId": pOpenId,
                                @"unionId": pUnionId,
                                @"nickname":pNickName,
                                @"headimgurl":pHeadimgurl
                                };
    
    NSMutableURLRequest *request = [[HomeKit_HttpManager sharedInstance] loginRequestWithParams:dicParams];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request
                                                completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
                                                    NSLog(@"%@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
                                                    
                                                    HomeKit_BooleanResponse *result = [[HomeKit_BooleanResponse alloc] init];
                                                    
                                                    NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                                                    result.responseResult = [[responseString lowercaseString] containsString:@"true"];
                                                    
                                                    
                                                    
                                                    if (error) {
                                                        result.httpStatusType = [[HomeKit_HttpManager sharedInstance] httpStatusType:error.code];
                                                    }
                                                    else {
                                                        result.httpStatusType = HttpStatusTypeOK;
                                                        result.success = YES;
                                                    }
                                                    
                                                    ExecuteBlockWithOneParam(pCompletionBlock, result);
                                                }];
    
    [dataTask resume];
}

//#pragma mark - 5 查询城市 监测站的PM
- (void)executeRequestForSearchOutdoorPMInfoWithRequest:(HomeKit_WatchInfoOutdoorRequest *)pRequest
                                        completionBlock:(ServiceCompletionBlock)pCompletionBlock
{
    NSDictionary *dicParams = @{
                                @"area": EmptyString(pRequest.cityName),
                                @"station": EmptyString([pRequest.stationCode stringByReplacingOccurrencesOfString:@"<null>" withString:@""]),
                                @"token": kToken
                                };
    
    NSMutableURLRequest *request = [[HomeKit_HttpManager sharedInstance] fetchkSearchOutdoorPMInfoRequestWithParams:dicParams];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request
                                                completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {

//                                                    NSString *log = [NSString stringWithFormat:@"SearchOutdoorPMInfo: %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]];
//                                                    kDebugLog(log);
                                                    
                                                    HomeKit_WatchInfoOutdoorResponse *result = [[HomeKit_WatchInfoOutdoorResponse alloc] init];
                                                    
                                                    if (error) {
                                                        result.httpStatusType = [[HomeKit_HttpManager sharedInstance] httpStatusType:error.code];
                                                    }
                                                    else {
                                                        HomeKit_WatchInfoOutdoor *watchInfoOutdoor = nil;
                                                        watchInfoOutdoor = [HomeKit_DeviceConverter convertJSONToWatchInfoOutdoor:responseObject];
                                                        
                                                        result.watchInfoOutdoor =  watchInfoOutdoor;
                                                        result.httpStatusType = HttpStatusTypeOK;
                                                        result.success = YES;
                                                    }
                                                    
                                                    ExecuteBlockWithOneParam(pCompletionBlock, result);
                                                }];
    
    [dataTask resume];
}

#pragma mark - 7 查询城市 监测站
- (void)executeRequestForSearchStationByAreaWithRequest:(HomeKit_Pm25CityStationRequest *)pRequest
                                        completionBlock:(ServiceCompletionBlock)pCompletionBlock
{
    NSDictionary *dicParams = @{
                                @"area": EmptyString(pRequest.area),
                                @"token": EmptyString(kToken)
                                };
    
    NSMutableURLRequest *request = [[HomeKit_HttpManager sharedInstance] fetchkSearchStationByAreaRequestWithParams:dicParams];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request
                                                completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
                                                    
                                                    NSString *log = [NSString stringWithFormat:@"SearchStationByArea: %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]];
                                                    kDebugLog(log);
                                                    
                                                    HomeKit_Pm25CityStationResponse *result = [[HomeKit_Pm25CityStationResponse alloc] init];
                                                    
                                                    if (error) {
                                                        result.httpStatusType = [[HomeKit_HttpManager sharedInstance] httpStatusType:error.code];
                                                    }
                                                    else {
                                                        result.maStations =  [HomeKit_DeviceConverter convertJSONToStations:responseObject];
                                                        result.httpStatusType = HttpStatusTypeOK;
                                                        result.success = YES;
                                                    }
                                                    
                                                    ExecuteBlockWithOneParam(pCompletionBlock, result);
                                                }];
    
    [dataTask resume];
}

#pragma mark - 6 查询周边城市
- (void)executeRequestForSearchNearCityWithCurrentCity:(NSString *)pCurrentCity
                                       completionBlock:(ServiceCompletionBlock)pCompletionBlock
{
    NSDictionary *dicParams = @{
                                @"cityName": EmptyString(pCurrentCity),
                                @"token": EmptyString(kToken),
                                };
    
    NSMutableURLRequest *request = [[HomeKit_HttpManager sharedInstance] fetchkSearchNearCityRequestWithParams:dicParams];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request
                                                completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
                                                    
                                                    NSString *log = [NSString stringWithFormat:@"SearchNearCity: %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]];
                                                    kDebugLog(log);
                                                    
                                                    HomeKit_ArrayServiceResponse *result = [[HomeKit_ArrayServiceResponse alloc] init];
                                                    
                                                    if (error) {
                                                        result.httpStatusType = [[HomeKit_HttpManager sharedInstance] httpStatusType:error.code];
                                                    }
                                                    else {
                                                        result.maData =  [HomeKit_DeviceConverter convertJSONToNearCities:responseObject];
                                                        result.httpStatusType = HttpStatusTypeOK;
                                                        result.success = YES;
                                                    }
                                                    
                                                    ExecuteBlockWithOneParam(pCompletionBlock, result);
                                                }];
    
    [dataTask resume];
}

#pragma mark - 10 设备7天数据比对
- (void)executeRequestForHistoryInfosWithRequest:(HistoryInfoRequest *)pRequest
                                 completionBlock:(ServiceCompletionBlock)pCompletionBlock
{
    
    NSString *log = [NSString stringWithFormat:@"设备7天数据比对 开始......  ........%@", @""];
    kDebugLog(log);
    if(CheckNilAndNull(pRequest.area) || CheckNilAndNull(pRequest.physicalDeviceId) || CheckNilAndNull(pRequest.openId)){
        
        HistoryInfoResponse *result = [[HistoryInfoResponse alloc] init];
        result.httpStatusType = [[HomeKit_HttpManager sharedInstance] httpStatusType:HttpStatusTypeServerError];
        ExecuteBlockWithOneParam(pCompletionBlock, result);
        return;
    }
    NSDictionary *dicParams = @{
                                @"area": EmptyString(pRequest.area),
                                @"token": EmptyString(kToken),
                                @"physicalDeviceId": EmptyString(pRequest.physicalDeviceId),
                                @"openid":EmptyString(pRequest.openId)
                                };
    
    NSMutableURLRequest *request = [[HomeKit_HttpManager sharedInstance] fetchkGetHistoryPm25RequestWithParams:dicParams];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request
                                                completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
                                                    
                                                    NSString *log = [NSString stringWithFormat:@"设备7天数据比对: %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]];
                                                    kDebugLog(log);
                                                    
                                                    HistoryInfoResponse *result = [[HistoryInfoResponse alloc] init];
                                                    
                                                    if (error) {
                                                        result.httpStatusType = [[HomeKit_HttpManager sharedInstance] httpStatusType:error.code];
                                                    }
                                                    else {
                                                        result.maHistories =  [HomeKit_DeviceConverter convertJSONToHistories:responseObject];
                                                        result.httpStatusType = HttpStatusTypeOK;
                                                        result.success = YES;
                                                    }
                                                    
                                                    ExecuteBlockWithOneParam(pCompletionBlock, result);
                                                }];
    
    [dataTask resume];
}


#pragma mark - xLink service
//1 通过uId获取设备列表
//- (NSMutableURLRequest *)getAllDevicesWithParams:(NSDictionary *)pParams;
- (void)executeRequestForGetAllDevicesWithUID:(NSString *)pUID
                                       completionBlock:(ServiceCompletionBlock)pCompletionBlock
{
    NSDictionary *dicParams = @{
                                @"uid": EmptyString(pUID),
                                };
    
    NSMutableURLRequest *request = [[HomeKit_HttpManager sharedInstance] getAllDevicesWithParams:dicParams];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request
                                                completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
                                                    
                                                    NSString *log = [NSString stringWithFormat:@"GetAllDevices: %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]];
                                                    kDebugLog(log);
                                                    
                                                    HomeKit_ArrayServiceResponse *result = [[HomeKit_ArrayServiceResponse alloc] init];
                                                    
                                                    if (error) {
                                                        result.httpStatusType = [[HomeKit_HttpManager sharedInstance] httpStatusType:error.code];
                                                    }
                                                    else {
                                                        result.maData =  [HomeKit_DeviceConverter convertJSONToXLinkDevices:responseObject];
#warning mark - need to delete for moni
//                                                        result.maData = nil;
                                                        result.httpStatusType = HttpStatusTypeOK;
                                                        result.success = YES;
                                                    }
                                                    
                                                    ExecuteBlockWithOneParam(pCompletionBlock, result);
                                                }];
    
    [dataTask resume];
}

//2 通过uId获取设备列表
//- (NSMutableURLRequest *)getSingleDevice:(NSDictionary *)pParams;
//{
//    "uid":"oyCAww4cQ0R-WhHyJwfbw1OvFvqA",
//    "pId":"7C7A53048F1F",
//    "dId":"844026117",
//    "platform":"xlink",
//    "openId":"oE99w0WnUzGCacmAS5SXqe_iUW20"
//}
//pid:(NSString *)pId
//dId:(NSString *)pDID
//platform:(NSString *)pPlatform
- (void)executeRequestForGetSingleDeviceWithUID:(NSString *)pUID
                                         device:(XLinkDevice *)pDevice
                                         openId:(NSString *)pOpenID
                              completionBlock:(ServiceCompletionBlock)pCompletionBlock
{
    
    if(CheckNilAndNull(pUID) || CheckNilAndNull(pDevice.PhysicalDeviceId) || CheckNilAndNull(pDevice.DeviceID) || CheckNilAndNull(pDevice.Platform) || CheckNilAndNull(pOpenID)){
        HistoryInfoResponse *result = [[HistoryInfoResponse alloc] init];
        result.httpStatusType = [[HomeKit_HttpManager sharedInstance] httpStatusType:HttpStatusTypeServerError];
        ExecuteBlockWithOneParam(pCompletionBlock, result);
        return;
    }
    
    NSDictionary *dicParams = @{
                                @"uId":EmptyString(pUID),
                                @"pId":EmptyString(pDevice.PhysicalDeviceId),
                                @"dId":EmptyString(pDevice.DeviceID),
                                @"platform":EmptyString(pDevice.Platform),
                                @"openId":EmptyString(pOpenID)
                                };
    NSString *log = [NSString stringWithFormat:@"设备详细数据 request ：%@", dicParams];
    kDebugLog(log);
    
    NSMutableURLRequest *request = [[HomeKit_HttpManager sharedInstance] getSingleDevice:dicParams];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request
                                                completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
                                                    NSString *log = [NSString stringWithFormat:@"设备详细数据 response ：%@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]];
                                                    kDebugLog(log);
                                                    
                                                    HomeKit_XLinkDeviceServiceResponse *result = [[HomeKit_XLinkDeviceServiceResponse alloc] init];
                                                    
                                                    if (error) {
                                                        result.httpStatusType = [[HomeKit_HttpManager sharedInstance] httpStatusType:error.code];
                                                    }
                                                    else {
                                                        result.XLinkDevice =  [HomeKit_DeviceConverter convertJSONToEnhanceXLinkDevices:responseObject XLinkDevice:pDevice];
                                                        result.httpStatusType = HttpStatusTypeOK;
                                                        result.success = YES;
                                                    }
                                                    
                                                    ExecuteBlockWithOneParam(pCompletionBlock, result);
                                                }];
    
    [dataTask resume];
}

//5   添加绑定任务
//- (NSMutableURLRequest *)insertDeviceBound:(NSDictionary *)pParams;
//{
//    "pId":"",
//    "openId":""
//}

- (void)executeRequestForInsertDeviceBoundWithPID:(NSString *)pId
                                           openID:(NSString *)pOpenID
                              completionBlock:(ServiceCompletionBlock)pCompletionBlock
{
    NSDictionary *dicParams = @{
                                @"pId": EmptyString(pId),
                                @"openId": EmptyString(pOpenID)
                                };
    
    NSMutableURLRequest *request = [[HomeKit_HttpManager sharedInstance] insertDeviceBound:dicParams];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request
                                                completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
                                                    
                                                    NSString *log = [NSString stringWithFormat:@"InsertDeviceBound response ：%@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]];
                                                    kDebugLog(log);
                                                    
                                                    HomeKit_BooleanResponse *result = [[HomeKit_BooleanResponse alloc] initWithResponseResult:[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]];
                                                    result.responseInfo = [response.URL absoluteString];
                                                    
                                                    if (error) {
                                                        result.httpStatusType = [[HomeKit_HttpManager sharedInstance] httpStatusType:error.code];
                                                    }
                                                    else {
                                                        result.httpStatusType = HttpStatusTypeOK;
                                                        result.success = YES;
                                                    }
                                                    
                                                    ExecuteBlockWithOneParam(pCompletionBlock, result);
                                                }];
    
    [dataTask resume];
}

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
                                completionBlock:(ServiceCompletionBlock)pCompletionBlock
{
    NSDictionary *dicParams = @{
                                @"pId":EmptyString(pId),
                                @"dId":EmptyString(pDID),
                                @"cDId":EmptyString(pCDId),
                                @"sn":EmptyString(pSN),
                                @"platform":EmptyString(pPlatform),
                                @"uId":EmptyString(pUID),
                                @"openId":EmptyString(pOpenID)
                                }
;
    
    NSMutableURLRequest *request = [[HomeKit_HttpManager sharedInstance] reBindingDevice:dicParams];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request
                                                completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
                                                    
                                                    NSString *log = [NSString stringWithFormat:@"ReBindingDevice: %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]];
                                                    kDebugLog(log);
                                                    
                                                    HomeKit_BooleanResponse *result = [[HomeKit_BooleanResponse alloc] initWithResponseResult:[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]];
                                                    result.responseInfo = [response.URL absoluteString];
                                                    
                                                    if (error) {
                                                        result.httpStatusType = [[HomeKit_HttpManager sharedInstance] httpStatusType:error.code];
                                                    }
                                                    else {
                                                        result.httpStatusType = HttpStatusTypeOK;
                                                        result.success = YES;
                                                    }
                                                    
                                                    ExecuteBlockWithOneParam(pCompletionBlock, result);
                                                }];
    
    [dataTask resume];
}

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
                                completionBlock:(ServiceCompletionBlock)pCompletionBlock
{
    NSDictionary *dicParams = @{
                                @"pId":EmptyString(pId),
                                @"openId":EmptyString(pOpenID),
                                @"address":EmptyString(pAddress),
                                @"area":EmptyString(pArea),
                                @"deivceName":EmptyString(pDeivceName)
                                };
    
    NSMutableURLRequest *request = [[HomeKit_HttpManager sharedInstance] updateBoundDeviceAddressArea:dicParams];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request
                                                completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
                                                    
                                                    NSString *log = [NSString stringWithFormat:@"UpdateBoundDeviceAddressArea: %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]];
                                                    kDebugLog(log);
                                                    
                                                    HomeKit_BooleanResponse *result = [[HomeKit_BooleanResponse alloc] initWithResponseResult:[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]];
                                                    result.responseInfo = [response.URL absoluteString];
                                                    
                                                    if (error) {
                                                        result.httpStatusType = [[HomeKit_HttpManager sharedInstance] httpStatusType:error.code];
                                                    }
                                                    else {
                                                        result.httpStatusType = HttpStatusTypeOK;
                                                        result.success = YES;
                                                    }
                                                    
                                                    ExecuteBlockWithOneParam(pCompletionBlock, result);
                                                }];
    
    [dataTask resume];
}


//8 查询用户信息 - 电话号码
//- (NSMutableURLRequest *)searchCustomerInfo:(NSDictionary *)pParams
//{
//    "openId":"oE99w0WnUzGCacmAS5SXqe_iUW20"
//}
- (void)executeRequestForSearchCustomerInfoWithOpenID:(NSString *)pOpenID
                                       completionBlock:(ServiceCompletionBlock)pCompletionBlock
{
    NSDictionary *dicParams = @{
                                @"openId":EmptyString(pOpenID)
                                };
    
    NSMutableURLRequest *request = [[HomeKit_HttpManager sharedInstance] searchCustomerInfo:dicParams];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request
                                                completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
                                                    
                                                    NSString *log = [NSString stringWithFormat:@"SearchCustomerInfo: %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]];
                                                    kDebugLog(log);
                                                    
                                                    HomeKit_BooleanResponse *result = [[HomeKit_BooleanResponse alloc] initForUserInfoWithResponseResult:[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]];
                                                    result.responseInfo = [response.URL absoluteString];
                                                    
                                                    if (error) {
                                                        result.httpStatusType = [[HomeKit_HttpManager sharedInstance] httpStatusType:error.code];
                                                    }
                                                    else {
                                                        result.httpStatusType = HttpStatusTypeOK;
                                                        result.success = YES;
                                                    }
                                                    
                                                    ExecuteBlockWithOneParam(pCompletionBlock, result);
                                                }];
    
    [dataTask resume];
}



//9 保存用户电话号码
//- (NSMutableURLRequest *)saveUserInfoProject:(NSDictionary *)pParams
//{
//    "openId":"oE99w0WnUzGCacmAS5SXqe_iUW20",
//    "phoneNumber":"13654654395"
//}
- (void)executeRequestForSaveUserInfoProjectWithOpenID:(NSString *)pOpenID
                                                     phoneNumber:(NSString *)pPhoneNumber
                                             completionBlock:(ServiceCompletionBlock)pCompletionBlock
{
    NSDictionary *dicParams = @{
                                @"openId":EmptyString(pOpenID),
                                @"phoneNumber":EmptyString(pPhoneNumber)
                                };
    
    NSMutableURLRequest *request = [[HomeKit_HttpManager sharedInstance] saveUserInfoProject:dicParams];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request
                                                completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
                                                    
                                                    NSString *log = [NSString stringWithFormat:@"SaveUserInfo: %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]];
                                                    kDebugLog(log);
                                                    
                                                    HomeKit_BooleanResponse *result = [[HomeKit_BooleanResponse alloc] initWithResponseResult:[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]];
                                                    result.responseInfo = [response.URL absoluteString];
                                                    
                                                    if (error) {
                                                        result.httpStatusType = [[HomeKit_HttpManager sharedInstance] httpStatusType:error.code];
                                                    }
                                                    else {
                                                        result.httpStatusType = HttpStatusTypeOK;
                                                        result.success = YES;
                                                    }
                                                    
                                                    ExecuteBlockWithOneParam(pCompletionBlock, result);
                                                }];
    
    [dataTask resume];
}

//15 由sn换mac
//- (NSMutableURLRequest *)getXlinkDeviceInfoBySn:(NSDictionary *)pParams
- (void)executeRequestForGetXlinkDeviceInfoBySnWithSN:(NSString *)pSN
                                       completionBlock:(ServiceCompletionBlock)pCompletionBlock
{
    NSDictionary *dicParams = @{
                                @"sn":EmptyString(pSN)
                                };
    
    NSMutableURLRequest *request = [[HomeKit_HttpManager sharedInstance] getXlinkDeviceInfoBySn:dicParams];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request
                                                completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
                                                    
                                                    NSString *log = [NSString stringWithFormat:@"GetXlinkDeviceInfoBySn: %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]];
                                                    kDebugLog(log);
                                                    
                                                    HomeKit_StringResponse *result = [[HomeKit_StringResponse alloc] init];
                                                    
                                                    if (error) {
                                                        result.httpStatusType = [[HomeKit_HttpManager sharedInstance] httpStatusType:error.code];
                                                    }
                                                    else {
                                                        result.responseResult = [HomeKit_DeviceConverter convertJSONToXlinkDeviceInfoBySn:responseObject];
                                                        result.httpStatusType = HttpStatusTypeOK;
                                                        result.success = YES;
                                                    }
                                                    
                                                    ExecuteBlockWithOneParam(pCompletionBlock, result);
                                                }];
    
    [dataTask resume];
}

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
                                       completionBlock:(ServiceCompletionBlock)pCompletionBlock
{
    NSDictionary *dicParams = @{
                                @"uid":EmptyString(pUID),
                                @"pId":pPID.length == 0?@"":EmptyString(pPID),
                                @"platform":EmptyString(pPlatform),
                                @"openId":EmptyString(pOpenID),
                                @"deviceType":pDeviceType.length == 0?@"":EmptyString(pDeviceType),
                                @"dId":pDID.length == 0?@"":EmptyString(pDID),
                                @"sendData":EmptyString(pSendData)
                                };
    
    NSMutableURLRequest *request = [[HomeKit_HttpManager sharedInstance] sleepDevice:dicParams];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request
                                                completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
                                                    
                                                    NSString *log = [NSString stringWithFormat:@"SleepDevice: %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]];
                                                    kDebugLog(log);
                                                    
                                                    HomeKit_BooleanResponse *result = [[HomeKit_BooleanResponse alloc] initWithResponseResult:[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]];
                                                    result.responseInfo = [response.URL absoluteString];
                                                    
                                                    if (error) {
                                                        result.httpStatusType = [[HomeKit_HttpManager sharedInstance] httpStatusType:error.code];
                                                    }
                                                    else {
                                                        result.httpStatusType = HttpStatusTypeOK;
                                                        result.success = YES;
                                                    }
                                                    
                                                    ExecuteBlockWithOneParam(pCompletionBlock, result);
                                                }];
    
    [dataTask resume];
}

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
                                   completionBlock:(ServiceCompletionBlock)pCompletionBlock
{
    if(!pPID){
        HomeKit_BooleanResponse *result = [[HomeKit_BooleanResponse alloc] init];
        result.success = NO;
        ExecuteBlockWithOneParam(pCompletionBlock, result);
        return;
    }
    
    NSDictionary *dicParams = @{
                                @"uid":EmptyString(pUID),
                                @"pId":EmptyString(pPID),
                                @"platform":EmptyString(pPlatform),
                                @"openId":EmptyString(pOpenID),
                                @"deviceType":EmptyString(pDeviceType),
                                @"dId":EmptyString(pDID),
                                @"isOpen":EmptyString(pIsOpen)
                                };
    
    NSMutableURLRequest *request = [[HomeKit_HttpManager sharedInstance] openAndCloseFan:dicParams];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request
                                                completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
                                                    
                                                    NSString *log = [NSString stringWithFormat:@"OpenAndCloseFan: %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]];
                                                    kDebugLog(log);
                                                    
                                                    HomeKit_BooleanResponse *result = [[HomeKit_BooleanResponse alloc] initWithResponseResult:[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]];
                                                    result.responseInfo = [response.URL absoluteString];
                                                    
                                                    if (error) {
                                                        result.httpStatusType = [[HomeKit_HttpManager sharedInstance] httpStatusType:error.code];
                                                    }
                                                    else {
                                                        result.httpStatusType = HttpStatusTypeOK;
                                                        result.success = YES;
                                                    }
                                                    
                                                    ExecuteBlockWithOneParam(pCompletionBlock, result);
                                                }];
    
    [dataTask resume];
}

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
                                   completionBlock:(ServiceCompletionBlock)pCompletionBlock
{
    NSDictionary *dicParams = @{
                                @"uid":EmptyString(pUID),
                                @"pId":EmptyString(pPID),
                                @"platform":EmptyString(pPlatform),
                                @"openId":EmptyString(pOpenID),
                                @"deviceType":EmptyString(pDeviceType),
                                @"dId":EmptyString(pDID),
                                @"isOpen":EmptyString(pIsOpen),
                                @"sendData":EmptyString(pSendData)
                                };
    
    NSMutableURLRequest *request = [[HomeKit_HttpManager sharedInstance] openClosePtc:dicParams];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request
                                                completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
                                                    
                                                    NSString *log = [NSString stringWithFormat:@"OpenClosePtc: %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]];
                                                    kDebugLog(log);
                                                    
                                                    HomeKit_BooleanResponse *result = [[HomeKit_BooleanResponse alloc] initWithResponseResult:[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]];
                                                    result.responseInfo = [response.URL absoluteString];
                                                    
                                                    if (error) {
                                                        result.httpStatusType = [[HomeKit_HttpManager sharedInstance] httpStatusType:error.code];
                                                    }
                                                    else {
                                                        result.httpStatusType = HttpStatusTypeOK;
                                                        result.success = YES;
                                                    }
                                                    
                                                    ExecuteBlockWithOneParam(pCompletionBlock, result);
                                                }];
    
    [dataTask resume];
}

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
                                completionBlock:(ServiceCompletionBlock)pCompletionBlock
{
    NSDictionary *dicParams = @{
                                @"uid":EmptyString(pUID),
                                @"pId":EmptyString(pPID),
                                @"platform":EmptyString(pPlatform),
                                @"openId":EmptyString(pOpenID),
                                @"deviceType":EmptyString(pDeviceType),
                                @"dId":EmptyString(pDID),
                                @"sendData":EmptyString(pSendData)
                                };
    
    NSMutableURLRequest *request = [[HomeKit_HttpManager sharedInstance] modifyDeviceScreen:dicParams];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request
                                                completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
                                                    
                                                    NSString *log = [NSString stringWithFormat:@"ModifyDeviceScreen: %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]];
                                                    kDebugLog(log);
                                                    
                                                    HomeKit_BooleanResponse *result = [[HomeKit_BooleanResponse alloc] initWithResponseResult:[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]];
                                                    result.responseInfo = [response.URL absoluteString];
                                                    
                                                    if (error) {
                                                        result.httpStatusType = [[HomeKit_HttpManager sharedInstance] httpStatusType:error.code];
                                                    }
                                                    else {
                                                        result.httpStatusType = HttpStatusTypeOK;
                                                        result.success = YES;
                                                    }
                                                    
                                                    ExecuteBlockWithOneParam(pCompletionBlock, result);
                                                }];
    
    [dataTask resume];
}

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
                                      completionBlock:(ServiceCompletionBlock)pCompletionBlock
{
    NSDictionary *dicParams = @{
                                @"uid":EmptyString(pUID),
                                @"pId":EmptyString(pPID),
                                @"platform":EmptyString(pPlatform),
                                @"openId":EmptyString(pOpenID),
                                @"deviceType":EmptyString(pDeviceType),
                                @"dId":EmptyString(pDID),
                                @"sendData":EmptyString(pSendData),
                                @"minSpeed":EmptyString(pMinSpeed),
                                @"maxSpeed":EmptyString(pMaxSpeed)
                                };
    
    NSMutableURLRequest *request = [[HomeKit_HttpManager sharedInstance] setDeivecSpeed:dicParams];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request
                                                completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
                                                    
                                                    NSString *log = [NSString stringWithFormat:@"SetDeivecSpeed: %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]];
                                                    kDebugLog(log);
                                                    
                                                    HomeKit_BooleanResponse *result = [[HomeKit_BooleanResponse alloc] initWithResponseResult:[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]];
                                                    result.responseInfo = [response.URL absoluteString];
                                                    
                                                    if (error) {
                                                        result.httpStatusType = [[HomeKit_HttpManager sharedInstance] httpStatusType:error.code];
                                                    }
                                                    else {
                                                        result.httpStatusType = HttpStatusTypeOK;
                                                        result.success = YES;
                                                    }
                                                    
                                                    ExecuteBlockWithOneParam(pCompletionBlock, result);
                                                }];
    
    [dataTask resume];
}

//检查是否绑定
//#define kIsDeviceBound @"/ApiServer/ProjectV2/api/DeviceInfo/IsDeviceBoundProjectV2"
//- (NSMutableURLRequest *)isDeviceBound:(NSDictionary *)pParams
- (void)executeRequestForIsDeviceBoundWithPID:(NSString *)pPID
                                  completionBlock:(ServiceCompletionBlock)pCompletionBlock
{
    NSDictionary *dicParams = @{
                                @"pId":EmptyString(pPID)
                                };
    
    NSMutableURLRequest *request = [[HomeKit_HttpManager sharedInstance] isDeviceBound:dicParams];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request
                                                completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
                                                    
                                                    NSString *log = [NSString stringWithFormat:@"IsDeviceBound: %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]];
                                                    kDebugLog(log);
                                                    
                                                    HomeKit_BooleanResponse *result = [[HomeKit_BooleanResponse alloc] initWithResponseResult:[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]];
#warning mark - nedd to delete for moni
//                                                    result.responseResult = NO;
                                                    result.responseInfo = [response.URL absoluteString];
                                                    
                                                    if (error) {
                                                        result.httpStatusType = [[HomeKit_HttpManager sharedInstance] httpStatusType:error.code];
                                                    }
                                                    else {
                                                        result.httpStatusType = HttpStatusTypeOK;
                                                        result.success = YES;
                                                    }
                                                    
                                                    ExecuteBlockWithOneParam(pCompletionBlock, result);
                                                }];
    
    [dataTask resume];
}


@end
