//
//  ParamsView.m
//  Paams
//
//  Created by Mars on 2017/4/14.
//  Copyright © 2017年 Mars. All rights reserved.
//

#import "HomeKit_ParamsView.h"
#import "UIImageView+ML.h"
#import "HomeKit_FontManager.h"

typedef NS_ENUM(NSInteger, IconType) {
    IconTypeWind = 1000,
    IconTypeHumidity,
    IconTypeCo2
};

typedef NS_ENUM(NSInteger, LabelType){
    LabelTypeTitle,
    LabelTypeValue
};

@interface HomeKit_ParamsView()
{
    UIImageView *_ivWind;
    UIImageView *_ivHumidity;
    UIImageView *_ivCo2;
    
    UILabel *_lblWindTitle;
    UILabel *_lblHumidityTitle;
    UILabel *_lblCo2Title;
    
    UILabel *_lblWindValue;
    UILabel *_lblHimidityValue;
    UILabel *_lblCo2Value;
    
    NSInteger _windSpeed;
    BOOL _toRotate;
}
@property(nonatomic,copy) NSString *title;


@end
@implementation HomeKit_ParamsView

-(instancetype)initWithFrame:(CGRect)frame{
    
    if(self = [super initWithFrame:frame]){
        
        
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self initComponent];
}

//- (void)wil

-(void)initComponent{
    
//     makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    self.backgroundColor = [UIColor whiteColor];
    self.clipsToBounds = YES;
    self.layer.cornerRadius = 5;
    
    
    float BarChartLeftSpacing = 10;
    float BarChartRightSpacing = 10;
    float kTopMargin = 15;
    float kChartBoxWidth = self.frame.size.width - BarChartRightSpacing - BarChartLeftSpacing;
    
    float iconWidth = 26, iconHeight = 26;
    float iconSpacing = (kChartBoxWidth - iconWidth*3)/3;
    
    float lblItemWidth = 60;
    float lblSpacing = (kChartBoxWidth - lblItemWidth*3)/3;
    float lblHeight = 20;
    
    
    float lblTitleTop = kTopMargin + iconWidth + 5;
    float rowSpacing = 5;
    float lblValueTop = lblTitleTop + rowSpacing + lblHeight;
    
    UIColor *colorTitle = [UIColor colorWithRed:187.0/255.0 green:187.0/255.0 blue:187.0/255.0 alpha:1.0];
    UIColor *colorValue = [UIColor colorWithRed:34.0/255.0 green:181.0/255.0 blue:219.0/255.0 alpha:1.0];
    
    
    if(!_ivWind){
        [self addImageViewWithImage:[UIImage imageNamed:@"icon_wind_b"]
                              frame:CGRectMake(BarChartLeftSpacing + iconSpacing/2, kTopMargin, iconWidth, iconHeight)
                           iconType:IconTypeWind];
        
        
        [self addLableWithValue:@"风量"
                          frame:CGRectMake(BarChartLeftSpacing + lblSpacing/2, lblTitleTop, lblItemWidth, lblHeight)
                      textColor:colorTitle
                       textFont:[[HomeKit_FontManager sharedInstance] fontWithSize_14]
                      labelType:LabelTypeTitle
                       iconType:IconTypeWind];
        
        [self addLableWithValue:@"--%"
                          frame:CGRectMake(BarChartLeftSpacing + lblSpacing/2, lblValueTop, lblItemWidth, lblHeight)
                      textColor:colorValue
                       textFont:[[HomeKit_FontManager sharedInstance] fontWithSize_15]
                      labelType:LabelTypeValue
                       iconType:IconTypeWind];
    }
    
    
    if(!_ivHumidity){
        [self addImageViewWithImage:[UIImage imageNamed:@"icon_humidity23"]
                              frame:CGRectMake(BarChartLeftSpacing + iconSpacing/2 + (iconWidth + iconSpacing) * 1, kTopMargin, iconWidth, iconHeight)
                           iconType:IconTypeHumidity];
        
        [self addLableWithValue:@"湿度"
                          frame:CGRectMake(BarChartLeftSpacing + lblSpacing/2 + (lblItemWidth + lblSpacing) * 1, lblTitleTop, lblItemWidth, lblHeight)
                      textColor:colorTitle
                       textFont:[[HomeKit_FontManager sharedInstance] fontWithSize_14]
                      labelType:LabelTypeTitle
                       iconType:IconTypeHumidity];
        
        [self addLableWithValue:@"--"
                          frame:CGRectMake(BarChartLeftSpacing + lblSpacing/2 + (lblItemWidth + lblSpacing) * 1, lblValueTop, lblItemWidth, lblHeight)
                      textColor:colorValue
                       textFont:[[HomeKit_FontManager sharedInstance] fontWithSize_15]
                      labelType:LabelTypeValue
                       iconType:IconTypeHumidity];
    }
    
    
    if(!_ivCo2){
        [self addImageViewWithImage:[UIImage imageNamed:@"icon_co2_b"]
                              frame:CGRectMake(BarChartLeftSpacing + iconSpacing/2 + (iconWidth + iconSpacing) * 2, kTopMargin, iconWidth, iconHeight)
                           iconType:IconTypeCo2];
        
        [self addLableWithValue:@"二氧化碳"
                          frame:CGRectMake(BarChartLeftSpacing + lblSpacing/2 + (lblItemWidth + lblSpacing) * 2, lblTitleTop, lblItemWidth, lblHeight)
                      textColor:colorTitle
                       textFont:[[HomeKit_FontManager sharedInstance] fontWithSize_14]
                      labelType:LabelTypeTitle
                       iconType:IconTypeCo2];
        
        [self addLableWithValue:@"--"
                          frame:CGRectMake(BarChartLeftSpacing + lblSpacing/2 + (lblItemWidth + lblSpacing) * 2, lblValueTop, lblItemWidth, lblHeight)
                      textColor:colorValue
                       textFont:[[HomeKit_FontManager sharedInstance] fontWithSize_15]
                      labelType:LabelTypeValue
                       iconType:IconTypeCo2];
    }
    
    
    
}


