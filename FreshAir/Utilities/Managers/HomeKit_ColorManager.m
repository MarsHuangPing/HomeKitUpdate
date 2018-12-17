//
//  ColorManager.m
//  FreshAir
//
//  Created by mars on 22/06/2017.
//  Copyright © 2017 mars. All rights reserved.
//

#import "HomeKit_ColorManager.h"

@implementation HomeKit_ColorManager
+ (HomeKit_ColorManager *)sharedInstance
{
    static HomeKit_ColorManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[HomeKit_ColorManager alloc] init];
    });
    
    return sharedInstance;
}

- (UIColor *)colorBlueButtonBackground
{
    return RGB(46, 132, 212);
}

- (UIColor *)colorTopBarAndBanner
{
    return RGB(5, 187, 227);
}

#pragma mark - text colors
- (UIColor *)color2Gray
{
    return RGB(117.0, 117.0, 117.0);
}
- (UIColor *)textWithDarkGray
{
    return RGB(128, 128, 128);
}

- (UIColor *)textWithGray
{
    return RGB(177, 177, 177);
}

- (UIColor *)textWithLightBlue
{
    return RGB(0, 176, 235);
}

#pragma mark - bg colors
- (UIColor *)viewBgWithGray
{
    return RGB(241, 241, 241);
}

- (UIColor *)viewBgWithLightGreen
{
    return RGB(177, 236, 187);
}

- (UIColor *)viewCellBgSelected
{
    return RGB(238, 238, 238);
}

- (UIColor *)mainBgLightGray;
{
    return RGB(247, 247, 247);
}

- (UIColor *)warningBorderYellow
{
    return RGB(254, 239, 187);
}

- (UIColor *)warningBgLightYellow
{
    return RGB(255, 250, 230);
}

@end
