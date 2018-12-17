//
//  CTextField.h
//  NewPeek2
//
//  Created by Tyler on 7/17/13.
//  Copyright (c) 2013 Delaware consulting. All rights reserved.
//

typedef NS_ENUM(NSInteger, CTextFieldType) {
    CTextFieldTypeDefault,
    CTextFieldTypePassword,
    CTextFieldTypeEmail,
    CTextFieldTypeURL,
    CTextFieldTypePhone
};

#import <Foundation/Foundation.h>

@interface CTextField : NSObject

+ (UITextField *)customizeTableCellTextFieldWithText:(NSString *)pText
                                         placeholder:(NSString *)pPlaceholder
                                       returnKeyType:(UIReturnKeyType)pReturnKeyType
                                       textFieldType:(CTextFieldType)pTextFieldType
                                            delegate:(id)pDelegate;

+ (UITextField *)customizeTextFieldWithFrame:(CGRect)pFrame
                                        text:(NSString *)pText
                               textAlignment:(NSTextAlignment)pTextAlignment
                                 placeholder:(NSString *)pPlaceholder
                               returnKeyType:(UIReturnKeyType)pReturnKeyType
                               textFieldType:(CTextFieldType)pTextFieldType
                                    delegate:(id)pDelegate;

@end
