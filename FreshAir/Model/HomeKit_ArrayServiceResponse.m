//
//  ArrayServiceResponse.m
//  FreshAir
//
//  Created by mars on 26/02/2018.
//  Copyright © 2018 mars. All rights reserved.
//

#import "HomeKit_ArrayServiceResponse.h"

@implementation HomeKit_ArrayServiceResponse

- (HomeKit_ArrayServiceResponse *)initWithData:(NSMutableArray *)pData
{
    if(self = [super init])
    {
        _maData = pData;
    }
    return self;
}

@end
