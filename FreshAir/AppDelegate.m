//
//  AppDelegate.m
//  FreshAir
//
//  Created by mars on 08/06/2017.
//  Copyright © 2017 mars. All rights reserved.
//

#import "AppDelegate.h"
#import <CoreLocation/CoreLocation.h>
#import "HomeKit_FileManager.h"
#import "HomeKit_CommonAPI.h"

#import "WXApi.h"
#import "AuthWechatManager.h"

#import "HomeKit_UserService.h"
#import "HomeKit_User.h"
#import "HomeKit_DeviceService.h"

#import "HomeKit_MenuViewController.h"
#import "HomeKit_MainViewController.h"
#import "HomeKit_AboutViewController.h"
#import "HomeKit_DetailViewController.h"

#import "HomeKit_AccessoryManager.h"


@interface AppDelegate ()<CLLocationManagerDelegate>
{
    CLLocationManager *_lmCurrent;
    
    LocationBlock _locationBlock;
    RESideMenu *_sideMenuViewController;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [WXApi registerApp:@"wx4917df781a78cd3a"];
    //fetch location
    _lmCurrent = [[CLLocationManager alloc] init];
    _lmCurrent.delegate = self;
    
    [self fetchLocationWithCompletionBlock:nil];
    [[HomeKit_FileManager sharedInstance] checkFirstRunning];
    

    
    //for side menu
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    HomeKit_MainViewController *vcMain = (HomeKit_MainViewController *)[[HomeKit_CommonAPI sharedInstance] getViewControllerName:@"MainViewController"];
    vcMain.comeFrom = ComeFromHome;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:vcMain];
    HomeKit_MenuViewController *leftMenuViewController = (HomeKit_MenuViewController *)[[HomeKit_CommonAPI sharedInstance] getViewControllerName:@"MenuViewController"];
    [leftMenuViewController loadData];
    
    _sideMenuViewController = [[RESideMenu alloc] initWithContentViewController:navigationController
                                                                    leftMenuViewController:leftMenuViewController
                                                                   rightMenuViewController:nil];
    _sideMenuViewController.backgroundImage = [UIImage imageNamed:@"Stars"];
    _sideMenuViewController.menuPreferredStatusBarStyle = 1; 
    _sideMenuViewController.delegate = self;
    _sideMenuViewController.contentViewShadowColor = [UIColor blackColor];
    _sideMenuViewController.contentViewShadowOffset = CGSizeMake(0, 0);
    _sideMenuViewController.contentViewShadowOpacity = 0.6;
    _sideMenuViewController.contentViewShadowRadius = 12;
    _sideMenuViewController.contentViewShadowEnabled = YES;
    
    
    self.window.rootViewController = _sideMenuViewController;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
    return YES;
}

- (void)setRootViewWithController:(UIViewController *)pController
{
    self.window.rootViewController = pController;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if ([[AuthWechatManager shareInstance] isWechatUrl:[url absoluteString]]) {
        [self handleWechatUrl:url];
    }
    return true;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    if ([[AuthWechatManager shareInstance] isWechatUrl:[url absoluteString]]) {
        [self handleWechatUrl:url];
    }
    return true;
}


-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options{
    if ([[AuthWechatManager shareInstance] isWechatUrl:[url absoluteString]]) {
        [self handleWechatUrl:url];
    }
    return true;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    if([HomeKit_DeviceService sharedInstance].vcAbout){
        [[HomeKit_DeviceService sharedInstance].vcAbout valueWhenEnterBg];
    }
    
//    if([DeviceService sharedInstance].vcMain){
//        [[DeviceService sharedInstance].vcMain checkUpgradeForDevice];
//    }
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    [self initDevices];
    
}

