//
//  WatchInfoOutdoor.m
//  FreshAir
//
//  Created by mars on 11/02/2018.
//  Copyright © 2018 mars. All rights reserved.
//

#import "HomeKit_WatchInfoOutdoor.h"

#import "HomeKit_CustomerAreaStationInfo.h"

@implementation HomeKit_WatchInfoOutdoor

- (HomeKit_WatchInfoOutdoor *)initWithOpenId:(NSString *)pOpenId
                        customerArea:(NSString *)pCustomerArea
                          deviceArea:(NSString *)pDeviceArea
                        positionName:(NSString *)pPositionName
                         stationCode:(NSString *)pStationCode
                            deviceId:(NSString *)pDeviceId
                           timestamp:(NSString *)pTimestamp
                               value:(NSInteger)pValue
                                 aqi:(NSInteger)pAqi
{
    if(self = [super init]){
        _openId = pOpenId;
        _customerArea = pCustomerArea;
        _deviceArea = pDeviceId;
        _positionName = pPositionName;
        _stationCode = pStationCode;
        _deviceId = pDeviceId;
        _timestamp = pTimestamp;
        _value = pValue;
        _aqi = pAqi;
    }
    return self;
}

- (HomeKit_CustomerAreaStationInfo *)toCustomerAreaStationInfo
{
    return [[HomeKit_CustomerAreaStationInfo alloc] initWithArea:self.deviceArea positionName:self.positionName stationCode:self.stationCode openId:nil];
}

@end
