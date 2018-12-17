//
//  FontManager.h
//  FreshAir
//
//  Created by mars on 20/06/2017.
//  Copyright © 2017 mars. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeKit_FontManager : NSObject

+ (HomeKit_FontManager *)sharedInstance;

- (UIColor *)chartTitleColor;

- (UIFont *)fontWithSize_15;
- (UIFont *)fontWithSize_14;
- (UIFont *)fontWithSize_13;
- (UIFont *)fontWithSize_12;
- (UIFont *)fontWithSize_11;

@end
