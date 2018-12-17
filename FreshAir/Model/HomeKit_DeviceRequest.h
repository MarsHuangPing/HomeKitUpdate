//
//  DeviceRequest.h
//  FreshAir
//
//  Created by mars on 29/06/2017.
//  Copyright © 2017 mars. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HomeKit_DeviceRequest : NSObject

@property (nonatomic, strong, readonly) NSString *deviceID;

- (HomeKit_DeviceRequest *)initWithDeviceID:(NSString *)pDeviceID;

@end
