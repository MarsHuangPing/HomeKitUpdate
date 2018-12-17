//
//  AuthWechatManager.h
//  Wechat-SDK-Sample
//
//  Created by Remi Robert on 26/09/2016.
//  Copyright © 2016 Remi Robert. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HomeKit_User.h"

typedef void (^WechatAuthCompletedBlock)(HomeKit_User  * __nullable user, NSError * __nullable error);

@interface AuthWechatManager : NSObject

/*! @brief shared instance of the manager (singleton). */
+ (__nonnull instancetype)shareInstance;

/*!
 @brief Init the manager.
 
 @discussion user it whenever you want to set and init the wechat SDK with API Key.
             This is required to use the API.
             The best place is : didFinishLaunchingWithOptions in the AppDelegate.m
 
 @return BOOL return the success status.
 */
- (BOOL)initManager;

/*!
 @brief check if it's a Wechat url.
 
 @discussion This method check if the url got from openURL in AppDelegate.m is from Wechat.
             Allows to handle several type of handler in the same time (Facebook, Google, etc)
 
 @param  url the url from openURL
 
 @return BOOL check the check.
 */
- (BOOL)isWechatUrl:(NSString * _Nonnull)url;

/*!
 @brief handle open url of the application.
 
 @discussion This method allows you to handle the openURL method easily.
             Detects also if it's an auth redirection, and continue the process.
 
 To use it, simply call it in the openURL method in the AppDelegate.m
 
 @param  url returned by the original method.
 @param  completion a completion block in case you have it's a auth redirection.
 
 @return BOOL return the result by openURL.
 */
- (BOOL)handleOpenUrl:(NSURL * _Nullable )url completion:(__nonnull WechatAuthCompletedBlock)completion;

/*!
 @brief Auth the user.

 @discussion Will redirect throw the wechat application, 
             and then finish in the authentification process handleOpenUrl.
*/
- (void)auth:(UIViewController * _Nullable)controller;





@end
