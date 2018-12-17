//
//  RoomSettingViewController.h
//  FreshAir
//
//  Created by mars on 10/12/2017.
//  Copyright © 2017 mars. All rights reserved.
//

#import "HomeKit_BaseViewController.h"
#import "HomeKit_AccessoryManager.h"

typedef NS_ENUM(NSInteger, EnterType) {
    EnterTypeManager,
    EnterTypeSelect,
    EnterTypeAddNewDevice
};

@protocol RoomSettingViewControllerDelegate <NSObject>

@optional
- (void)selectedRoom:(HMRoom *_Nullable)pRoom;


@end

@interface HomeKit_RoomSettingViewController : HomeKit_BaseViewController

@property (nonatomic, strong) HMHome *currentHome;
@property (nonatomic, assign) EnterType enterType;
@property (nonatomic, strong) HMRoom *currentRoom;
@property (nonatomic, strong) HMAccessory *currentAccessory;
@property (nonatomic, assign) id<RoomSettingViewControllerDelegate> delegate;

@property (nonatomic, strong) NSMutableArray *maDevices; //for manager from main

@end
