//
//  AdverResponse.h
//  FreshAir
//
//  Created by mars on 10/07/2017.
//  Copyright © 2017 mars. All rights reserved.
//

#import "HomeKit_ServiceResponse.h"

@class HomeKit_Adver;

@interface HomeKit_AdverResponse : HomeKit_ServiceResponse

@property (nonatomic, strong, readonly) HomeKit_Adver *adver;

- (HomeKit_AdverResponse *)initWithAdver:(HomeKit_Adver *)pAdver;

@end
