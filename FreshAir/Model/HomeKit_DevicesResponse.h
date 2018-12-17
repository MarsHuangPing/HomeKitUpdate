//
//  DevicesResponse.h
//  FreshAir
//
//  Created by mars on 07/08/2017.
//  Copyright © 2017 mars. All rights reserved.
//

#import "HomeKit_ServiceResponse.h"

@interface HomeKit_DevicesResponse : HomeKit_ServiceResponse

@property (nonatomic, strong, readonly) NSMutableArray *devices;
- (HomeKit_DevicesResponse *)initWithDevices:(NSMutableArray *)pDevices;

@end
