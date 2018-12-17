//
//  SplashAD.h
//  newEMO
//
//  Created by mars on 17/10/2017.
//  Copyright © 2017 delawareconsulting. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeKit_SplashAD : NSObject

@property (nonatomic, assign) BOOL display;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) NSURL *photoURL;
@property (nonatomic, strong) NSURL *link;
@property (nonatomic, assign) BOOL downloaded;
@property (nonatomic, assign) NSInteger size;

- (id)initWithDisplay:(BOOL)pDisplay
                 desc:(NSString *)pDesc
                  key:(NSString *)pKey
             photoURL:(NSString *)pPhotoURL
                 link:(NSString *)pLink
                 size:(NSString *)pSize
           downloaded:(BOOL)pDownloaded;

@end


