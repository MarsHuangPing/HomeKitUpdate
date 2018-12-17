//
//  HistoryInfoResponse.h
//  FreshAir
//
//  Created by mars on 25/02/2018.
//  Copyright © 2018 mars. All rights reserved.
//

#import "HomeKit_ServiceResponse.h"

@interface HistoryInfoResponse : HomeKit_ServiceResponse

@property (nonatomic, strong) NSMutableArray *maHistories;

- (HistoryInfoResponse *)initWithHistories:(NSMutableArray *)pHistories;

@end
