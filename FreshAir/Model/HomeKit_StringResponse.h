//
//  StringResponse.h
//  FreshAir
//
//  Created by mars on 2018/5/3.
//  Copyright © 2018 mars. All rights reserved.
//

#import "HomeKit_ServiceResponse.h"

@interface HomeKit_StringResponse : HomeKit_ServiceResponse
@property (nonatomic, strong) NSString *responseResult;

- (HomeKit_StringResponse *)initWithResponseResult:(NSString *)pResponseResult;
@end
