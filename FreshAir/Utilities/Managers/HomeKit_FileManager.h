//
//  FileManager.h
//  Panos
//
//  Created by Tyler on 12-10-16.
//  Copyright (c) 2012年 Delaware consulting. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeKit_FileManager : NSObject

+ (HomeKit_FileManager *)sharedInstance;

- (BOOL)checkFirstRunning;

- (void)clearCaches;

- (void)calculateCachesSizeWithCompletionBlock:(void(^)(float pSize))pCompletionBlock;

@end
