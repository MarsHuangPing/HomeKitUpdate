//
//  ButtonSwitch.h
//  FreshAir
//
//  Created by mars on 02/12/2017.
//  Copyright © 2017 mars. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ButtonSwitchStatus) {
    ButtonSwitchStatusActive,
    ButtonSwitchStatusPendding,
    ButtonSwitchStatusInactive
};


@interface HomeKit_ButtonSwitch : UIButton

@property (nonatomic, assign) ButtonSwitchStatus bsStatus;
- (void)start;
- (void)stop;
@end
