//
//  ColorManager.h
//  FreshAir
//
//  Created by mars on 22/06/2017.
//  Copyright © 2017 mars. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeKit_ColorManager : NSObject

+ (HomeKit_ColorManager *)sharedInstance;

- (UIColor *)colorTopBarAndBanner;

#pragma mark - text colors
- (UIColor *)textWithDarkGray;
- (UIColor *)textWithGray;
- (UIColor *)textWithLightBlue;
- (UIColor *)color2Gray;
#pragma mark - bg colors
- (UIColor *)viewBgWithGray;
- (UIColor *)viewBgWithLightGreen;
- (UIColor *)viewCellBgSelected;
- (UIColor *)mainBgLightGray;
- (UIColor *)colorBlueButtonBackground;
- (UIColor *)warningBorderYellow;
- (UIColor *)warningBgLightYellow;
@end
