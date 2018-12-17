//
//  HomeBottomBar.m
//  FreshAir
//
//  Created by mars on 21/06/2017.
//  Copyright © 2017 mars. All rights reserved.
//

#import "HomeKit_HomeBottomBar.h"
#import "UIColor+ML.h"



@interface HomeKit_HomeBottomBar()
{
    UIButton *_btnAdd;
    UIButton *_btnBind;
    UIButton *_btnHelp;
    UIView *_viewSplitLeft;
    UIView *_viewSplitRight;
}
@end

@implementation HomeKit_HomeBottomBar


-(void)initUI{
    
//    self.backgroundColor = [UIColor whiteColor];
//    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    self.layer.borderWidth = .5;
//    self.clipsToBounds = YES;
//
//    float width = self.frame.size.width;
//    float height = self.frame.size.height;
//
//    float splitWidth = .5;
//    float buttonWidth = (width - 1 * splitWidth)/3.0;
//    float buttonHeight = height - splitWidth;
//
//    //创建画布
//    [self addButtonWithTitle:@"添加配件"
//                       frame:CGRectMake(0, 0, buttonWidth, buttonHeight)
//                    actionTo:ActionToContactToUS
//                      button:_btnAdd];
//
//    [self addSplitWithFrame:CGRectMake(buttonWidth, 0, splitWidth, buttonHeight)];
//
//    [self addButtonWithTitle:@"云登录"
//                       frame:CGRectMake(buttonWidth + splitWidth, 0, buttonWidth, buttonHeight)
//                    actionTo:ActionToSetToWIFI
//                      button:_btnBind];
//
//    [self addSplitWithFrame:CGRectMake(buttonWidth + splitWidth + buttonWidth, 0, splitWidth, buttonHeight)];
//
//    [self addButtonWithTitle:@"帮助"
//                       frame:CGRectMake((buttonWidth + splitWidth) * 2, 0, buttonWidth, buttonHeight)
//                    actionTo:ActionToShare
//                      button:_btnHelp];
    
    
}

//-(void)drawRect:(CGRect)rect{
//
//    self.backgroundColor = [UIColor whiteColor];
//    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    self.layer.borderWidth = .5;
//    self.clipsToBounds = YES;
//
//    float width = self.frame.size.width;
//    float height = self.frame.size.height;
//
//    float splitWidth = .5;
//    float buttonWidth = (width - 1 * splitWidth)/3.0;
//    float buttonHeight = height - splitWidth;
//
//    //创建画布
//    [self addButtonWithTitle:@"添加配件"
//                       frame:CGRectMake(0, 0, buttonWidth, buttonHeight)
//                    actionTo:ActionToContactToUS];
//
//    [self addSplitWithFrame:CGRectMake(buttonWidth, 0, splitWidth, buttonHeight)];
//
//    [self addButtonWithTitle:@"云登录"
//                       frame:CGRectMake(buttonWidth + splitWidth, 0, buttonWidth, buttonHeight)
//                    actionTo:ActionToSetToWIFI];
//
//    [self addSplitWithFrame:CGRectMake(buttonWidth + splitWidth + buttonWidth, 0, splitWidth, buttonHeight)];
//
//    [self addButtonWithTitle:@"帮助"
//                       frame:CGRectMake((buttonWidth + splitWidth) * 2, 0, buttonWidth, buttonHeight)
//                    actionTo:ActionToShare];
//
//
//}

- (void)addButtonWithTitle:(NSString *)pTitle
                     frame:(CGRect)pFrame
                  actionTo:(ActionTo)pActionTo
                    button:(UIButton *)pButton
{

    pButton.frame = pFrame;
    
    [pButton setTitle:pTitle forState:UIControlStateNormal];
    UIColor *color = RGB(110, 110, 110);
    [pButton setTitleColor:color forState:UIControlStateNormal];
    pButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [pButton setBackgroundImage:[RGB(238, 238, 238) toImage] forState:UIControlStateHighlighted];
    [pButton setTitleColor:RGB(0,0,0) forState:UIControlStateHighlighted];
    pButton.tag = pActionTo;
    [pButton addTarget:self action:@selector(actionFor:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:pButton];
    
}

- (void)addSplitWithFrame:(CGRect)pFrame split:(UIView *)pSplit
{

    pSplit.frame = pFrame;
    pSplit.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:pSplit];
    
}

- (void)actionFor:(UIButton *)sender
{
    if (self.delegate !=nil && [self.delegate respondsToSelector:@selector(ActionWithType:)]) {
        [self.delegate ActionWithType:sender.tag];
    }
}

- (void)hiddenLoginButton:(BOOL)pHidden
{
    
    //remove
    if(_viewSplitLeft){
        [_viewSplitLeft removeFromSuperview];
    }
    
    if(_viewSplitRight){
        [_viewSplitRight removeFromSuperview];
    }
    
    if(_btnAdd){
        [_btnAdd removeFromSuperview];
    }
    
    if(_btnBind){
        [_btnBind removeFromSuperview];
    }
    
    if(_btnHelp){
        [_btnHelp removeFromSuperview];
    }
    
    
    self.backgroundColor = [UIColor whiteColor];
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.layer.borderWidth = .5;
    self.clipsToBounds = YES;
    
    float width = self.frame.size.width;
    float height = self.frame.size.height;
    
    float splitWidth = .5;
    float buttonWidth = pHidden?(width - 1 * splitWidth)/2.0:(width - 1 * splitWidth)/3.0;
    float buttonHeight = height - splitWidth;
    
    //创建画布
    _btnAdd = [[UIButton alloc] init];
    [self addButtonWithTitle:@"添加配件"
                       frame:CGRectMake(0, 0, buttonWidth, buttonHeight)
                    actionTo:ActionToContactToUS
                      button:_btnAdd];
    
    _viewSplitLeft = [[UIView alloc] init];
    [self addSplitWithFrame:CGRectMake(buttonWidth, 0, splitWidth, buttonHeight)
                  split:_viewSplitLeft];
    
    if(!pHidden){
        _btnBind = [[UIButton alloc] init];
        [self addButtonWithTitle:@"云登录"
                           frame:CGRectMake(buttonWidth + splitWidth, 0, buttonWidth, buttonHeight)
                        actionTo:ActionToSetToWIFI
                          button:_btnBind];
        
        _viewSplitRight = [[UIView alloc] init];
        [self addSplitWithFrame:CGRectMake(buttonWidth + splitWidth + buttonWidth, 0, splitWidth, buttonHeight)
                            split:_viewSplitRight];
        
    }
    
    _btnHelp = [[UIButton alloc] init];
    [self addButtonWithTitle:@"帮助"
                       frame:CGRectMake((buttonWidth + splitWidth) * (pHidden?1:2), 0, buttonWidth, buttonHeight)
                    actionTo:ActionToShare
                      button:_btnHelp];
}

@end
