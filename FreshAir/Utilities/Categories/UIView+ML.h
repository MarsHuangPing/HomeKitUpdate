//
//  UIView+ML.h
//  Panos
//
//  Created by Tyler on 12-12-13.
//  Copyright (c) 2012年 Delaware consulting. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ML)

- (float)ml_left;

- (float)ml_top;

- (float)ml_width;

- (float)ml_height;

- (float)ml_topPlusHeight;

- (float)ml_leftPlusWidth;

- (void)ml_changeLeft:(float)pLeft;

- (void)ml_changeTop:(float)pTop;

- (void)ml_changeHeight:(float)pHeight;

- (void)ml_changeWidth:(float)pWidth;


@end
