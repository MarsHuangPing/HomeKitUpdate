//
//  UINavigationItem+ML.m
//  AAA
//
//  Created by Tyler on 10/11/13.
//  Copyright (c) 2013 Delaware consulting. All rights reserved.
//

#import "UINavigationItem+ML.h"

@implementation UINavigationItem (ML)

- (void)ml_setLeftBarButtonItem:(UIBarButtonItem *)pLeftBarButtonItem
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                        target:nil
                                                                                        action:nil];
        negativeSpacer.width = -10;
        
        [self setLeftBarButtonItems:[NSArray arrayWithObjects:negativeSpacer, pLeftBarButtonItem, nil]];
    }
    else {
        [self setLeftBarButtonItem:pLeftBarButtonItem];
    }
}

- (void)ml_setLeftBarButtonItems:(NSMutableArray *)pLeftBarButtonItems
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                        target:nil
                                                                                        action:nil];
        negativeSpacer.width = -10;
        
        [pLeftBarButtonItems insertObject:negativeSpacer atIndex:0];
        
        [self setLeftBarButtonItems:pLeftBarButtonItems];
    }
    else {
        [self setRightBarButtonItems:pLeftBarButtonItems];
    }
}

- (void)ml_setRightBarButtonItem:(UIBarButtonItem *)pRightBarButtonItem
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                        target:nil
                                                                                        action:nil];
        negativeSpacer.width = -10;
        
        [self setRightBarButtonItems:[NSArray arrayWithObjects:negativeSpacer, pRightBarButtonItem, nil]];
    }
    else {
        [self setRightBarButtonItem:pRightBarButtonItem];
    }
}

- (void)ml_setRightBarButtonItems:(NSMutableArray *)pRightBarButtonItems
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                        target:nil
                                                                                        action:nil];
        negativeSpacer.width = -10;
        
        [pRightBarButtonItems insertObject:negativeSpacer atIndex:0];
        
        [self setRightBarButtonItems:pRightBarButtonItems];
    }
    else {
        [self setRightBarButtonItems:pRightBarButtonItems];
    }
}

@end
