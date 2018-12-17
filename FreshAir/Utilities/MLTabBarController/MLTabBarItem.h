//
//  MLTabBarItem.h
//  NewPeek2
//
//  Created by Tyler on 9/20/13.
//  Copyright (c) 2013 Delaware consulting. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MLTabBarItem : UIView

- (MLTabBarItem *)initWithFrame:(CGRect)pFrame
                          title:(NSString *)pTitle
                  selectedImage:(UIImage *)pSelectedImage
                deselectedImage:(UIImage *)pDeselectedImage;

- (void)addTarget:(id)pTarget action:(SEL)pAction;

- (void)changeImage:(UIImage *)pImage;

- (void)selectTabBarItem;

- (void)deselectTabBarItem;

@end
