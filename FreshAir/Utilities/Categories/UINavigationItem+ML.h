//
//  UINavigationItem+ML.h
//  AAA
//
//  Created by Tyler on 10/11/13.
//  Copyright (c) 2013 Delaware consulting. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationItem (ML)

- (void)ml_setLeftBarButtonItem:(UIBarButtonItem *)pLeftBarButtonItem;
- (void)ml_setLeftBarButtonItems:(NSMutableArray *)pLeftBarButtonItems;

- (void)ml_setRightBarButtonItem:(UIBarButtonItem *)pRightBarButtonItem;
- (void)ml_setRightBarButtonItems:(NSMutableArray *)pRightBarButtonItems;

@end
