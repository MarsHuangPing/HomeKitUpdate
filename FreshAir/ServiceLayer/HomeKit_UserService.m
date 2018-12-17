//
//  UserSevice.m
//  FreshAir
//
//  Created by mars on 10/07/2017.
//  Copyright © 2017 mars. All rights reserved.
//

#import "HomeKit_UserService.h"

#import "HomeKit_UserDataService.h"

#import "HomeKit_AdverResponse.h"
#import "HomeKit_Adver.h"
#import "HomeKit_User.h"

@implementation HomeKit_UserService

+ (HomeKit_UserService *)sharedInstance
{
    static HomeKit_UserService *sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[HomeKit_UserService alloc] init];
    });
    
    return sharedInstance;
}

#pragma mark - Methods




@end
