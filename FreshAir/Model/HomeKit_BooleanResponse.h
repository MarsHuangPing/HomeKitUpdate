//
//  BooleanResponse.h
//  FreshAir
//
//  Created by mars on 2018/4/28.
//  Copyright © 2018 mars. All rights reserved.
//

#import "HomeKit_ServiceResponse.h"

@interface HomeKit_BooleanResponse : HomeKit_ServiceResponse
@property (nonatomic, assign) BOOL responseResult;
@property (nonatomic, strong) NSString *responseInfo;

- (HomeKit_BooleanResponse *)initWithResponseResult:(NSString *)pResponseResult;
- (HomeKit_BooleanResponse *)initForUserInfoWithResponseResult:(NSString *)pResponseResult;
@end
