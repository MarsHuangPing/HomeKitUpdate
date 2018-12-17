//
//  AuthWechatManager.m
//  Wechat-SDK-Sample
//
//  Created by Remi Robert on 26/09/2016.
//  Copyright © 2016 Remi Robert. All rights reserved.
//

#import "AuthWechatManager.h"
#import "WXApi.h"
#import "WXApiObject.h"

NSString *const WECHAT_APP_ID = @"wx4917df781a78cd3a";
NSString *const WECHAT_APP_SECRET = @"cb00fda2a3ccab89625ae40a19aa956c";
NSString *const BASE_URL_AUTH = @"https://api.weixin.qq.com/sns/oauth2/access_token?";
NSString *const BASE_URL_PROFILE = @"https://api.weixin.qq.com/sns/userinfo?";

#define kExpiredTime @"ExpiredTime"
#define kWeChatInfo @"WeChatInfo"

typedef void (^RequestCompletedBlock)(NSDictionary * __nullable response, NSError * __nullable error);

@interface AuthWechatManager () <WXApiDelegate>
@property (nonatomic, strong) WechatAuthCompletedBlock completion;
@end

@implementation AuthWechatManager

+ (instancetype)shareInstance {
    static AuthWechatManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [AuthWechatManager new];
    });
    return instance;
}

- (BOOL)initManager {
    return [WXApi registerApp:WECHAT_APP_ID];
}

- (BOOL)isWechatUrl:(NSString *)url {
    NSString *baseUrl = [[url componentsSeparatedByString:@"://"] firstObject];
    return [baseUrl isEqualToString:WECHAT_APP_ID];
}

- (BOOL)handleOpenUrl:(NSURL *)url completion:(WechatAuthCompletedBlock)completion {
    NSString *urlString = [url absoluteString];
    NSString *urlLink = [[[[urlString componentsSeparatedByString:@"//"] lastObject] componentsSeparatedByString:@"?"] firstObject];

    if (urlLink && ([urlLink isEqualToString:@"oauth"] || [urlLink isEqualToString:@"wapoauth"])) {
        [self initManager];
        self.completion = completion;
        return [WXApi handleOpenURL:url delegate:self];
    }
    return true;
}

- (void)auth:(UIViewController *)controller {
    SendAuthReq *authReq = [SendAuthReq new];
    authReq.scope = @"snsapi_userinfo";
    authReq.state = @"wechat_auth_login_liulishuo";
    if ([WXApi isWXAppInstalled]) {
        [WXApi sendReq:authReq];
    }
    else {
        [WXApi sendAuthReq:authReq viewController: controller delegate:self];
    }
}

- (void)onResp:(BaseResp*)resp {
    if (resp.errCode != WXSuccess) {
        self.completion(nil, [NSError errorWithDomain:@"wechat_error_domain" code:resp.errCode userInfo:@{NSLocalizedDescriptionKey: resp.errStr}]);
    }
    else {
        
        NSDate *expiredTime =  [[NSUserDefaults standardUserDefaults] valueForKey:kExpiredTime];
        if(expiredTime && [expiredTime compare:[NSDate date]] == NSOrderedDescending){
            NSDictionary *dicWechatTokens = [[NSUserDefaults standardUserDefaults] valueForKey:kWeChatInfo];
            [self getWechatInfoWithTokens:dicWechatTokens];
        }
        else if ([resp isKindOfClass:[SendAuthResp class]]) {
            SendAuthResp *temp = (SendAuthResp*)resp;
        
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@appid=%@&secret=%@&code=%@&grant_type=authorization_code", BASE_URL_AUTH, WECHAT_APP_ID, WECHAT_APP_SECRET, temp.code]];
            
            [self performRequestWithUrl:url completion:^(NSDictionary * _Nullable response, NSError * _Nullable error) {
                if (response) {
                    
                    NSInteger expiredInteval = [response[@"expires_in"] integerValue];
                    [[NSUserDefaults standardUserDefaults] setValue:[NSDate dateWithTimeIntervalSinceNow:expiredInteval] forKey:kExpiredTime];
                    [[NSUserDefaults standardUserDefaults] setValue:response forKey:kWeChatInfo];
                    
                    [self getWechatInfoWithTokens:response];
                }
                else {
                    self.completion(nil, error);
                }
            }];
        }
    }
}

- (void)getWechatInfoWithTokens:(NSDictionary *)pTokens
{
    
    if(pTokens){
        [[NSUserDefaults standardUserDefaults] setValue:pTokens forKey:kWechatTokenJsonKey];
    }
    
    HomeKit_User *user = [[HomeKit_User alloc] initWithJSON:pTokens];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@access_token=%@&openid=%@", BASE_URL_PROFILE, (NSString *)[pTokens objectForKey:@"access_token"], [pTokens objectForKey:@"openid"]]];
    [self performRequestWithUrl:url completion:^(NSDictionary * _Nullable response, NSError * _Nullable error) {
        
        if(!error && response){
            [[NSUserDefaults standardUserDefaults] setValue:response forKey:kWechatUserJsonKey];
            [user addInformationProfileWithJSON:response];
            
        }
        else{
            
        }
        self.completion(user, error);
    }];

}

- (void)performRequestWithUrl:(NSURL *)url completion:(RequestCompletedBlock)block {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json; charset=utf8" forHTTPHeaderField:@"Accept"];
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request
                                                             completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                                 if (error) {
                                                                     block(nil, error);
                                                                     return;
                                                                 }
                                                                 id result = [NSJSONSerialization JSONObjectWithData:data
                                                                                                             options:NSJSONReadingAllowFragments
                                                                                                               error:&error];
                                                                 block(result, nil);
                                                             }];
    [task resume];
}

- (BOOL)canSend {
    return [WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi];
}







@end
