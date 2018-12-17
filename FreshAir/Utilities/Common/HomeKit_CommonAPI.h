//
//  CommonAPI.h
//  FreshAir
//
//  Created by mars on 16/06/2017.
//  Copyright © 2017 mars. All rights reserved.
//

typedef NS_ENUM(NSInteger, AirLevel) {
    AirLevelOne,    //优
    AirLevelTwo,    //良
    AirLevelThree,  //轻度污染
    AirLevelFour,   //中度污染
    AirLevelFive,   //重度污染
    AirLevelSix     //严重污染
};

#import <Foundation/Foundation.h>

@interface HomeKit_CommonAPI : NSObject

+ (HomeKit_CommonAPI *)sharedInstance;

- (UIViewController *)getViewControllerName:(NSString *)pViewControllerName;

#pragma mark - error message handle
- (NSString *)handleErrorMessage:(ErrorMessageType)pType;
- (UIColor *)getColorWithValue:(float)PM25Density;
- (BOOL)validateContactNumber:(NSString *)mobileNum;
- (AirLevel)getAirLevelWithPM:(NSInteger)pm;
- (BOOL)isIPhoneXSeries;
@end
