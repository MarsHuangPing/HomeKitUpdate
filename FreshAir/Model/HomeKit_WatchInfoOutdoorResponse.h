//
//  WatchInfoOutdoorResponse.h
//  FreshAir
//
//  Created by mars on 11/02/2018.
//  Copyright © 2018 mars. All rights reserved.
//

#import "HomeKit_ServiceResponse.h"

@class HomeKit_WatchInfoOutdoor;

@interface HomeKit_WatchInfoOutdoorResponse : HomeKit_ServiceResponse

@property (nonatomic, strong) HomeKit_WatchInfoOutdoor *watchInfoOutdoor;
- (HomeKit_WatchInfoOutdoorResponse *)initWithDevices:(HomeKit_WatchInfoOutdoor *)pWatchInfoOutdoor;

@end
