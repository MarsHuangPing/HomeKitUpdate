//
//  ServiceResponse.h
//  Peek2
//
//  Created by Tyler on 10/13/14.
//  Copyright (c) 2014 Delaware consulting. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeKit_ServiceResponse : NSObject

@property (nonatomic, assign, readwrite) HttpStatusType httpStatusType;
@property (nonatomic, assign, readwrite) BOOL success;
@property (nonatomic, strong, readwrite) NSMutableArray *errorMessages;

@end
