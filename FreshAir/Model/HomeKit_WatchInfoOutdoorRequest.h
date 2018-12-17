//
//  WatchInfoOutdoorRequest.h
//  FreshAir
//
//  Created by mars on 11/02/2018.
//  Copyright © 2018 mars. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeKit_WatchInfoOutdoorRequest : NSObject

@property (nonatomic, strong) NSString *cityName;
@property (nonatomic, strong) NSString *stationCode;
@property (nonatomic, strong) NSString *stationName;

- (HomeKit_WatchInfoOutdoorRequest *)initWithCityName:(NSString *)pCityName stationCode:(NSString *)pStationCode stationName:(NSString *)pStationName;

@end
