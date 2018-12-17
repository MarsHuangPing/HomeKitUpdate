//
//  RestResponse.m
//  NewPeek2
//
//  Created by Tyler on 9/29/13.
//  Copyright (c) 2013 Delaware consulting. All rights reserved.
//

#import "HomeKit_RestResponse.h"

@implementation HomeKit_RestResponse

- (HomeKit_RestResponse *)initWithErrorCode:(int)pErrorCode
                       errorMessage:(NSString *)pErrorMessage
{
    if (self = [super init]) {
        _errorCode = pErrorCode;
        _errorMessage = pErrorMessage;
    }
    
    return self;
}

@end
