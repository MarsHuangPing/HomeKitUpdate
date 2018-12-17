//
//  HistoryInfoResponse.m
//  FreshAir
//
//  Created by mars on 25/02/2018.
//  Copyright © 2018 mars. All rights reserved.
//

#import "HistoryInfoResponse.h"

@implementation HistoryInfoResponse

- (HistoryInfoResponse *)initWithHistories:(NSMutableArray *)pHistories
{
    if(self = [super init]){
        _maHistories = pHistories;
    }
    return self;
}

@end
