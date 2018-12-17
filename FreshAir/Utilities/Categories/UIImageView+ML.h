//
//  UIImageView+ML.h
//  SDWebImage Demo
//
//  Created by Tyler on 13-3-28.
//  Copyright (c) 2013年 Dailymotion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (ML)

- (void)ml_downloadImageWithURL:(NSURL *)pImageURL
               placeholderImage:(UIImage *)pPlaceHolderImage
                      cachePath:(NSString *)pCachePath;

- (void)stopRotate;
- (void)startRotate;

@end
