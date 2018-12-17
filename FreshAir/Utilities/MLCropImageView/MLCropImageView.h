//
//  MLCropImageView.h
//  MLCropImageViewDemo
//
//  Created by Tyler on 9/4/13.
//  Copyright (c) 2013 Delaware consulting. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MLCropImageView : UIView

- (void)setOriginalImage:(UIImage *)pImage
                position:(CGPoint)pPosiztion
                   scale:(float)pScale;

- (UIImage *)retrieveCropImage;

- (CGPoint)retrievePosition;

- (float)retrieveScale;

@end
