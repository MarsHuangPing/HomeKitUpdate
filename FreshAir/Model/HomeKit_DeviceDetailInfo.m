//
//  DeviceDetailInfo.m
//  FreshAir
//
//  Created by mars on 09/08/2017.
//  Copyright © 2017 mars. All rights reserved.
//

#import "HomeKit_DeviceDetailInfo.h"



@implementation HomeKit_DeviceDetailInfo

- (HomeKit_DeviceDetailInfo *)initWithDevice:(HomeKit_Device *)pDevice todayInfo:(HomeKit_History *)pTodayInfo histories:(NSMutableArray *)pHistories
{
    if(self = [super init]){
        _device = pDevice;
        _todayInfo = pTodayInfo;
        _histoies = pHistories;
    }
    return self;
}

@end
