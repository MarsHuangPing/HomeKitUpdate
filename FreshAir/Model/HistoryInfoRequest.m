//
//  HistoryInfoRequest.m
//  FreshAir
//
//  Created by mars on 25/02/2018.
//  Copyright © 2018 mars. All rights reserved.
//

#import "HistoryInfoRequest.h"

@implementation HistoryInfoRequest

- (HistoryInfoRequest *)initWithArea:(NSString *)pArea
                    physicalDeviceId:(NSString *)pPhysicalDeviceId
                              openId:(NSString *)pOpenId
{
    if(self = [super init]){
        _area = pArea;
        _physicalDeviceId = pPhysicalDeviceId;
        _openId = pOpenId;
    }
    return self;
}

@end
