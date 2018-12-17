//
//  History.m
//  FreshAir
//
//  Created by mars on 09/08/2017.
//  Copyright © 2017 mars. All rights reserved.
//

#import "HomeKit_History.h"

@implementation HomeKit_History

- (HomeKit_History *)initWithDate:(NSString *)pDate indoor:(float)pIndoor outdoor:(float)pOutdoor
{
    if(self = [super init]){
        _date = pDate;
        _indoor = pIndoor;
        _outdoor = pOutdoor;
    }
    return self;
}

@end
