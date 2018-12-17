//
//  LanguageManager.h
//  Panos
//
//  Created by Tyler on 12-10-17.
//  Copyright (c) 2012年 Delaware consulting. All rights reserved.
//

typedef enum {
    LanguageTypeEnglish,
    LanguageTypeDutch,
    LanguageTypeFrench,
    LanguageTypeGerman,
    LanguageTypeChinese
} LanguageType;

#import <Foundation/Foundation.h>

@interface HomeKit_LanguageManager : NSObject

+ (HomeKit_LanguageManager *)sharedInstance;

- (NSString *)languageName;
- (LanguageType)languageType;

@end
