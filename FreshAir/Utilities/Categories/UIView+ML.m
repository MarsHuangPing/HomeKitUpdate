//
//  UIView+ML.m
//  Panos
//
//  Created by Tyler on 12-12-13.
//  Copyright (c) 2012年 Delaware consulting. All rights reserved.
//

#import "UIView+ML.h"

@implementation UIView (ML)

- (float)ml_left
{
    return self.frame.origin.x;
}

- (float)ml_top
{
    return self.frame.origin.y;
}

- (float)ml_width
{
    return self.frame.size.width;
}

- (float)ml_height
{
    return self.frame.size.height;
}

- (float)ml_topPlusHeight
{
    return self.frame.origin.y + self.frame.size.height;
}

- (float)ml_leftPlusWidth
{
    return self.frame.origin.x + self.frame.size.width;
}

- (void)ml_changeLeft:(float)pLeft
{
    CGRect rect = self.frame;
    
    rect.origin.x = pLeft;
    
    self.frame = rect;
}

- (void)ml_changeTop:(float)pTop
{
    CGRect rect = self.frame;
    
    rect.origin.y = pTop;
    
    self.frame = rect;
}

- (void)ml_changeHeight:(float)pHeight
{
    CGRect rect = self.frame;
    
    rect.size.height = pHeight;
    
    self.frame = rect;
}

- (void)ml_changeWidth:(float)pWidth
{
    CGRect rect = self.frame;
    
    rect.size.width = pWidth;
    
    self.frame = rect;
}



@end
