//
//  UIImageView+ML.m
//  SDWebImage Demo
//
//  Created by Tyler on 13-3-28.
//  Copyright (c) 2013年 Dailymotion. All rights reserved.
//

#import "UIImageView+ML.h"

#import "objc/runtime.h"

#import "NSString+ML.h"

static char downloadTaskKey;
static char progressKey;

@implementation UIImageView (ML)

- (void)ml_downloadImageWithURL:(NSURL *)pImageURL
               placeholderImage:(UIImage *)pPlaceHolderImage
                      cachePath:(NSString *)pCachePath
{
    [self ml_cancelCurrentImageDownload];
    
    self.image = pPlaceHolderImage;
    
    if (pImageURL == nil ||
        pImageURL.absoluteString.length == 0 ||
        pCachePath.length == 0) {
        return;
    }
    
    NSString *strImagePath = [pCachePath stringByAppendingPathComponent:[pImageURL.absoluteString ml_md5Encrypt]];

    UIImage *img = [UIImage imageWithContentsOfFile:strImagePath];
 
    if (img != nil) {
        self.image = img;
        
        return;
    }
    
    UIActivityIndicatorView *aivProgress = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    aivProgress.center = [self convertPoint:self.center fromView:self.superview];

    [self addSubview:aivProgress];
    
    [aivProgress startAnimating];
    
    MLWeakSelf weakSelf = self;
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithURL:pImageURL
                                                        completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
                                                            if (error == nil) {
                                                                NSFileManager *fileManager = [NSFileManager defaultManager];
                                                                
                                                                [fileManager removeItemAtURL:[NSURL fileURLWithPath:strImagePath] error:nil];
                                                                [fileManager copyItemAtURL:location toURL:[NSURL fileURLWithPath:strImagePath] error:nil];
                                                                
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    [UIView transitionWithView:weakSelf
                                                                                      duration:0.5
                                                                                       options:UIViewAnimationOptionTransitionCrossDissolve | UIViewAnimationOptionAllowUserInteraction
                                                                                    animations:^{
                                                                                        weakSelf.image = [UIImage imageWithContentsOfFile:strImagePath];
                                                                                    }
                                                                                    completion:nil];
                                                                    
                                                                    [weakSelf ml_releaseObject];
                                                                });
                                                            }
                                                            else {
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    [weakSelf ml_releaseObject];
                                                                });
                                                            }
                                                        }];
    
    [downloadTask resume];
    
    objc_setAssociatedObject(self, &downloadTaskKey, downloadTask, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &progressKey, aivProgress, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)ml_cancelCurrentImageDownload
{
    NSURLSessionDownloadTask *downloadTask = objc_getAssociatedObject(self, &downloadTaskKey);
    
    if (downloadTask != nil && downloadTask.state == NSURLSessionTaskStateRunning) {
        [downloadTask cancel];
        
        [self ml_releaseObject];
    }
}

- (void)ml_releaseObject
{
    UIActivityIndicatorView *aivProgress = objc_getAssociatedObject(self, &progressKey);
    [aivProgress stopAnimating];
    [aivProgress removeFromSuperview];
    
    objc_setAssociatedObject(self, &downloadTaskKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &progressKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)stopRotate
{
    objc_setAssociatedObject(self, &progressKey, @"NO", OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (void)startRotate
{
    objc_setAssociatedObject(self, &progressKey, @"YES", OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self rotate];
}
- (void)rotate
{
    
    [UIView animateWithDuration:0.001 animations:^{
        CGAffineTransform t = CGAffineTransformRotate(self.transform, M_PI/50);
        self.transform = t;
    } completion:^(BOOL finished) {
        [self setNeedsDisplay];
        NSString *mark = objc_getAssociatedObject(self, &progressKey);
        NSLog(@"mark....%@", mark);
        BOOL isRotating = [mark isEqualToString:@"YES"];
        if(isRotating){
            [self rotate];
        }
        else{
            objc_setAssociatedObject(self, &progressKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        
        
    }];
}

@end
