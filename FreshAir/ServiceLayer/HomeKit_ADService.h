//
//  ADService.h
//  FreshAir
//
//  Created by mars on 27/03/2018.
//  Copyright © 2018 mars. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HomeKit_SplashAD;

@interface HomeKit_ADService : NSObject

@property (nonatomic, assign) BOOL luanchAdverShown;

+ (HomeKit_ADService *)sharedInstance;

- (void)retrieveSplashAdvertisementWithDetailDeviceType:(iOSScreenType)pDetailDeviceType
                                        completionBlock:(void(^)(HomeKit_SplashAD *result, HttpStatusType httpStatusType))pCompletionBlock;
- (HomeKit_SplashAD *)checkSplashAD;
@end
