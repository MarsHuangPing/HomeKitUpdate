//
//  SplashAD.m
//  newEMO
//
//  Created by mars on 17/10/2017.
//  Copyright © 2017 delawareconsulting. All rights reserved.
//

#import "HomeKit_SplashAD.h"
#import "NSObject+ML.h"


@implementation HomeKit_SplashAD

- (id)initWithDisplay:(BOOL)pDisplay
                 desc:(NSString *)pDesc
                  key:(NSString *)pKey
             photoURL:(NSString *)pPhotoURL
                 link:(NSString *)pLink
                 size:(NSString *)pSize
           downloaded:(BOOL)pDownloaded
{
    if(self = [super init]){
        _display = pDisplay;
        _desc = pDesc;
        _key = pKey;
        if(pPhotoURL){
            _photoURL = [NSURL URLWithString:pPhotoURL];
        }
        if(pLink){
            _link = [NSURL URLWithString:pLink];
        }
        _downloaded = pDownloaded;
        _size = [pSize ml_intValue];
        
    }
    
    return self;
}

@end
