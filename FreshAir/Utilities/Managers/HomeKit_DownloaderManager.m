//
//  DownloaderManager.m
//  NewPeek2
//
//  Created by Tyler on 7/10/13.
//  Copyright (c) 2013 Delaware consulting. All rights reserved.
//

#define kTimeoutInterval 10

#import "HomeKit_DownloaderManager.h"

#import "HomeKit_HttpManager.h"

#import "AFNetworking.h"

#import "NSString+ML.h"

@interface HomeKit_DownloaderManager ()
{
    NSOperationQueue *_oqVoting;
}

@end

@implementation HomeKit_DownloaderManager

#pragma mark - Singleton

- (id)init
{
    if (self = [super init]) {
        _oqVoting = [[NSOperationQueue alloc] init];
        _oqVoting.maxConcurrentOperationCount = 4;
    }
    
    return self;
}

+ (HomeKit_DownloaderManager *)sharedInstance
{
    static HomeKit_DownloaderManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[HomeKit_DownloaderManager alloc] init];
    });
    
    return sharedInstance;
}

#pragma mark - Methods

- (void)downloadImageWithURL:(NSURL *)pURL
                   cachePath:(NSString *)pCachePath
             completionBlock:(void(^)(BOOL pSuccess))pCompletionBlock
{
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithURL:pURL
                                                        completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
                                                            BOOL result = NO;
                                                            
                                                            if (error == nil) {
                                                                [[NSFileManager defaultManager] removeItemAtURL:[NSURL fileURLWithPath:pCachePath] error:nil];
                                                                [[NSFileManager defaultManager] copyItemAtURL:location toURL:[NSURL fileURLWithPath:pCachePath] error:nil];
                                                                
                                                                result = YES;
                                                            }
                                                            
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                if (pCompletionBlock != nil) {
                                                                    pCompletionBlock(result);
                                                                }
                                                            });
                                                        }];
    
    [downloadTask resume];
}

- (void)downloadDataWithURL:(NSURL *)pURL
                  cachePath:(NSString *)pCachePath
            completionBlock:(void(^)(NSString *pPath, HttpStatusType pHttpStatusType))pCompletionBlock;
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:pURL];
    request.timeoutInterval = kTimeoutInterval;
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.outputStream = [NSOutputStream outputStreamToFileAtPath:pCachePath append:YES];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        ExecuteBlockWithTwoParams(pCompletionBlock, pCachePath, HttpStatusTypeOK);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        ExecuteBlockWithTwoParams(pCompletionBlock, nil, [[HomeKit_HttpManager sharedInstance] httpStatusType:error.code]);
    }];
    
    [operation start];
}

- (void)downloadDataWithURLs:(NSMutableArray *)pURLs
{
    for (int i = 0; i < pURLs.count; i++) {
        NSURL *url = pURLs[i];
        
        NSString *cachePath = ImageCachesPath([url.absoluteString ml_md5Encrypt]);
        
        UIImage *img = [UIImage imageWithContentsOfFile:cachePath];
        
        if (img != nil) {
//            NSLog(@"exist %d", i);
            continue;
        }
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        request.timeoutInterval = kTimeoutInterval;
        
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//            NSLog(@"yes %d", i);
            [operation.responseData writeToFile:cachePath atomically:YES];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            NSLog(@"no %d", i);
        }];
        
        [_oqVoting addOperation:operation];
    }
}

@end
