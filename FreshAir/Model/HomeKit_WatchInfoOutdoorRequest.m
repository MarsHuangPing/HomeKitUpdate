//
//  WatchInfoOutdoorRequest.m
//  FreshAir
//
//  Created by mars on 11/02/2018.
//  Copyright © 2018 mars. All rights reserved.
//

#import "HomeKit_WatchInfoOutdoorRequest.h"

@implementation HomeKit_WatchInfoOutdoorRequest

- (HomeKit_WatchInfoOutdoorRequest *)initWithCityName:(NSString *)pCityName stationCode:(NSString *)pStationCode stationName:(NSString *)pStationName
{
    if(self = [super init]){
        _cityName = pCityName;
        _stationCode = pStationCode;
        _stationName = pStationName;
    }
    return self;
}

@end
