//
//  HistoryInfo.h
//  FreshAir
//
//  Created by mars on 25/02/2018.
//  Copyright © 2018 mars. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HistoryInfo : NSObject

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, assign) NSInteger indoorPm25;
@property (nonatomic, assign) NSInteger outdoorPm25;

- (HistoryInfo *)initWithDate:(NSDate *)pDate
                   indoorPm25:(NSInteger)pIndoorPm25
                  outdoorPm25:(NSInteger)pOutdoorPm25;

- (NSString *)formatDate;
- (NSString *)indoorStringValue;
- (NSString *)outdoorStringValue;

@end


//public class HistoryInfoModel
//{
//    public string date { get; set; }
//    public string indoorPm25 { get; set; }
//    public string outdoorPm25 { get; set; }
//}

