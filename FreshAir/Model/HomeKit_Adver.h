//
//  Adver.h
//  FreshAir
//
//  Created by mars on 10/07/2017.
//  Copyright © 2017 mars. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeKit_Adver : NSObject

@property (nonatomic, strong) NSString *adverID;
@property (nonatomic, strong) NSString *adverTitle;
@property (nonatomic, strong) NSURL *URL;

- (HomeKit_Adver *)initWithAdverID:(NSString *)pAdverID adverTitle:(NSString *)pAdverTitle URL:(NSURL *)pURL;

@end
