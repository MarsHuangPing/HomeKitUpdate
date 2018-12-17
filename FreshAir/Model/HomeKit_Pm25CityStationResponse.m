//
//  Pm25CityStationResponse.m
//  FreshAir
//
//  Created by mars on 24/02/2018.
//  Copyright © 2018 mars. All rights reserved.
//

#import "HomeKit_Pm25CityStationResponse.h"

#import "HomeKit_Pm25CityStation.h"

@implementation HomeKit_Pm25CityStationResponse

- (HomeKit_Pm25CityStationResponse *)initWithPm25CityStation:(NSMutableArray *)pMaStations
{
    if(self = [super init]){
        _maStations = pMaStations;
    }
    return self;
}

@end
