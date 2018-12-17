//
//  ADDataService.h
//  FreshAir
//
//  Created by mars on 27/03/2018.
//  Copyright © 2018 mars. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeKit_ADDataService : NSObject

#pragma mark - splash advertisement
- (void)executeRequestForSplashADWithDetailDeviceType:(iOSScreenType)pDetailDeviceType
                                      completionBlock:(ServiceCompletionBlock)pCompletionBlock;

@end
