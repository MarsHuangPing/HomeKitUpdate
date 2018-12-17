//
//  MLCameraViewController.h
//  MLCameraViewControllerDemo
//
//  Created by Tyler on 7/25/14.
//  Copyright (c) 2014 Delaware consulting. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MLCameraViewControllerDelegate;

@interface MLCameraViewController : UIViewController

@property (nonatomic, weak) id<MLCameraViewControllerDelegate> delegate;

@end

@protocol MLCameraViewControllerDelegate <NSObject>

@required
- (void)handleCompletionForMLCameraViewControllerWithImage:(UIImage *)pImage;

@end
