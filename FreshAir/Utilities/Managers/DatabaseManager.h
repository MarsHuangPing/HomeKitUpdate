//
//  DatabaseManager.h
//  NewPeek2
//
//  Created by Tyler on 13-3-29.
//  Copyright (c) 2013年 Delaware consulting. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FMDatabaseQueue;

@interface DatabaseManager : NSObject

+ (DatabaseManager *)sharedInstance;

- (FMDatabaseQueue *)retrieveDatabaseQueue;

- (void)closeDatabaseQueue;

@end
