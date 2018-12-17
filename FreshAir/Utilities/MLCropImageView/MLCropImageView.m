//
//  MLCropImageView.m
//  MLCropImageViewDemo
//
//  Created by Tyler on 9/4/13.
//  Copyright (c) 2013 Delaware consulting. All rights reserved.
//

#import "MLCropImageView.h"

#import <QuartzCore/QuartzCore.h>

@interface MLCropImageView () <UIScrollViewDelegate>
{
    UIScrollView *_sv;
    
    UIImageView *_iv;
}

@end

@implementation MLCropImageView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        _sv = [[UIScrollView alloc] initWithFrame:self.bounds];
        _sv.delegate = self;
        _sv.bounces = NO;
        _sv.showsHorizontalScrollIndicator = NO;
        _sv.showsVerticalScrollIndicator = NO;
        
        [self addSubview:_sv];
        
        _iv = [[UIImageView alloc] init];
        
        [_sv addSubview:_iv];   
    }
    
    return self;
}

- (void)setOriginalImage:(UIImage *)pImage
                position:(CGPoint)pPosiztion
                   scale:(float)pScale
{
    [_sv setZoomScale:1.0 animated:NO];
    
    _iv.image = pImage;
    _iv.frame = CGRectMake(0, 0, pImage.size.width, pImage.size.height);
    
    _sv.contentSize = CGSizeMake(pImage.size.width, pImage.size.height);
    
    float scaleWidth = self.frame.size.width / pImage.size.width;
    float scaleHeight = self.frame.size.height / pImage.size.height;
    float scale = MAX(scaleWidth, scaleHeight);

    _sv.minimumZoomScale = scale >= 1.0 ? 1.0 : scale;
    _sv.maximumZoomScale = 1.5;
   
    [_sv setZoomScale:pScale animated:NO];

    _sv.contentOffset = pPosiztion;
}

- (UIImage *)retrieveCropImage
{  
    UIImage *image = nil;
    
    UIGraphicsBeginImageContext(CGSizeMake(_sv.frame.size.width, _sv.frame.size.height));
    
    CGContextRef resizedContext = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(resizedContext, -_sv.contentOffset.x, -_sv.contentOffset.y);
    
    [_sv.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

- (CGPoint)retrievePosition
{
    return _sv.contentOffset;
}

- (float)retrieveScale
{
    return _sv.zoomScale;
}

#pragma UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _iv;
}

@end
