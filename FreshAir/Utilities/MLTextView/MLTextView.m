//
//  MLTextView.m
//  CCC
//
//  Created by Tyler on 10/23/13.
//  Copyright (c) 2013 Delaware consulting. All rights reserved.
//

#define kMargin 5

#define kLabelHeight 20

#define kLimitLength 140

#import "MLTextView.h"

#import <QuartzCore/QuartzCore.h>

@interface MLTextView () <UITextViewDelegate>
{
    UILabel *_lblLength;
    
    int _limitLength;
}

@end

@implementation MLTextView

- (MLTextView *)initWithFrame:(CGRect)pFrame
                      content:(NSString *)pContent
                  limitLength:(int)pLimitLength
{
    self = [super initWithFrame:pFrame];
    if (self) {
        _limitLength = pLimitLength;
        
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(kMargin, kMargin, pFrame.size.width - 2 * kMargin, pFrame.size.height - kLabelHeight - 2 * kMargin)];
        _textView.layer.cornerRadius = 8;
        _textView.layer.borderWidth = 1;
        _textView.layer.borderColor = [UIColor grayColor].CGColor;
        _textView.text = pContent;
        
        [self addSubview:_textView];
        
        if (pLimitLength != 10000) {
            _textView.delegate = self;
            
            _lblLength = [[UILabel alloc] initWithFrame:CGRectMake(kMargin, _textView.frame.origin.y + _textView.frame.size.height, pFrame.size.width - 2 * kMargin, kLabelHeight)];
            _lblLength.font = [UIFont systemFontOfSize:15];
            _lblLength.textColor = [UIColor grayColor];
            _lblLength.backgroundColor = [UIColor clearColor];
            
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_6_0
            NSTextAlignment ta = NSTextAlignmentRight;
#else
            UITextAlignment ta = NSTextAlignmentRight;
#endif
            _lblLength.textAlignment = ta;
            
            [self addSubview:_lblLength];
            
            if (_limitLength <= 0) {
                _limitLength = kLimitLength;
            }
            
            if (_textView.text.length > _limitLength) {
                _textView.text = nil;
                
                _limitLength = kLimitLength;
                
                NSLog(@"Content's length is bigger than limit length!");
            }
            
            if (_textView.text.length > 0) {
                _lblLength.text = [NSString stringWithFormat:@"%lu", _limitLength - _textView.text.length];
            }
            else {
                _lblLength.text = [NSString stringWithFormat:@"%d", _limitLength];
            }
        }
    }
    
    return self;
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    BOOL isOK = NO;
    
    if ([text isEqualToString:@"\n"]) {
        if (self.tag == 1000 || self.tag == 1001) {
            if (self.delegate != nil && [self.delegate respondsToSelector:@selector(textView:returnActionTag:)]) {
                [self.delegate textView:self returnActionTag:self.tag];
            }
        }
    }
    
    if ([text isEqualToString:@""]) {
        if (textView.text.length - 1 <= _limitLength) {
            isOK = YES;
            
            _lblLength.text = [NSString stringWithFormat:@"%lu", _limitLength - (textView.text.length - 1)];
        }
    }
    else {
        if (textView.text.length + text.length <= _limitLength) {
            isOK = YES;
            
            _lblLength.text = [NSString stringWithFormat:@"%lu", _limitLength - (textView.text.length + text.length)];
        }
    }
    
    return isOK;
}

@end
