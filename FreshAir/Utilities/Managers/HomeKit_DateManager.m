//
//  DateManager.m
//  NewPeek2
//
//  Created by Tyler on 6/17/13.
//  Copyright (c) 2013 Delaware consulting. All rights reserved.
//

#import "HomeKit_DateManager.h"

@implementation HomeKit_DateManager

#pragma mark - Singleton

+ (HomeKit_DateManager *)sharedInstance
{
    static HomeKit_DateManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[HomeKit_DateManager alloc] init];
    });
    
    return sharedInstance;
}

#pragma mark - Methods

- (NSString *)dateToString:(NSDate *)pDate
{
    NSString *result = @"";
    
    if (pDate != nil) {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"MM/dd/yyyy"];
        
        result = [df stringFromDate:pDate];
    }
   
    return result;
}

- (NSString *)dateTimeToString:(NSDate *)pDate
{
    NSString *result = @"";
    
    if (pDate != nil) {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
        
        result = [df stringFromDate:pDate];
    }
    
    return result;
}

- (NSString *)dateTimeWithTimeZoneToString:(NSDate *)pDate
{
    NSString *result = @"";
    
    if (pDate != nil) {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"MM/dd/yyyy'T'HH:mm:ss.SSSSZ"];
        
        result = [df stringFromDate:pDate];
    }
    
    return result;
}

- (NSDate *)stringToDate:(NSString *)pString
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM/dd/yyyy"];
    
    return [df dateFromString:pString];
}

- (NSDate *)stringToDateTime:(NSString *)pString
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
    
    return [df dateFromString:pString];
}

- (NSDate *)stringToDateTimeWithTimeZone:(NSString *)pString
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM/dd/yyyy'T'HH:mm:ssZ"];
    
    return [df dateFromString:pString];
}

- (NSDate *)stringToDateTimeWithUTC:(NSString *)pString
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
//    [df setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ssZ"];
    
    return [df dateFromString:[pString stringByAppendingString:@"+0000"]];
}

- (NSString *)dateTimeWithUTCToString:(NSDate *)pDate
{
    NSString *result = @"";
    
    if (pDate != nil) {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
        [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        result = [df stringFromDate:pDate];
    }
    
    return result;
}

@end
