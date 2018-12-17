//
//  WechatUser.m
//  Wechat-SDK-Sample
//
//  Created by Mars on 26/09/2016.
//  Copyright © 2016 Mars. All rights reserved.
//

#import "WechatUser.h"

@implementation WechatUser

- (instancetype)initWithJSON:(NSDictionary *)json { 
    self = [super init];
    
    if (self) {
        _accessToken = [json objectForKey:@"access_token"];
        _refreshToken = [json objectForKey:@"refresh_token"];
        _expiresIn = [[json objectForKey:@"expires_in"] integerValue];
        _scope = [json objectForKey:@"scope"];
    }
    return self;
}

- (void)addInformationProfileWithJSON:(NSDictionary *)json {
    self.city = [json objectForKey:@"city"];
    self.nickname = [json objectForKey:@"nickname"];
    self.headimgurl = [json objectForKey:@"headimgurl"];
    self.country = [json objectForKey:@"country"];
    self.province = [json objectForKey:@"province"];
    self.sex = [[json objectForKey:@"sex"] integerValue];
    self.language = [json objectForKey:@"language"];
    self.openid = [json objectForKey:@"openid"];
    self.unionid = [json objectForKey:@"unionid"];
}

@end
