//
//  WatchInfoOutdoorResponse.m
//  FreshAir
//
//  Created by mars on 11/02/2018.
//  Copyright © 2018 mars. All rights reserved.
//

#import "HomeKit_WatchInfoOutdoorResponse.h"

@implementation HomeKit_WatchInfoOutdoorResponse

- (HomeKit_WatchInfoOutdoorResponse *)initWithDevices:(HomeKit_WatchInfoOutdoor *)pWatchInfoOutdoor
{
    if(self = [super init]){
        _watchInfoOutdoor = pWatchInfoOutdoor;
    }
    return self;
}

@end
