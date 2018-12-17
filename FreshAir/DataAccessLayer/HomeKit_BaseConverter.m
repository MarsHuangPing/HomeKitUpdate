//
//  BaseConverter.m
//  NewPeek2
//
//  Created by Tyler on 7/24/13.
//  Copyright (c) 2013 Delaware consulting. All rights reserved.
//

#import "HomeKit_BaseConverter.h"

@implementation HomeKit_BaseConverter

+ (id)convertJsonToObject:(NSData *)pJson
{
    if (pJson.length == 0) {
        return nil;
    }
    
    return [NSJSONSerialization JSONObjectWithData:pJson
                                           options:NSJSONReadingMutableContainers
                                             error:nil];
}

@end
