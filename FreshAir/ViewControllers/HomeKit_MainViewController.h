//
//  MainViewController.h
//  FreshAir
//
//  Created by mars on 16/06/2017.
//  Copyright © 2017 mars. All rights reserved.
//

#import "HomeKit_BaseViewController.h"
#import "RESideMenu.h"
#import "HomeKit_AccessoryManager.h"
#import "HomeKit_DeviceStatusRoler.h"

typedef NS_ENUM(NSInteger, ComeFrom) {
    ComeFromHome,
    ComeFromRoom
};



@interface HomeKit_MainViewController : HomeKit_BaseViewController
@property (nonatomic, assign) ComeFrom comeFrom;
@property (nonatomic, strong) HMRoom *room;

- (void)readValue;
- (void)removeProgress;
- (void)initController;
- (void)enableNotificationForHome;

@end
