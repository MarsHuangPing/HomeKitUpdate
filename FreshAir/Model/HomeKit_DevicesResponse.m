//
//  DevicesResponse.m
//  FreshAir
//
//  Created by mars on 07/08/2017.
//  Copyright © 2017 mars. All rights reserved.
//

#import "HomeKit_DevicesResponse.h"

@implementation HomeKit_DevicesResponse

- (HomeKit_DevicesResponse *)initWithDevices:(NSMutableArray *)pDevices
{
    if(self = [super init]){
        _devices = pDevices;
    }
    return self;
}


@end
