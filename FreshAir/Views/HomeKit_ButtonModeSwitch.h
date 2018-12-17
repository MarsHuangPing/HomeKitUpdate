//
//  ButtonModeSwitch.h
//  FreshAir
//
//  Created by mars on 03/12/2017.
//  Copyright © 2017 mars. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ButtonModeSwitchStatus) {
    ButtonModeSwitchStatusActive,
    ButtonModeSwitchStatusPendding,
    ButtonModeSwitchStatusInactive
};

@interface HomeKit_ButtonModeSwitch : UIButton
@property (nonatomic, assign) ButtonModeSwitchStatus bsStatus;
- (void)start;
- (void)stop;
@end
