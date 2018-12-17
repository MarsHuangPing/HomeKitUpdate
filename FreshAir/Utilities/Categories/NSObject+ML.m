//
//  NSObject+ML.m
//  Panos
//
//  Created by Tyler on 12-11-22.
//  Copyright (c) 2012年 Delaware consulting. All rights reserved.
//

#import "NSObject+ML.h"

@implementation NSObject (ML)

- (BOOL)ml_boolValue
{
    BOOL result = NO;
    
    if (self != [NSNull null]) {
        result = [(NSString *)self boolValue];
    }
    
    return result;
}

- (NSString *)ml_stringValue
{
    NSString *result = nil;
    
    if (self != [NSNull null]) {
        result = (NSString *)self;
    }
    
    return result;
}

- (float)ml_floatValue
{
    float result = 0.0;
    
    if (self != [NSNull null]) {
        result = [(NSNumber *)self floatValue];
    }
    
    return result;
}

- (double)ml_doubleValue
{
    double result = 0.0;
    
    if (self != [NSNull null]) {
        result = [(NSNumber *)self doubleValue];
    }
    
    return result;
}

- (int)ml_intValue
{
    int result = 0;
    
    if (self != [NSNull null]) {
        result = [(NSNumber *)self intValue];
    }
    
    return result;
}

- (int)ml_u8IntValue
{
    int result = 0;
    
    if (self != [NSNull null]) {
        result = [(NSNumber *)self intValue];
    }
    
    return result;
}

- (NSMutableArray *)ml_mutableArray
{
    NSMutableArray *result = nil;
    
    if (self != [NSNull null]) {
        result = [NSMutableArray arrayWithArray:(NSArray *)self];
    }
    
    return result;
}

- (NSDate *)ml_date
{
    NSDate *result = nil;
    
    if (self != [NSNull null]) {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyy-MM-dd"];
        
        result = [df dateFromString:(NSString *)self];
    }
    
    return result;
}


@end