- (void)addImageViewWithImage:(UIImage *)pImage frame:(CGRect)pFrame iconType:(IconType)pIconType
{
    UIImageView *iv = [[UIImageView alloc] initWithFrame:pFrame];
    switch (pIconType) {
        case IconTypeWind:
        {
            _ivWind = iv;
            break;
        }
        case IconTypeHumidity:
        {
            _ivHumidity = iv;
            
            [self checkHimidityAnimation];
            
            break;
        }
        case IconTypeCo2:
        {
            _ivCo2 = iv;
            [self checkCo2Animation];
            break;
        }
    }
    
    iv.image = pImage;
    iv.clipsToBounds = YES;
    [self addSubview:iv];
    
    
}

- (NSString *)speedLableWithValue:(NSInteger)pValue
{
    NSString *result = @"-- %";
    if(pValue != 0){
        result = [NSString stringWithFormat:@"%ld%@", pValue, @"%"];
    }
    else{
        result = [NSString stringWithFormat:@"%@", @"off"];
    }
    
    return result;
}

- (void)checkHimidityAnimation
{
    if(![_lblHimidityValue.text isEqualToString:@"--"]){
        
        NSMutableArray *maImages = [NSMutableArray array];
        
        for (int i = 1; i<5; i++) {
            NSString *imageName = @"icon_humidity1";
            UIImage *image = [UIImage imageNamed:imageName];
            [maImages addObject:image];
        }
        
        for (int i = 1; i<23; i++) {
            NSString *imageName = [NSString stringWithFormat:@"icon_humidity%d", i];
            UIImage *image = [UIImage imageNamed:imageName];
            [maImages addObject:image];
        }
        
        for (int i = 1; i<8; i++) {
            NSString *imageName = [NSString stringWithFormat:@"icon_humidity_persent_%d0", i];
            UIImage *image = [UIImage imageNamed:imageName];
            [maImages addObject:image];
            [maImages addObject:image];
        }
        
        NSString *imageName = [NSString stringWithFormat:@"icon_humidity_persent_%d0", 8];
        UIImage *image = [UIImage imageNamed:imageName];
        for (int i = 1; i<200; i++) {
            [maImages addObject:image];
        }
        
        _ivHumidity.animationImages = maImages;
        _ivHumidity.animationRepeatCount = 0;
        _ivHumidity.animationDuration = 5.0;
        [_ivHumidity startAnimating];
        
    }
}

