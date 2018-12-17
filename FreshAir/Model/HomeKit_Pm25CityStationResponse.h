//
//  Pm25CityStationResponse.h
//  FreshAir
//
//  Created by mars on 24/02/2018.
//  Copyright © 2018 mars. All rights reserved.
//

#import "HomeKit_ServiceResponse.h"

@class HomeKit_Pm25CityStation;

@interface HomeKit_Pm25CityStationResponse : HomeKit_ServiceResponse

@property (nonatomic, strong) NSMutableArray *maStations;

- (HomeKit_Pm25CityStationResponse *)initWithPm25CityStation:(NSMutableArray *)pMaStations;

@end
