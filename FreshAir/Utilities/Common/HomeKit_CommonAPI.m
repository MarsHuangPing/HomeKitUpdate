//
//  CommonAPI.m
//  FreshAir
//
//  Created by mars on 16/06/2017.
//  Copyright © 2017 mars. All rights reserved.
//

#import "HomeKit_CommonAPI.h"

@implementation HomeKit_CommonAPI

#pragma mark - Singleton

+ (HomeKit_CommonAPI *)sharedInstance
{
    static HomeKit_CommonAPI *sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[HomeKit_CommonAPI alloc] init];
    });
    
    return sharedInstance;
}

- (UIViewController *)getViewControllerName:(NSString *)pViewControllerName
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"HomeKit_Main" bundle:nil];
    UIViewController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:pViewControllerName];
    
    return vc;
}


#pragma mark - error message handle
- (NSString *)handleErrorMessage:(ErrorMessageType)pType
{
    NSString *message = @"";
    switch (pType) {
        case ErrorMessageTypeNoDevice:
        {
            message = @"未发现设备";
            break;
        }
        case ErrorMessageTypeFoundError:
        {
            message = @"发现错误，请检查！";
            break;
        }
        case ErrorMessageTypeNormal:
        {
            message = @"运转正常";
            break;
        }
    }
    return message;
}

- (UIColor *)getColorWithValue:(float)PM25Density
{
    
    UIColor *result;
    if (PM25Density >= 0 && PM25Density <= 35){
        
        result = PM25_BACKGROUND_COLOR_FIRST;
        
    }
    else if (PM25Density >= 36 && PM25Density <= 75){
        
        result = PM25_BACKGROUND_COLOR_SECOND;
        
    }
    else if (PM25Density >=76 && PM25Density <= 115){
        
        result = PM25_BACKGROUND_COLOR_THIRD;
        
    }
    else if (PM25Density >= 116 && PM25Density <= 150){
        
        result = PM25_BACKGROUND_COLOR_FOURTH;
        
    }
    else if (PM25Density >=151 && PM25Density <= 250){
        
        result = PM25_BACKGROUND_COLOR_FIVE;
    }
    else if (PM25Density >=251 && PM25Density <= 350){
        
        result = PM25_BACKGROUND_COLOR_SIX;
        
    }
    else if(PM25Density >= 351){
        
        result = PM25_BACKGROUND_COLOR_SEVEN;
        
    }
    return result;
}

- (AirLevel)getAirLevelWithPM:(NSInteger)pm
{
    AirLevel airLevel = AirLevelOne;
    if (pm >= 0 && pm <= 50) {
        // level = "优";
        airLevel = AirLevelOne;
    }
    else if (51 <= pm && pm <= 100) {
        // level = "良";
        airLevel = AirLevelTwo;
    }
    else if (101 <= pm && pm <= 150) {
        // level = "轻度污染";
        airLevel = AirLevelThree;
    }
    else if (151 <= pm && pm <= 200) {
        // level = "中度污染";
        airLevel = AirLevelFour;
    }
    else if (201 <= pm && pm <= 300) {
        // level = "重度污染";
        airLevel = AirLevelFive;
    }
    else if (300 < pm) {
        // level = "严重污染";
        airLevel = AirLevelSix;
    }
    
    return airLevel;
}

- (BOOL)validateContactNumber:(NSString *)mobileNum{
    NSString * eleven = @"^1\\d{10}$";
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,175,176,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|7[56]|8[56])\\d{8}$";
    
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,177,180,189
     22         */
    NSString * CT = @"^1((33|53|77|8[09])[0-9]|349)\\d{7}$";
    
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    NSPredicate *regextestPHS = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHS];
    NSPredicate *regextestEleven = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", eleven];
    
    if(([regextestmobile evaluateWithObject:mobileNum] == YES)
       || ([regextestcm evaluateWithObject:mobileNum] == YES)
       || ([regextestct evaluateWithObject:mobileNum] == YES)
       || ([regextestcu evaluateWithObject:mobileNum] == YES)
       || ([regextestPHS evaluateWithObject:mobileNum] == YES)
       || ([regextestEleven evaluateWithObject:mobileNum] == YES)){
        return YES;
    }else{
        return NO;
    }
}

- (BOOL)isIPhoneXSeries
{
    // xr or xs max 896
    //x or xs 812
    
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    if (screenHeight == 821.0f || screenHeight == 896.0f || screenHeight == 812.0f) {
        return YES;
    }
    return NO;
}

@end
