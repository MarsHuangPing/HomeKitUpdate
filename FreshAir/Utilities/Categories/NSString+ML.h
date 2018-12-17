//
//  NSString+ML.h
//  NewPeek2
//
//  Created by Tyler on 13-4-10.
//  Copyright (c) 2013年 Delaware consulting. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ML)

- (NSString *)ml_md5Encrypt;

- (NSString *)ml_urlEncode;

- (NSString *)ml_urlDecode;

- (NSString *)ml_strippingHTML;

- (CGFloat)ml_widthWithFont:(UIFont *)pFont
                     height:(CGFloat)pHeight;

- (CGFloat)ml_heightWithFont:(UIFont *)pFont
                       width:(CGFloat)pWidth;

- (BOOL)ml_isValidJSONString;

@end
