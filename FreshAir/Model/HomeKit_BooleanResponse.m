//
//  BooleanResponse.m
//  FreshAir
//
//  Created by mars on 2018/4/28.
//  Copyright © 2018 mars. All rights reserved.
//

#import "HomeKit_BooleanResponse.h"

@implementation HomeKit_BooleanResponse
- (HomeKit_BooleanResponse *)initWithResponseResult:(NSString *)pResponseResult
{
    if(self = [super init]){
        _responseResult = [[pResponseResult lowercaseString] isEqualToString:@"true"] || [[pResponseResult stringByReplacingOccurrencesOfString:@"\"" withString:@""] isEqualToString:@"ok"] || [[pResponseResult lowercaseString] containsString:@"true"] ? YES : NO;
    }
    return self;
}

- (HomeKit_BooleanResponse *)initForUserInfoWithResponseResult:(NSString *)pResponseResult
{
    if(self = [super init]){
        _responseResult = [[pResponseResult lowercaseString] containsString:@"phonenumber"] ? YES : NO;
    }
    return self;
}

@end
