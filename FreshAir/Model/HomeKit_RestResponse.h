//
//  RestResponse.h
//  NewPeek2
//
//  Created by Tyler on 9/29/13.
//  Copyright (c) 2013 Delaware consulting. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeKit_RestResponse : NSObject

@property (nonatomic, assign, readonly) int errorCode;
@property (nonatomic, strong, readonly) NSString *errorMessage;

- (HomeKit_RestResponse *)initWithErrorCode:(int)pErrorCode
                       errorMessage:(NSString *)pErrorMessage;

@end
