//
//  Pm25CityStationRequest.m
//  FreshAir
//
//  Created by mars on 24/02/2018.
//  Copyright © 2018 mars. All rights reserved.
//

#import "HomeKit_Pm25CityStationRequest.h"


@implementation HomeKit_Pm25CityStationRequest

- (HomeKit_Pm25CityStationRequest *)initWithArea:(NSString *)pArea
{
    if(self = [super init]){
        _area = pArea;
    }
    return self;
}

@end
