//
//  UpdateCustomerAreaStationRequest.m
//  FreshAir
//
//  Created by mars on 27/02/2018.
//  Copyright © 2018 mars. All rights reserved.
//

#import "UpdateCustomerAreaStationRequest.h"



@implementation UpdateCustomerAreaStationRequest

- (UpdateCustomerAreaStationRequest *)initWithCustomerAreaStationInfo:(CustomerAreaStationInfo *)pCustomerAreaStationInfo
{
    if(self = [super init]){
        _customerAreaStationInfo = pCustomerAreaStationInfo;
    }
    return self;
}

@end
