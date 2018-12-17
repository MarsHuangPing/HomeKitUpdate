//
//  HistoryInfo.m
//  FreshAir
//
//  Created by mars on 25/02/2018.
//  Copyright © 2018 mars. All rights reserved.
//

#import "HistoryInfo.h"

@implementation HistoryInfo

- (HistoryInfo *)initWithDate:(NSDate *)pDate
                   indoorPm25:(NSInteger)pIndoorPm25
                  outdoorPm25:(NSInteger)pOutdoorPm25
{
    if(self = [super init]){
        _date = pDate;
        _indoorPm25 = pIndoorPm25;
        _outdoorPm25 = pOutdoorPm25;
    }
    return self;
}

- (NSString *)formatDate
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM/dd"];
    
    return [df stringFromDate:self.date];
}

- (NSString *)indoorStringValue
{
    return [NSString stringWithFormat:@"%ld", self.indoorPm25];
}

- (NSString *)outdoorStringValue
{
    return [NSString stringWithFormat:@"%ld", self.outdoorPm25];
}

@end
