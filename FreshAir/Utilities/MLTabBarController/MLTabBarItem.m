//
//  MLTabBarItem.m
//  NewPeek2
//
//  Created by Tyler on 9/20/13.
//  Copyright (c) 2013 Delaware consulting. All rights reserved.
//

#define kTitleColor RGB(17, 100, 200)

#import "MLTabBarItem.h"

@interface MLTabBarItem ()
{
    UIImageView *_ivBackground;
    
    UIImageView *_ivTabItem;
    
    UIImage *_selectedImage;
    UIImage *_deselectedImage;
    
    UILabel *_lblTitle;
}

@end

@implementation MLTabBarItem

- (MLTabBarItem *)initWithFrame:(CGRect)pFrame
                          title:(NSString *)pTitle
                  selectedImage:(UIImage *)pSelectedImage
                deselectedImage:(UIImage *)pDeselectedImage
{
    self = [super initWithFrame:pFrame];
    if (self) {
        _ivBackground = [[UIImageView alloc] initWithFrame:self.bounds];

        [self addSubview:_ivBackground];
        
        _selectedImage = pSelectedImage;
        _deselectedImage = pDeselectedImage;
        
        _ivTabItem = [[UIImageView alloc] initWithFrame:CGRectMake(0, 2, pFrame.size.width, pFrame.size.height - 19)];
        _ivTabItem.contentMode = UIViewContentModeScaleAspectFit;
        _ivTabItem.image = _deselectedImage;
        
        [self addSubview:_ivTabItem];
   
        if (pTitle.length > 0) {
            _lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, _ivTabItem.frame.size.height + 2, pFrame.size.width, 17)];
            _lblTitle.textAlignment = NSTextAlignmentCenter;
            _lblTitle.backgroundColor = [UIColor clearColor];
            _lblTitle.textColor = kTitleColor;
            _lblTitle.font = [UIFont boldSystemFontOfSize:10];
            _lblTitle.text = pTitle;
            
            [self addSubview:_lblTitle];
        }
        else {
            CGRect rect = _ivTabItem.frame;
            
            rect.size.height = pFrame.size.height;
            
            _ivTabItem.frame = rect;
        }        
    }
    return self;
}

- (void)addTarget:(id)pTarget action:(SEL)pAction
{
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:pTarget action:pAction];
    
    [self addGestureRecognizer:tgr];
}

- (void)changeImage:(UIImage *)pImage
{
    _ivTabItem.image = pImage;
}

- (void)selectTabBarItem
{
    _ivBackground.image = [UIImage imageNamed:@"bg_tabbar_select.png"];
    
    _ivTabItem.image = _selectedImage;
    
    _lblTitle.textColor = [UIColor whiteColor];
}

- (void)deselectTabBarItem
{
    _ivBackground.image = nil;
    
    _ivTabItem.image = _deselectedImage;
    
    _lblTitle.textColor = kTitleColor;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
