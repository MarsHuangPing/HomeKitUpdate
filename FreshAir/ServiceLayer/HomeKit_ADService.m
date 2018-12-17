//
//  ADService.m
//  FreshAir
//
//  Created by mars on 27/03/2018.
//  Copyright © 2018 mars. All rights reserved.
//

#import "HomeKit_ADService.h"
#import "HomeKit_ADDataService.h"

#import "HomeKit_SplashAD.h"
#import "HomeKit_SplashADResponse.h"
#import "HomeKit_DeviceConverter.h"
#import "HomeKit_HttpManager.h"

@implementation HomeKit_ADService

+ (HomeKit_ADService *)sharedInstance
{
    static HomeKit_ADService *sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[HomeKit_ADService alloc] init];
    });
    
    return sharedInstance;
}

#pragma mark - Methods

#pragma mark - splash ad
- (void)retrieveSplashAdvertisementWithDetailDeviceType:(iOSScreenType)pDetailDeviceType
                                        completionBlock:(void(^)(HomeKit_SplashAD *result, HttpStatusType httpStatusType))pCompletionBlock
{
    HomeKit_ADDataService *dsAD = [[HomeKit_ADDataService alloc] init];
    [dsAD executeRequestForSplashADWithDetailDeviceType:pDetailDeviceType
                                                   completionBlock:^(HomeKit_ServiceResponse *pServiceResponse) {
                                                       if(pServiceResponse.httpStatusType != HttpStatusTypeOK){
                                                           return;
                                                       }
                                                       HomeKit_SplashAD *newSplashAD = ((HomeKit_SplashADResponse *)pServiceResponse).splashAD;
                                                       
                                                       //case 1 need to remove ad
                                                       if(!newSplashAD.display){
                                                           if([[NSFileManager defaultManager] fileExistsAtPath:DocumentsPath(kSplashJsonFileName)]){
                                                               //remove pic file
                                                               NSData *dataJSON = [NSData dataWithContentsOfFile:DocumentsPath(kSplashJsonFileName)];
                                                               HomeKit_SplashAD *splashAD = [HomeKit_DeviceConverter convertDataToSplashAdInfo:dataJSON];
                                                               __weak __typeof(self)weakSelf = self;
                                                               [weakSelf removeADFileWithPath:DocumentsPath(splashAD.key)];
                                                               
                                                               //remove json file
                                                               [[NSFileManager defaultManager] removeItemAtPath:DocumentsPath(kSplashJsonFileName)
                                                                                                          error:nil];
                                                               
                                                               
                                                           }
                                                           
                                                           
                                                           return;
                                                       }
                                                       
                                                       if([[NSFileManager defaultManager] fileExistsAtPath:DocumentsPath(kSplashJsonFileName)]){
                                                           //case 3 load new ad pic, remove original pic and replace json file
                                                           NSData *dataJSON = [NSData dataWithContentsOfFile:DocumentsPath(kSplashJsonFileName)];
                                                           HomeKit_SplashAD *splashAD = [HomeKit_DeviceConverter convertDataToSplashAdInfo:dataJSON];
                                                           if(![newSplashAD.key isEqualToString:splashAD.key]){
                                                               HomeKit_HttpManager *manager = [[HomeKit_HttpManager alloc] init];
                                                               [manager downloadFileWithURL:newSplashAD.photoURL fileName:newSplashAD.key size:newSplashAD.size completionBlock:^(BOOL result) {
                                                                   if(result){
                                                                       //remove pic file
                                                                       __weak __typeof(self)weakSelf = self;
                                                                       [weakSelf removeADFileWithPath:DocumentsPath(splashAD.key)];
                                                                       //save new json
//                                                                       NSData *data= [NSJSONSerialization dataWithJSONObject:((SplashADResponse *)pServiceResponse).mdData options:NSJSONWritingPrettyPrinted error:nil];
                                                                       NSData *data= ((HomeKit_SplashADResponse *)pServiceResponse).mdData;
                                                                       [data writeToFile:DocumentsPath(kSplashJsonFileName) atomically:YES];
                                                                       
                                                                   }
                                                               }];
                                                           }
                                                       }
                                                       else{
                                                           //case 2 load new ad pic and no pic in sandbox
                                                           HomeKit_HttpManager *manager = [[HomeKit_HttpManager alloc] init];
                                                           [manager downloadFileWithURL:newSplashAD.photoURL fileName:newSplashAD.key size:newSplashAD.size completionBlock:^(BOOL result) {
                                                               if(result){
                                                                   NSData *resourceData = ((HomeKit_SplashADResponse *)pServiceResponse).mdData;
//                                                                   
                                                                   [resourceData writeToFile:DocumentsPath(kSplashJsonFileName) atomically:YES];
                                                                   
                                                               }
                                                           }];
                                                       }
                                                       
                                                   } ];
}
//DocumentsPath(splashAD.key)
- (void)removeADFileWithPath:(NSString *)pPath
{
    //remove the ad file
    
    if([[NSFileManager defaultManager] fileExistsAtPath:pPath]){
        
        [[NSFileManager defaultManager] removeItemAtPath:pPath
                                                   error:nil];
    }
}

- (HomeKit_SplashAD *)checkSplashAD
{
    HomeKit_SplashAD *result = nil;
    NSString *log = [NSString stringWithFormat:@"DocumentsPath(kSplashJsonFileName): %@", DocumentsPath(kSplashJsonFileName)];
    kDebugLog(log);
    if([[NSFileManager defaultManager] fileExistsAtPath:DocumentsPath(kSplashJsonFileName)]){
        
        NSData *dataJSON = [NSData dataWithContentsOfFile:DocumentsPath(kSplashJsonFileName)];
        HomeKit_SplashAD *splashAD = [HomeKit_DeviceConverter convertDataToSplashAdInfo:dataJSON];
        
        if(!splashAD){
            return nil;
        }
        
        if([[NSFileManager defaultManager] fileExistsAtPath:DocumentsPath(splashAD.key)]){
            
            return splashAD;
        }
    }
    return result;
}


@end
