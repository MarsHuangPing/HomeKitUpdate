//
//  AdverResponse.m
//  FreshAir
//
//  Created by mars on 10/07/2017.
//  Copyright © 2017 mars. All rights reserved.
//

#import "HomeKit_AdverResponse.h"
#import "HomeKit_Adver.h"

@implementation HomeKit_AdverResponse

- (HomeKit_AdverResponse *)initWithAdver:(HomeKit_Adver *)pAdver
{
    if(self = [super init]){
        _adver = pAdver;
    }
    return self;
}

@end
