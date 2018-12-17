//
//  CTextField.m
//  NewPeek2
//
//  Created by Tyler on 7/17/13.
//  Copyright (c) 2013 Delaware consulting. All rights reserved.
//

#import "CTextField.h"

@implementation CTextField

+ (UITextField *)customizeTableCellTextFieldWithText:(NSString *)pText
                                         placeholder:(NSString *)pPlaceholder
                                       returnKeyType:(UIReturnKeyType)pReturnKeyType
                                       textFieldType:(CTextFieldType)pTextFieldType
                                            delegate:(id)pDelegate
{ 
    return [self customizeTextFieldWithFrame:CGRectMake(0, 12, 150, 20)
                                        text:pText
                               textAlignment:NSTextAlignmentRight
                                 placeholder:pPlaceholder
                               returnKeyType:pReturnKeyType
                               textFieldType:pTextFieldType
                                    delegate:pDelegate];
}

+ (UITextField *)customizeTextFieldWithFrame:(CGRect)pFrame
                                        text:(NSString *)pText
                               textAlignment:(NSTextAlignment)pTextAlignment
                                 placeholder:(NSString *)pPlaceholder
                               returnKeyType:(UIReturnKeyType)pReturnKeyType
                               textFieldType:(CTextFieldType)pTextFieldType
                                    delegate:(id)pDelegate
{
    UITextField *tf = [[UITextField alloc] initWithFrame:pFrame]; 
    tf.text = pText;
    tf.textAlignment = pTextAlignment;
    tf.placeholder = pPlaceholder;
    tf.returnKeyType = pReturnKeyType;
    
    switch (pTextFieldType) {
        case CTextFieldTypeDefault:
        {
            tf.keyboardType = UIKeyboardTypeDefault;
            tf.secureTextEntry = NO;
            
            break;
        }
        case CTextFieldTypePassword:
        {
            tf.keyboardType = UIKeyboardTypeDefault;
            tf.secureTextEntry = YES;
            
            break;
        }
        case CTextFieldTypeEmail:
        {
            tf.keyboardType = UIKeyboardTypeEmailAddress;
            tf.secureTextEntry = NO;
            
            break;
        }
        case CTextFieldTypeURL:
        {
            tf.keyboardType = UIKeyboardTypeURL;
            tf.secureTextEntry = NO;
            
            break;
        }
        case CTextFieldTypePhone:
        {
            tf.keyboardType = UIKeyboardTypePhonePad;
            tf.secureTextEntry = NO;
            
            break;
        }
        default:
            break;
    }
    
    tf.delegate = pDelegate;
    
    tf.clearButtonMode = UITextFieldViewModeWhileEditing;
    tf.autocapitalizationType = UITextAutocapitalizationTypeNone;
    
    return tf;
}

@end
