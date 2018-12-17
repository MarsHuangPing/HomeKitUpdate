//
//  ADDataService.m
//  FreshAir
//
//  Created by mars on 27/03/2018.
//  Copyright © 2018 mars. All rights reserved.
//

#import "HomeKit_ADDataService.h"
#import "AFNetworking.h"
#import "HomeKit_HttpManager.h"
#import "HomeKit_DeviceConverter.h"
#import "HomeKit_SplashADResponse.h"

#import "HomeKit_SplashAD.h"

@implementation HomeKit_ADDataService


#pragma mark - splash advertisement
- (void)executeRequestForSplashADWithDetailDeviceType:(iOSScreenType)pDetailDeviceType
                                        completionBlock:(ServiceCompletionBlock)pCompletionBlock
{
    NSDictionary *dicParams = @{@"type":@(ADDeviceTypeIOS),
                                @"id":@(pDetailDeviceType),
                                @"token": kToken
                 };

    
    NSMutableURLRequest *request = [[HomeKit_HttpManager sharedInstance] fetchkSplashAdvertisementRequestWithParams:dicParams];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request
                                                completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
                                                    
                                                    NSString *log = [NSString stringWithFormat:@"SplashAD: %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]];
                                                    kDebugLog(log);
                                                    
                                                    HomeKit_SplashADResponse *result = [[HomeKit_SplashADResponse alloc] init];
                                                    
                                                    if (error) {
                                                        result.httpStatusType = [[HomeKit_HttpManager sharedInstance] httpStatusType:error.code];
                                                    }
                                                    else {
                                                        HomeKit_SplashAD *splashAD = nil;
                                                        splashAD = [HomeKit_DeviceConverter convertDataToSplashAdInfo:responseObject];
                                                        
                                                        result.splashAD =  splashAD;
                                                        result.mdData = responseObject;
                                                        result.httpStatusType = HttpStatusTypeOK;
                                                        result.success = YES;
                                                    }
                                                    
                                                    ExecuteBlockWithOneParam(pCompletionBlock, result);
                                                }];
    
    [dataTask resume];
}

@end
