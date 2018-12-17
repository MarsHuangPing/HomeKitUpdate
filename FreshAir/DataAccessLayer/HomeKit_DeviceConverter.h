//
//  CategoryConverter.h
//  NewPeek2
//
//  Created by Tyler on 13-4-1.
//  Copyright (c) 2013年 Delaware consulting. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HomeKit_BaseConverter.h"

@class HomeKit_DeviceResponse;
@class HomeKit_Device;
@class HomeKit_WatchInfoOutdoor;
@class HomeKit_SplashAD;
@class XLinkDevice;
@class HistoryInfo;

@interface HomeKit_DeviceConverter : HomeKit_BaseConverter

#pragma mark - splash advertisement
+ (HomeKit_SplashAD *)convertDataToSplashAdInfo:(NSData *)pJsonData;

+ (HomeKit_DeviceResponse *)parseJsonForDevicesWithDic:(NSDictionary *)pDic;

+ (NSMutableArray *)convertJSONToDevices:(NSData *)pJSON;

+ (HomeKit_Device *)convertDictionaryToDevice:(NSDictionary *)pDic;

+ (NSMutableArray *)convertArrayToDevices:(NSArray *)pArr;

//10 设备7天数据比对
+ (NSMutableArray *)convertJSONToHistories:(NSData *)pJSON;

//7 查询城市 监测站
+ (NSMutableArray *)convertJSONToStations:(NSData *)pJSON;
//6 查询周边城市
+ (NSMutableArray *)convertJSONToNearCities:(NSData *)pJSON;
+ (HomeKit_WatchInfoOutdoor *)convertJSONToWatchInfoOutdoor:(NSData *)pJSON;

//15 由sn换mac
+ (NSString *)convertJSONToXlinkDeviceInfoBySn:(NSData *)pJSON;

#pragma mark - xLink service
//1 通过uId获取设备列表
+ (NSMutableArray *)convertJSONToXLinkDevices:(NSData *)pJSON;
+ (XLinkDevice *)convertJSONToEnhanceXLinkDevices:(NSData *)pJSON XLinkDevice:(XLinkDevice *)pXLinkDevice;

@end
