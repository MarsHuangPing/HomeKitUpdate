//
//  ConfigServiceViewController.h
//  FreshAir
//
//  Created by mars on 07/03/2018.
//  Copyright © 2018 mars. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeKit_AccessoryManager.h"

#import "HomeKit_SplitLineBase.h"

@interface HomeKit_ConfigServiceViewController : UIViewController

@property (nonatomic, strong) HMAccessory *accessory;
@property (nonatomic, assign) NSInteger selected;

@end
