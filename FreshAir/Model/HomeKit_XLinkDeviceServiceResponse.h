//
//  HomeKit_XLinkDeviceServiceResponse.h
//  FreshAir
//
//  Created by mars on 2018/8/25.
//  Copyright © 2018 mars. All rights reserved.
//

#import "HomeKit_ServiceResponse.h"
#import "XLinkDevice.h"


@interface HomeKit_XLinkDeviceServiceResponse : HomeKit_ServiceResponse

@property (nonatomic, strong) XLinkDevice *XLinkDevice;
- (HomeKit_XLinkDeviceServiceResponse *)initWithXLinkDevice:(XLinkDevice *)pXLinkDevice;

@end
