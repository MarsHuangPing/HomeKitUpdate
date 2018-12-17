
//
//  User.m
//  FreshAir
//
//  Created by Mars on 26/09/2016.
//  Copyright © 2016 Mars. All rights reserved.
//

#import "HomeKit_User.h"



@implementation HomeKit_User

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
    //应学
//    self.openid = [json objectForKey:@"openid"]; //@"oE99w0RcH29eFTquKQ313pQ-S-Ik";//
//    self.unionid = [json objectForKey:@"unionid"]; //@"oyCAww28IGri0_9snWTsQ91XfAtY";//
    //庆华
//    self.openid = @"oE99w0SXs7YJ9YaYOB1wwn4OUEX8";
//    self.unionid = @"oyCAwwwqDYy5G47xV3tZims9fePo";
}

@end
