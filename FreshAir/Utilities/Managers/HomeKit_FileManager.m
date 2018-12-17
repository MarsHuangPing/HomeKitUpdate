//
//  FileManager.m
//  Panos
//
//  Created by Tyler on 12-10-16.
//  Copyright (c) 2012年 Delaware consulting. All rights reserved.
//

#import "HomeKit_FileManager.h"

@implementation HomeKit_FileManager

+ (HomeKit_FileManager *)sharedInstance
{
    static HomeKit_FileManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[HomeKit_FileManager alloc] init];
    });
    
    return sharedInstance;
}

- (BOOL)checkFirstRunning
{
    BOOL result = YES;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:DocumentsPath(kEnglishDatabaseName)]) {
        result = NO;
        
        return result;
    }
    
    [[NSFileManager defaultManager] copyItemAtPath:ResourcesPath(kEnglishDatabaseName)
                                            toPath:DocumentsPath(kEnglishDatabaseName)
                                             error:nil];
    
    [[NSFileManager defaultManager] copyItemAtPath:ResourcesPath(kChineseDatabaseName)
                                            toPath:DocumentsPath(kChineseDatabaseName)
                                             error:nil];
    
    [[NSFileManager defaultManager] createDirectoryAtPath:CachesPath(kImageCachesFolderName)
                              withIntermediateDirectories:NO
                                               attributes:nil
                                                    error:nil];
    
    return result;
}

- (void)clearCaches
{
    [[NSFileManager defaultManager] removeItemAtPath:kImageCachesPath error:nil];
    
    [[NSFileManager defaultManager] createDirectoryAtPath:kImageCachesPath
                              withIntermediateDirectories:NO
                                               attributes:nil
                                                    error:nil];
}

- (void)calculateCachesSizeWithCompletionBlock:(void(^)(float pSize))pCompletionBlock
{ 
    __block float size = 0.0;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSDirectoryEnumerator *fileEnumerator = [[NSFileManager defaultManager] enumeratorAtPath:kImageCachesPath];
        
        for (NSString *fileName in fileEnumerator) {
            NSString *filePath = [kImageCachesPath stringByAppendingPathComponent:fileName];
            
            NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
            
            size += [attrs fileSize];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            ExecuteBlockWithOneParam(pCompletionBlock, size);
        });
    });
}

@end
