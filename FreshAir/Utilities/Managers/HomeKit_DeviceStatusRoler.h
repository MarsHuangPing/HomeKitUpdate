//
//  DeviceStatusRoler.h
//  DDD
//
//  Created by mars on 2018/6/27.
//  Copyright © 2018 mars. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface HomeKit_DeviceStatusRoler : NSObject

+ (HomeKit_DeviceStatusRoler *)sharedInstance;

- (void)cleanDevices;

- (void)updateDeviceStatusWithKey:(NSString *)pKey
           deviceConnectionStatus:(DeviceConnectionStatus)pDeviceConnectionStatus
                             from:(NSString *)pFrom;

- (DeviceStatus)checkDeviceStatusWithKey:(NSString *)pKey
                                co2Value:(NSInteger)pCo2Value
                                 pmValue:(NSInteger)pPmValue
                                humidity:(NSInteger)pHumidity
                               reachable:(BOOL)pReachable;

@end
