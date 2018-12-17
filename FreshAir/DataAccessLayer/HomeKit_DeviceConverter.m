//
//  CategoryConverter.m
//  NewPeek2
//
//  Created by Tyler on 13-4-1.
//  Copyright (c) 2013年 Delaware consulting. All rights reserved.
//

#import "HomeKit_DeviceConverter.h"

#import "NSObject+ML.h"
#import "NSString+ML.h"

#import "HomeKit_DeviceResponse.h"
#import "HomeKit_Device.h"

#import "HomeKit_Pm25CityStation.h"
#import "HomeKit_WatchInfoOutdoor.h"

#import "HomeKit_SplashAD.h"
#import "HistoryInfo.h"
#import "XLinkDevice.h"

@implementation HomeKit_DeviceConverter

+ (HomeKit_DeviceResponse *)parseJsonForDevicesWithDic:(NSDictionary *)pDic
{
//    DeviceResponse *result = [[DeviceResponse alloc] initWithDevice:[self convertArrayToDevices:pDic[@"Value"]]];
//    result.success = [pDic[@"IsSuccess"] ml_boolValue];
//    
//    return result;
    return nil;
}

#pragma mark - splash advertisement

+ (HomeKit_SplashAD *)convertDataToSplashAdInfo:(NSData *)pJsonData
{
    
    NSDictionary *dicRoot = [NSJSONSerialization JSONObjectWithData:pJsonData
                                                            options:NSJSONReadingMutableContainers
                                                              error:nil];
    if (CheckNilAndNull(dicRoot)) {
        return nil;
    }
    HomeKit_SplashAD *splashAD = [[HomeKit_SplashAD alloc] initWithDisplay:[dicRoot[@"IsShow"] ml_boolValue]
                                                      desc:@""
                                                       key:[dicRoot[@"Key"] ml_stringValue]
                                                  photoURL:[dicRoot[@"ImageUrl"] ml_stringValue]
                                                      link:[dicRoot[@"JumpUrl"] ml_stringValue]
                                                      size:[dicRoot[@"Size"] ml_stringValue]
                                                downloaded:NO];
    
    return splashAD;
}

+ (HomeKit_WatchInfoOutdoor *)convertJSONToWatchInfoOutdoor:(NSData *)pJSON
{
    if (pJSON.length == 0) {
        return nil;
    }
    NSDictionary *dicRoot = [NSJSONSerialization JSONObjectWithData:pJSON
                                                            options:NSJSONReadingAllowFragments
                                                              error:nil];
    if(!dicRoot){
        return nil;
    }
    
    NSString *test = [NSString stringWithFormat:@"%@", dicRoot];
    if([test containsString:@"<null>"] && test.length < 20){
        return nil;
    }
    
    
    HomeKit_WatchInfoOutdoor *watchInfoOutdoor = [[HomeKit_WatchInfoOutdoor alloc] initWithOpenId:[dicRoot[@"OpenId"] ml_stringValue]
                                                                     customerArea:[dicRoot[@"CustomerArea"] ml_stringValue]
                                                                       deviceArea:[dicRoot[@"DeviceArea"] ml_stringValue]
                                                                     positionName:[dicRoot[@"PositionName"] ml_stringValue]
                                                                      stationCode:[dicRoot[@"StationCode"] ml_stringValue]
                                                                         deviceId:[dicRoot[@"DeviceId"] ml_stringValue]
                                                                        timestamp:[dicRoot[@"Timestamp"] ml_stringValue]
                                                                            value:[dicRoot[@"Value"] integerValue]
                                                                              aqi:[dicRoot[@"Aqi"] integerValue]];
    return watchInfoOutdoor;
}

//10 设备7天数据比对
+ (NSMutableArray *)convertJSONToHistories:(NSData *)pJSON
{
    
    if (pJSON.length == 0) {
        return nil;
    }
    
    __block NSMutableArray *result = [NSMutableArray array];
    
    NSDictionary *dicRoot = [self convertJsonToObject:pJSON];
    
    NSArray *arrRoot = dicRoot[@"objects"];
    
    [arrRoot enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *dicHistoryInfo = obj;
        
        HistoryInfo *historyInfo = [[HistoryInfo alloc] initWithDate:[dicHistoryInfo[@"date"] ml_date]
                                                          indoorPm25:[dicHistoryInfo[@"indoorPm25"] integerValue]
                                                         outdoorPm25:[dicHistoryInfo[@"outdoorPm25"] integerValue]];
        
        [result addObject:historyInfo];
    }];
    
    return result;
}

//7 查询城市 监测站
+ (NSMutableArray *)convertJSONToStations:(NSData *)pJSON
{
    
    if (pJSON.length == 0) {
        return nil;
    }
    
    __block NSMutableArray *result = [NSMutableArray array];
    
    NSArray *arrRoot = [self convertJsonToObject:pJSON];
    
    [arrRoot enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *dicStation = obj;
        HomeKit_Pm25CityStation *pm25CityStation = [[HomeKit_Pm25CityStation alloc] initWithStationCode:[dicStation[@"StationCode"] ml_stringValue]
                                                                           positionName:[dicStation[@"PositionName"] ml_stringValue]
                                                                                   area:[dicStation[@"Area"] ml_stringValue]];
        
        [result addObject:pm25CityStation];
    }];
    
    return result;
}