- (void)initDevices
{
    if([HomeKit_DeviceService sharedInstance].vcAbout){
        [[HomeKit_DeviceService sharedInstance].vcAbout startToCheckUpgrade];
    }
    
    if([HomeKit_DeviceService sharedInstance].vcMain){
        
        [[HomeKit_DeviceService sharedInstance].vcMain readValue];
        [[HomeKit_DeviceService sharedInstance].vcMain removeProgress];
        [[HomeKit_DeviceService sharedInstance].vcMain enableNotificationForHome];
    }
    if([HomeKit_DeviceService sharedInstance].vcDetail){
        [[HomeKit_DeviceService sharedInstance].vcDetail readValue];
    }
    
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    [_lmCurrent stopUpdatingLocation];
    
    CLGeocoder *geo = [[CLGeocoder alloc] init];
    
    
    NSLocale *locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
    if (@available(iOS 11.0, *)) {
        [geo reverseGeocodeLocation:newLocation preferredLocale:locale completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            if (placemarks.count == 0) {
                return ;
            }
            
            CLPlacemark *placemark = placemarks.firstObject;
            
            
            NSString *address = [NSString stringWithFormat:@"%@",
                                 placemark.addressDictionary[@"City"]];
            address = [address stringByReplacingOccurrencesOfString:@"市" withString:@""];
            
            if (_locationBlock != nil) {
                _locationBlock(address, LocationAccessErrorTypeNormall);
            }
        }];
    } else {
        [geo reverseGeocodeLocation:newLocation completionHandler: ^(NSArray *placemarks, NSError *error) {
            if (placemarks.count == 0) {
                return ;
            }
            
            CLPlacemark *placemark = placemarks.firstObject;
            
            
            NSString *address = [NSString stringWithFormat:@"%@",
                                 placemark.addressDictionary[@"City"]];
            
            if (_locationBlock != nil) {
                _locationBlock(address, LocationAccessErrorTypeNormall);
            }
        }];
    }
    
    
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusDenied ||
        status == kCLAuthorizationStatusRestricted) {
        
        if(_locationBlock){
            _locationBlock(nil, LocationAccessErrorTypeDeny);
        }
        
        return;
    }
    
    [manager startUpdatingLocation];
}

- (void)fetchLocationWithCompletionBlock:(LocationBlock)pCompletionBlock
{
    _locationBlock = [pCompletionBlock copy];
    
    if ([CLLocationManager locationServicesEnabled]) {
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied ||
            [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted) {
            if(_locationBlock){
                _locationBlock(nil, LocationAccessErrorTypeDeny);
            }
            
            return;
        }
        
        if ([_lmCurrent respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [_lmCurrent requestWhenInUseAuthorization];
        }
        
        [_lmCurrent startUpdatingLocation];
    }
    else {
        
    }
}

//handle wechat url
- (BOOL)handleWechatUrl:(NSURL *)url {
    MLWeakSelf weakSelf = self;
    return [[AuthWechatManager shareInstance] handleOpenUrl:url completion:^(HomeKit_User * _Nullable user, NSError * _Nullable error) {
        [HomeKit_UserService sharedInstance].user = user;
        [[AuthWechatManager shareInstance] initManager];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf actionForLoginWithWechat];
        });
    }];
}

- (void)actionForLoginWithWechat {
    
    [kAppDelegate setRootViewWithController:_sideMenuViewController];
    if([HomeKit_DeviceService sharedInstance].vcMain){
        [[HomeKit_DeviceService sharedInstance].vcMain initController];
    }
}

#pragma mark -
#pragma mark RESideMenu Delegate

- (void)sideMenu:(RESideMenu *)sideMenu willShowMenuViewController:(UIViewController *)menuViewController
{
    NSString *log = [NSString stringWithFormat:@"willShowMenuViewController: %@", NSStringFromClass([menuViewController class])];
    kDebugLog(log);
}

- (void)sideMenu:(RESideMenu *)sideMenu didShowMenuViewController:(UIViewController *)menuViewController
{
    
    NSString *log = [NSString stringWithFormat:@"didShowMenuViewController: %@", NSStringFromClass([menuViewController class])];
    kDebugLog(log);
}

- (void)sideMenu:(RESideMenu *)sideMenu willHideMenuViewController:(UIViewController *)menuViewController
{
    
    NSString *log = [NSString stringWithFormat:@"willHideMenuViewController: %@", NSStringFromClass([menuViewController class])];
    kDebugLog(log);
}

- (void)sideMenu:(RESideMenu *)sideMenu didHideMenuViewController:(UIViewController *)menuViewController
{
    
    NSString *log = [NSString stringWithFormat:@"didHideMenuViewController: %@", NSStringFromClass([menuViewController class])];
    kDebugLog(log);
}


@end
