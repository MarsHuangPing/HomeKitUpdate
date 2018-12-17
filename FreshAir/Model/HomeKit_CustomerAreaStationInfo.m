//
//  CustomerAreaStationInfo.m
//  FreshAir
//
//  Created by mars on 24/02/2018.
//  Copyright © 2018 mars. All rights reserved.
//

#import "HomeKit_CustomerAreaStationInfo.h"

@implementation HomeKit_CustomerAreaStationInfo

- (HomeKit_CustomerAreaStationInfo *)initWithArea:(NSString *)pArea
                             positionName:(NSString *)pPositionName
                              stationCode:(NSString *)pStationCode
                                   openId:(NSString *)pOpenId
{
    if(self = [super init]){
        _area = pArea;
        _positionName = pPositionName;
        _stationCode = pStationCode;
        _openId = pOpenId;
    }
    return self;
}

@end