//6 查询周边城市
+ (NSMutableArray *)convertJSONToNearCities:(NSData *)pJSON
{
    
    if (pJSON.length == 0) {
        return nil;
    }
    
    __block NSMutableArray *result = [NSMutableArray array];
    
    NSDictionary *dicRoot = [self convertJsonToObject:pJSON];
    
    NSArray *arrRoot = dicRoot[@"areas"];
    [arrRoot enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [result addObject:obj];
    }];
    
    return result;
}

+ (NSMutableArray *)convertJSONToDevices:(NSData *)pJSON
{
    NSMutableArray *result = [NSMutableArray array];
    
    NSArray *arrRoot = [self convertJsonToObject:pJSON];
    
    [arrRoot enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *dicCategory = obj;
        
        HomeKit_Device *device = [self convertDictionaryToDevice:dicCategory];

        [result addObject:device];
    }];
    
    return result;
}

+ (HomeKit_Device *)convertDictionaryToDevice:(NSDictionary *)pDic
{
    if (CheckNilAndNull(pDic)) {
        return nil;
    }
    

    
    return nil;
}

+ (NSMutableArray *)convertArrayToDevices:(NSArray *)pArr
{
    if (CheckNilAndNull(pArr)) {
        return nil;
    }
    
    NSMutableArray *result= [NSMutableArray array];
    
    [pArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *dic = (NSDictionary *)obj;
        
        HomeKit_Device *device = [self convertDictionaryToDevice:dic];
        
        if (device != nil) {
            [result addObject:device];
        }
    }];
    
    return result;
}

#pragma mark - xLink service
//1 通过uId获取设备列表
+ (NSMutableArray *)convertJSONToXLinkDevices:(NSData *)pJSON
{
    
    if (pJSON.length == 0) {
        return nil;
    }
    
    __block NSMutableArray *result = [NSMutableArray array];
    
    NSDictionary *dicRoot = [self convertJsonToObject:pJSON];
    
    NSArray *arrRoot = dicRoot[@"UserAllAbleDevices"];
    [arrRoot enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [result addObject:[self dicToXLinkDeviceWithDic:(NSDictionary *)obj]];
    }];
    
    return result;
}

+ (XLinkDevice *)dicToXLinkDeviceWithDic:(NSDictionary *)pDicDevice
{
    XLinkDevice *device = nil;
    
    device = [[XLinkDevice alloc] initWithDeviceID:[pDicDevice[@"DeviceId"] ml_stringValue]
                                              name:[pDicDevice[@"Name"] ml_stringValue]
                                  physicalDeviceId:[pDicDevice[@"PhysicalDeviceId"] ml_stringValue]
                                          platform:[pDicDevice[@"Platform"] ml_stringValue]
                                       product_key:[pDicDevice[@"Product_Key"] ml_stringValue]];
    
    return device;
}

+ (XLinkDevice *)convertJSONToEnhanceXLinkDevices:(NSData *)pJSON XLinkDevice:(XLinkDevice *)pXLinkDevice
{
    
    if (pJSON.length == 0) {
        return pXLinkDevice;
    }
    
    
    NSDictionary *dicRoot = [self convertJsonToObject:pJSON];
    
    [pXLinkDevice enhanceWithFanControl:[dicRoot[@"FanControl"] ml_stringValue]
                               SSIValue:[dicRoot[@"RSSIValue"] ml_stringValue]
                          screenControl:[dicRoot[@"ScreenControl"] ml_stringValue]
                       screenDimmingSet:[dicRoot[@"ScreenDimmingSet"] ml_stringValue]
                       fanAirflowStatus:[dicRoot[@"FanAirflowStatus"] ml_stringValue]
                          fanAirflowMax:[dicRoot[@"FanAirflowMax"] ml_stringValue]
                          fanAirflowMin:[dicRoot[@"FanAirflowMin"] ml_stringValue]
                      indoorTemperature:[dicRoot[@"IndoorTemperature"] ml_stringValue]
                         indoorHumidity:[dicRoot[@"IndoorHumidity"] ml_stringValue]
                               PM25Data:[dicRoot[@"PM25Data"] ml_stringValue]
                                CO2Data:[dicRoot[@"CO2Data"] ml_stringValue]
                               PM03Data:[dicRoot[@"PM03Data"] ml_stringValue]
                              PTCStatus:[dicRoot[@"PTCStatus"] ml_stringValue]
                               deviceID:[dicRoot[@"DeviceID"] ml_stringValue]
                                    cid:[dicRoot[@"Cid"] ml_stringValue]
                              sleepMode:[dicRoot[@"SleepMode"] ml_stringValue]
                            targetState:[dicRoot[@"TargetState"] ml_stringValue]
                             airQuality:[dicRoot[@"AirQuality"] ml_stringValue]];
    
    
    
    return pXLinkDevice;
}

//15 由sn换mac
+ (NSString *)convertJSONToXlinkDeviceInfoBySn:(NSData *)pJSON
{
    
    if (pJSON.length == 0) {
        return nil;
    }
    
    NSDictionary *dicRoot = [self convertJsonToObject:pJSON];
    if (CheckNilAndNull(dicRoot)) {
        return nil;
    }
    
    if (CheckNilAndNull(dicRoot[@"Mac"])) {
        return nil;
    }
    
    return [dicRoot[@"Mac"] ml_stringValue];
}

@end
