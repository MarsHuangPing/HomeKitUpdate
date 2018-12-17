//
//  DownloaderManager.h
//  NewPeek2
//
//  Created by Tyler on 7/10/13.
//  Copyright (c) 2013 Delaware consulting. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeKit_DownloaderManager : NSObject

#pragma mark - Singleton

+ (HomeKit_DownloaderManager *)sharedInstance;

#pragma mark - Methods

- (void)downloadImageWithURL:(NSURL *)pURL
                   cachePath:(NSString *)pCachePath
             completionBlock:(void(^)(BOOL pSuccess))pCompletionBlock;

- (void)downloadDataWithURL:(NSURL *)pURL
                  cachePath:(NSString *)pCachePath
            completionBlock:(void(^)(NSString *pPath, HttpStatusType pHttpStatusType))pCompletionBlock;

- (void)downloadDataWithURLs:(NSMutableArray *)pURLs;

@end
