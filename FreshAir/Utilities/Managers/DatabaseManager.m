//
//  DatabaseManager.m
//  NewPeek2
//
//  Created by Tyler on 13-3-29.
//  Copyright (c) 2013年 Delaware consulting. All rights reserved.
//

#import "DatabaseManager.h"

#import "FMDatabaseQueue.h"

#import "HomeKit_LanguageManager.h"

@interface DatabaseManager ()
{
    FMDatabaseQueue *_databaseQueue;
}

@end

@implementation DatabaseManager

- (id)init {
	if (self = [super init]) {
        
        LanguageType languageType = [[HomeKit_LanguageManager sharedInstance] languageType];
        
        NSString *strDatabaseName = kEnglishDatabaseName;
        
        if (languageType == LanguageTypeChinese) {
            strDatabaseName = kChineseDatabaseName;
        } 
        
        _databaseQueue = [FMDatabaseQueue databaseQueueWithPath:DocumentsPath(strDatabaseName)];
	}
	
	return self;
}

+ (DatabaseManager *)sharedInstance
{
    static DatabaseManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DatabaseManager alloc] init];
    });
    
    return sharedInstance;
}

- (FMDatabaseQueue *)retrieveDatabaseQueue
{
    return _databaseQueue;
}

- (void)closeDatabaseQueue
{
    [_databaseQueue close];
}

@end
