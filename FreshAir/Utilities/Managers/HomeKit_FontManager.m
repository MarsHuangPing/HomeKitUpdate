//
//  FontManager.m
//  FreshAir
//
//  Created by mars on 20/06/2017.
//  Copyright © 2017 mars. All rights reserved.
//

#import "HomeKit_FontManager.h"

@implementation HomeKit_FontManager

+ (HomeKit_FontManager *)sharedInstance
{
    static HomeKit_FontManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[HomeKit_FontManager alloc] init];
    });
    
    return sharedInstance;
}

#pragma mark - colors
- (UIColor *)chartTitleColor
{
    return [UIColor colorWithRed:117.0/255.0 green:117.0/255.0 blue:117.0/255.0 alpha:1.0];
}

#pragma mark - 
- (UIFont *)fontWithSize_15
{
    return [UIFont fontWithName:@"PingFangSC-Regular" size:15];
}

- (UIFont *)fontWithSize_14
{
    return [UIFont fontWithName:@"PingFangSC-Regular" size:14];
}

- (UIFont *)fontWithSize_13
{
    return [UIFont fontWithName:@"PingFangSC-Regular" size:13];
}

- (UIFont *)fontWithSize_12
{
    return [UIFont fontWithName:@"PingFangSC-Regular" size:12];
}

- (UIFont *)fontWithSize_11
{
    return [UIFont fontWithName:@"PingFangSC-Regular" size:11];
}

@end
