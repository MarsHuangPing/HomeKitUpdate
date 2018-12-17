//
//  StringResponse.m
//  FreshAir
//
//  Created by mars on 2018/5/3.
//  Copyright © 2018 mars. All rights reserved.
//

#import "HomeKit_StringResponse.h"

@implementation HomeKit_StringResponse
- (HomeKit_StringResponse *)initWithResponseResult:(NSString *)pResponseResult
{
    if(self = [super init]){
        _responseResult = pResponseResult;
    }
    return self;
}
@end
