//
//  HomeKit_XLinkDeviceServiceResponse.m
//  FreshAir
//
//  Created by mars on 2018/8/25.
//  Copyright © 2018 mars. All rights reserved.
//

#import "HomeKit_XLinkDeviceServiceResponse.h"

@implementation HomeKit_XLinkDeviceServiceResponse

- (HomeKit_XLinkDeviceServiceResponse *)initWithXLinkDevice:(XLinkDevice *)pXLinkDevice
{
    if(self = [super init]){
        _XLinkDevice = pXLinkDevice;
    }
    return self;
}

@end
