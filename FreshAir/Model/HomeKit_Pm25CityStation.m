//
//  Pm25CityStation.m
//  FreshAir
//
//  Created by mars on 24/02/2018.
//  Copyright © 2018 mars. All rights reserved.
//

#import "HomeKit_Pm25CityStation.h"

@implementation HomeKit_Pm25CityStation

- (HomeKit_Pm25CityStation *)initWithStationCode:(NSString *)pStationCode
                            positionName:(NSString *)pPositionName
                                    area:(NSString *)pArea
{
    if(self = [super init]){
        _stationCode = pStationCode;
        _positionName = pPositionName;
        _area = pArea;
    }
    return self;
}

@end
