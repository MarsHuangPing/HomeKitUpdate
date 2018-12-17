//
//  DeviceRequest.m
//  FreshAir
//
//  Created by mars on 29/06/2017.
//  Copyright © 2017 mars. All rights reserved.
//

#import "HomeKit_DeviceRequest.h"


@implementation HomeKit_DeviceRequest

- (HomeKit_DeviceRequest *)initWithDeviceID:(NSString *)pDeviceID
{
    if(self = [super init]){
        _deviceID = pDeviceID;
    }
    return self;
}

@end
