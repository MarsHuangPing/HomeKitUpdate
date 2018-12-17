//
//  DeviceDetailInfo.h
//  FreshAir
//
//  Created by mars on 09/08/2017.
//  Copyright © 2017 mars. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HomeKit_Device, HomeKit_History;

@interface HomeKit_DeviceDetailInfo : NSObject

@property (nonatomic, strong) HomeKit_Device *device;
@property (nonatomic, strong) HomeKit_History *todayInfo;
@property (nonatomic, strong) NSMutableArray *histoies;

- (HomeKit_DeviceDetailInfo *)initWithDevice:(HomeKit_Device *)pDevice todayInfo:(HomeKit_History *)pTodayInfo histories:(NSMutableArray *)pHistories;

@end
