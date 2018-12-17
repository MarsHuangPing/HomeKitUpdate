//
//  DeviceResponse.m
//  FreshAir
//
//  Created by mars on 29/06/2017.
//  Copyright © 2017 mars. All rights reserved.
//

#import "HomeKit_DeviceResponse.h"

#import "HomeKit_DeviceDetailInfo.h"

@implementation HomeKit_DeviceResponse

- (HomeKit_DeviceResponse *)initWithDeviceDetailInfo:(HomeKit_DeviceDetailInfo *)pDeviceDetailInfo
{
    if(self = [super init]){
        _deviceDetailInfo = pDeviceDetailInfo;
    }
    return self;
}

@end
