//
//  LanguageManager.m
//  Panos
//
//  Created by Tyler on 12-10-17.
//  Copyright (c) 2012年 Delaware consulting. All rights reserved.
//

#define kEnglishKey @"en"
#define kDutchKey @"nl"
#define kFrenchKey @"fr"
#define kGermanKey @"de"
#define kChineseKey @"zh-Hans"

#import "HomeKit_LanguageManager.h"

@implementation HomeKit_LanguageManager

+ (HomeKit_LanguageManager *)sharedInstance
{
    static HomeKit_LanguageManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[HomeKit_LanguageManager alloc] init];
    });
    
    return sharedInstance;
}

- (NSString *)languageName
{
    NSString *result = kEnglishKey;
    
    NSArray *maLanguage = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
   
    if ([maLanguage[0] isEqualToString:kDutchKey]) {
         result = kDutchKey;
    }
    else if ([maLanguage[0] isEqualToString:kFrenchKey]) {
        result = kFrenchKey;
    }
    else if ([maLanguage[0] isEqualToString:kGermanKey]) {
        result = kGermanKey;
    }
    else if ([maLanguage[0] isEqualToString:kChineseKey]) {
        result = kChineseKey;
    }
    
    return result;
}

- (LanguageType)languageType
{
    LanguageType result = LanguageTypeEnglish;
    
    NSString *strLanguage = [self languageName];
    
    if ([strLanguage isEqualToString:kDutchKey]) {
        result = LanguageTypeDutch;
    }
    else if ([strLanguage isEqualToString:kFrenchKey]) {
        result = LanguageTypeFrench;
    }
    else if ([strLanguage isEqualToString:kGermanKey]) {
        result = LanguageTypeGerman;
    }
    else if ([strLanguage isEqualToString:kChineseKey]) {
        result = LanguageTypeChinese;
    }
    
    return result;
}

@end
