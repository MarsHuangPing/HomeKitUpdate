//
//  SplashADResponse.m
//  FreshAir
//
//  Created by mars on 27/03/2018.
//  Copyright © 2018 mars. All rights reserved.
//

#import "HomeKit_SplashADResponse.h"

#import "HomeKit_SplashAD.h"

@implementation HomeKit_SplashADResponse

- (HomeKit_SplashADResponse *)initWithSplashAD:(HomeKit_SplashAD *)pSplashAD data:(NSData *)pData
{
    if(self = [super init]){
        _splashAD = pSplashAD;
        _mdData = pData;
    }
    return self;
}

@end
