//
//  DevicesRequest.m
//  FreshAir
//
//  Created by mars on 07/08/2017.
//  Copyright © 2017 mars. All rights reserved.
//

#import "HomeKit_DevicesRequest.h"
#import "HomeKit_User.h"

@implementation HomeKit_DevicesRequest
- (HomeKit_DevicesRequest *)initWithUser:(HomeKit_User *)pUser
{
    if(self = [super init]){
        _user = pUser;
    }
    return self;
}

@end
