//
//  Adver.m
//  FreshAir
//
//  Created by mars on 10/07/2017.
//  Copyright © 2017 mars. All rights reserved.
//

#import "HomeKit_Adver.h"

@implementation HomeKit_Adver

- (HomeKit_Adver *)initWithAdverID:(NSString *)pAdverID adverTitle:(NSString *)pAdverTitle URL:(NSURL *)pURL
{
    if(self = [super init]){
        _adverID = pAdverID;
        _adverTitle = pAdverTitle;
        _URL = pURL;
    }
    return self;
}

@end
