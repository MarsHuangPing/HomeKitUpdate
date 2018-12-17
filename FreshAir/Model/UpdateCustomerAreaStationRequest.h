//
//  UpdateCustomerAreaStationRequest.h
//  FreshAir
//
//  Created by mars on 27/02/2018.
//  Copyright © 2018 mars. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CustomerAreaStationInfo;


@interface UpdateCustomerAreaStationRequest : NSObject

@property (nonatomic, strong) CustomerAreaStationInfo *customerAreaStationInfo;

- (UpdateCustomerAreaStationRequest *)initWithCustomerAreaStationInfo:(CustomerAreaStationInfo *)pCustomerAreaStationInfo;

@end
