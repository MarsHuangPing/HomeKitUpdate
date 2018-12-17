//
//  NSString+ML.m
//  NewPeek2
//
//  Created by Tyler on 13-4-10.
//  Copyright (c) 2013年 Delaware consulting. All rights reserved.
//

#import "NSString+ML.h"

#import <CommonCrypto/CommonDigest.h>

@implementation NSString (ML)

- (NSString *)ml_md5Encrypt
{
    const char *str = [self UTF8String];
    if (str == NULL) {
        str = "";
    }
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSString *filename = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                          r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
    
    return filename;
}

- (NSString *)ml_urlEncode
{
    return [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)ml_urlDecode
{
    return [self stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)ml_strippingHTML
{
    NSMutableString *outString = nil;
    
    if (self != nil) {
        outString = [[NSMutableString alloc] initWithString:self];
        
        if (outString.length > 0) {
            NSRange r;
            
            while ((r = [outString rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound) {
                [outString deleteCharactersInRange:r];
            }
        }
    }

    return outString;
}

- (CGFloat)ml_widthWithFont:(UIFont *)pFont
                     height:(CGFloat)pHeight
{
    CGFloat result = 0.0;
    
    if (self != nil && self.length > 0) {
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:pFont, NSFontAttributeName, nil];
        
        CGSize size = [self boundingRectWithSize:CGSizeMake(MAXFLOAT, pHeight)
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:dic
                                         context:nil].size;
        
        result = size.width;
    }
    
    return result;
}

- (CGFloat)ml_heightWithFont:(UIFont *)pFont
                       width:(CGFloat)pWidth
{
    CGFloat result = 0.0;
    
//#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_6_0
//    NSLineBreakMode lbm = NSLineBreakByWordWrapping;
//#else
//    UILineBreakMode lbm = UILineBreakModeWordWrap;
//#endif
    
    if (self != nil && self.length > 0) {
//        CGSize size = [self sizeWithFont:pFont
//                       constrainedToSize:CGSizeMake(pWidth, INT_MAX)
//                           lineBreakMode:lbm];
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:pFont, NSFontAttributeName, nil];
        
        CGSize size = [self boundingRectWithSize:CGSizeMake(pWidth, MAXFLOAT)
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:dic
                                         context:nil].size;

        result = size.height;
    }
    
    return result;
}

- (BOOL)ml_isValidJSONString
{
    BOOL result = NO;
    
    if ([self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length != 0) {
        if (([self hasPrefix:@"[{"] && [self hasSuffix:@"}]"]) ||
            ([self hasPrefix:@"{"] && [self hasSuffix:@"}"])) {
            result = YES;
        }
    }
    
    return result;
}

@end
