//
//  BaseViewController.h
//  FreshAir
//
//  Created by mars on 18/06/2017.
//  Copyright © 2017 mars. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HomeKit_BaseViewController : UIViewController


- (void)showDropdownViewWithHttpStatusType:(HttpStatusType)pHttpStatusType;
- (void)showDropdownViewWithLocationAccessErrorType:(LocationAccessErrorType)pError;
- (void)showDropdownViewWithMessage:(NSString *)pMessage;
- (void)setTitle:(NSString *)pTitle;

@end
