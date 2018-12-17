//
//  CustomerAreaStationInfoResponse.m
//  FreshAir
//
//  Created by mars on 24/02/2018.
//  Copyright © 2018 mars. All rights reserved.
//

#import "HomeKit_CustomerAreaStationInfoResponse.h"

@implementation HomeKit_CustomerAreaStationInfoResponse
- (HomeKit_CustomerAreaStationInfoResponse *)initWithCustomerAreaStationInfo:(HomeKit_CustomerAreaStationInfo *)pCustomerAreaStationInfo
{
    if(self = [super init]){
        _customerAreaStationInfo = pCustomerAreaStationInfo;
    }
    return self;
}
@end
