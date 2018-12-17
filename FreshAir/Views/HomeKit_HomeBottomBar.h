//
//  HomeBottomBar.h
//  FreshAir
//
//  Created by mars on 21/06/2017.
//  Copyright © 2017 mars. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ActionTo) {
    ActionToContactToUS,
    ActionToSetToWIFI,
    ActionToShare
};

@protocol HomeBottomBarDelegate <NSObject>

@optional
- (void)ActionWithType:(ActionTo)pActionType;


@end
@interface HomeKit_HomeBottomBar : UIView

@property (nonatomic, assign) id<HomeBottomBarDelegate> delegate;

- (void)hiddenLoginButton:(BOOL)pHidden;

@end
