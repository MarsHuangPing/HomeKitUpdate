//
//  SplashADResponse.h
//  FreshAir
//
//  Created by mars on 27/03/2018.
//  Copyright © 2018 mars. All rights reserved.
//

#import "HomeKit_ServiceResponse.h"

@class HomeKit_SplashAD;

@interface HomeKit_SplashADResponse : HomeKit_ServiceResponse

@property (nonatomic, strong) HomeKit_SplashAD *splashAD;
@property (nonatomic, strong) NSData *mdData;

- (HomeKit_SplashADResponse *)initWithSplashAD:(HomeKit_SplashAD *)pSplashAD data:(NSData *)pData;

@end