- (void)checkCo2Animation
{
    if(![_lblCo2Value.text isEqualToString:@"--"]){
        
        NSMutableArray *maImages = [NSMutableArray array];
        
        for (int i = 1; i<13; i++) {
            NSString *imageName = [NSString stringWithFormat:@"icon_co2_b%d", i];
            UIImage *image = [UIImage imageNamed:imageName];
            [maImages addObject:image];
        }
        
        for (int i = 13; i>1; i--) {
            NSString *imageName = [NSString stringWithFormat:@"icon_co2_b%d", i];
            UIImage *image = [UIImage imageNamed:imageName];
            [maImages addObject:image];
        }
        
        
        
        _ivCo2.animationImages = maImages;
        _ivCo2.animationRepeatCount = 0;
        _ivCo2.animationDuration = 5.0;
        [_ivCo2 startAnimating];
        
    }
}

- (void)addLableWithValue:(NSString *)pValue
                    frame:(CGRect)pFrame
                textColor:(UIColor *)pTextColor
                 textFont:(UIFont *)pFont
                labelType:(LabelType)pLabelType
                 iconType:(IconType)pIconType
{
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:pFrame];
    switch (pIconType) {
        case IconTypeWind:
        {
            if(pLabelType == LabelTypeValue){
                _lblWindValue = lbl;
            }
            else{
                _lblWindTitle = lbl;
            }
            break;
        }
        case IconTypeHumidity:
        {
            if(pLabelType == LabelTypeValue){
                _lblHimidityValue = lbl;
            }
            else{
                _lblHumidityTitle = lbl;
            }
            break;
        }
        case IconTypeCo2:
        {
            if(pLabelType == LabelTypeValue){
                _lblCo2Value = lbl;
            }
            else{
                _lblCo2Title = lbl;
            }
            break;
        }
    }
    lbl.font = pFont;
    lbl.text = pValue;
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.textColor = pTextColor;
    lbl.adjustsFontSizeToFitWidth = YES;
    [self addSubview:lbl];
    
    
}

- (void)rotate
{
    if(!_toRotate){
        _lblWindValue.text = [self speedLableWithValue:0];
        return;
        
    }
    
    _windSpeed = _windSpeed < 1 ? 1 : _windSpeed;
    float speed = _windSpeed * 0.01;
    
    //change the alpha
    float alpha = 1 - speed;
    alpha = alpha < .6 ? .6 : alpha;
    _ivWind.alpha = alpha;
    
    MLWeakSelf weakSelf = self;
    [UIView animateWithDuration:0.1 animations:^{
        CGAffineTransform t = CGAffineTransformRotate(_ivWind.transform, (2 * M_PI/100) * speed * 30);
        _ivWind.transform = t;
        [_ivWind layoutIfNeeded];
    } completion:^(BOOL finished) {
        
        if(_toRotate){
            [weakSelf rotate];
        }
        else{
            _ivWind.alpha = 1;
            _lblWindValue.text = [self speedLableWithValue:0];
        }
    }];
}
#pragma mark - public methods
- (void)startRotateWind
{
    
    if(!_toRotate){
        _toRotate = YES;
        [self rotate];
        
    }
    
}

- (void)stopRotateWind
{
    _toRotate = NO;
    
}

- (void)setValuesWithHumidity:(NSInteger)pHumidity co2:(NSString *)pCo2 speed:(NSInteger)pSpeed
{
    _windSpeed = pSpeed;
    _lblWindValue.text = [self speedLableWithValue:pSpeed];
    
    NSString *humidity = @"--";
    humidity = [NSString stringWithFormat:@"%ld", pHumidity];
    if(![humidity isEqualToString:@"0"]){
        _lblHimidityValue.text = humidity;
    }
    
    //Himidity
    if([_lblHimidityValue.text isEqualToString:@"--"]){
        [_ivHumidity stopAnimating];
        
    }
    else{
        
        if(!_ivHumidity.isAnimating){
            _ivHumidity.animationRepeatCount = 0;
            [_ivHumidity startAnimating];
            
        }
        
    }
    
    //Co2
    if([_lblCo2Value.text isEqualToString:@"--"]){
        [_ivCo2 stopAnimating];
        
    }
    else{
        
        if(!_ivCo2.isAnimating){
            _ivCo2.animationRepeatCount = 0;
            [_ivCo2 startAnimating];
            
        }
        
    }
    
    _lblCo2Value.text = pCo2;
}

@end
