//
//  CustomerAreaStationInfoRequest.m
//  FreshAir
//
//  Created by mars on 24/02/2018.
//  Copyright © 2018 mars. All rights reserved.
//

#import "HomeKit_CustomerAreaStationInfoRequest.h"

@implementation HomeKit_CustomerAreaStationInfoRequest
- (HomeKit_CustomerAreaStationInfoRequest *)initWithOpenId:(NSString *)pOpenId
{
    if(self = [super init]){
        _openId = pOpenId;
    }
    return self;
}
@end
