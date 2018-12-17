//
//  NSString+ML.h
//  NewPeek2
//
//  Created by Tyler on 13-4-10.
//  Copyright (c) 2013年 Delaware consulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface NSString (MP)

- (NSString *)mp_md5Encrypt;

- (NSString *)mp_urlEncode;

- (NSString *)mp_urlDecode;

- (NSString *)mp_strippingHTML;

- (CGFloat)mp_widthWithFont:(UIFont *)pFont
                     height:(CGFloat)pHeight;

- (CGFloat)mp_heightWithFont:(UIFont *)pFont
                       width:(CGFloat)pWidth;

- (BOOL)mp_isValidJSONString;

@end
