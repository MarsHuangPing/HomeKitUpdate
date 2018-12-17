//
//  ButtonCtrlSwitch.h
//  FreshAir
//
//  Created by mars on 12/03/2018.
//  Copyright © 2018 mars. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ButtonCtrlSwitchStatus) {
    ButtonCtrlSwitchStatusActive,
    ButtonCtrlSwitchStatusPendding,
    ButtonCtrlSwitchStatusInactive
};

typedef NS_ENUM(NSInteger, ButtonCtrlSwitchType) {
    ButtonCtrlSwitchTypeNormal,
    ButtonCtrlSwitchTypeWindSmall,
    ButtonCtrlSwitchTypeRenameOK
};

@interface HomeKit_ButtonCtrlSwitch : UIButton

@property (nonatomic, assign) ButtonCtrlSwitchStatus bsStatus;
@property (nonatomic, assign) ButtonCtrlSwitchType bsType;

- (void)start;
- (void)stop;

@end
