//
//  CustomerAreaStationInfoResponse.h
//  FreshAir
//
//  Created by mars on 24/02/2018.
//  Copyright © 2018 mars. All rights reserved.
//

#import "HomeKit_ServiceResponse.h"

@class HomeKit_CustomerAreaStationInfo;

@interface HomeKit_CustomerAreaStationInfoResponse : HomeKit_ServiceResponse
@property (nonatomic, strong) HomeKit_CustomerAreaStationInfo *customerAreaStationInfo;
- (HomeKit_CustomerAreaStationInfoResponse *)initWithCustomerAreaStationInfo:(HomeKit_CustomerAreaStationInfo *)pCustomerAreaStationInfo;
@end
