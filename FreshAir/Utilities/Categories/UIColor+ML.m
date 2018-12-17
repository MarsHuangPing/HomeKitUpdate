//
//  UIColor+ML.m
//  nmbs
//
//  Created by mars on 16/3/17.
//  Copyright © 2016年 Delaware Consulting. All rights reserved.
//

#import "UIColor+ML.h"

@implementation UIColor (ML)

- (UIImage *)toImage
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, self.CGColor);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
