//
//  BaseConverter.h
//  NewPeek2
//
//  Created by Tyler on 7/24/13.
//  Copyright (c) 2013 Delaware consulting. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeKit_BaseConverter : NSObject

+ (id)convertJsonToObject:(NSData *)pJson;

@end
