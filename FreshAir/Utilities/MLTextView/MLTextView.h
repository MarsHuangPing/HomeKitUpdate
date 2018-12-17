//
//  MLTextView.h
//  CCC
//
//  Created by Tyler on 10/23/13.
//  Copyright (c) 2013 Delaware consulting. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MLTextViewDelegate;

@interface MLTextView : UIView

@property (nonatomic, strong, readonly) UITextView *textView;
@property (nonatomic, weak) id<MLTextViewDelegate> delegate;

- (MLTextView *)initWithFrame:(CGRect)pFrame
                      content:(NSString *)pContent
                  limitLength:(int)pLimitLength;

@end

@protocol MLTextViewDelegate <NSObject>

@optional
- (void)textView:(MLTextView *)pTextView returnActionTag:(NSInteger)pTag;

@end
