//
//  DateManager.h
//  NewPeek2
//
//  Created by Tyler on 6/17/13.
//  Copyright (c) 2013 Delaware consulting. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeKit_DateManager : NSObject

#pragma mark - Singleton

+ (HomeKit_DateManager *)sharedInstance;

#pragma mark - Methods

- (NSString *)dateToString:(NSDate *)pDate;
- (NSString *)dateTimeToString:(NSDate *)pDate;
- (NSString *)dateTimeWithTimeZoneToString:(NSDate *)pDate;

- (NSDate *)stringToDate:(NSString *)pString;
- (NSDate *)stringToDateTime:(NSString *)pString;
- (NSDate *)stringToDateTimeWithTimeZone:(NSString *)pString;

- (NSDate *)stringToDateTimeWithUTC:(NSString *)pString;
- (NSString *)dateTimeWithUTCToString:(NSDate *)pDate;

@end
