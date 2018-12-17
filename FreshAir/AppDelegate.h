//
//  AppDelegate.h
//  FreshAir
//
//  Created by mars on 08/06/2017.
//  Copyright © 2017 mars. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESideMenu.h"

typedef void(^LocationBlock)(NSString *pAddress, LocationAccessErrorType error);

@interface AppDelegate : UIResponder <UIApplicationDelegate, RESideMenuDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void)setRootViewWithController:(UIViewController *)pController;
- (void)fetchLocationWithCompletionBlock:(LocationBlock)pCompletionBlock;

@end

