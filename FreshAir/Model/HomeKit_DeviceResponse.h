//
//  DeviceResponse.h
//  FreshAir
//
//  Created by mars on 29/06/2017.
//  Copyright © 2017 mars. All rights reserved.
//

#import "HomeKit_ServiceResponse.h"

@class HomeKit_DeviceDetailInfo;


@interface HomeKit_DeviceResponse : HomeKit_ServiceResponse

@property (nonatomic, strong, readonly) HomeKit_DeviceDetailInfo *deviceDetailInfo;

- (HomeKit_DeviceResponse *)initWithDeviceDetailInfo:(HomeKit_DeviceDetailInfo *)pDeviceDetailInfo;

@end
