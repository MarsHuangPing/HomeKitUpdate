//
//  BarChartView.m
//  BarChart
//
//  Created by Mars on 2017/4/14.
//  Copyright © 2017年 Mars. All rights reserved.
//

typedef NS_ENUM(NSInteger, ViewType) {
    ViewTypeIndoorBg = 1000,
    ViewTypeIndoorChart,
    ViewTypeIndoorChartValue,
    ViewTypeOutdoorBg,
    ViewTypeOutdoorChart,
    ViewTypeOutdoorChartValue
};



#import "HomeKit_TodayBarChartView.h"
#import "HomeKit_FontManager.h"
#import "HomeKit_ColorManager.h"


@interface HomeKit_TodayBarChartView()
{
    float _outdoorWidth;
    float _indoorWidth;
    
    float _outdoorLblLeft;
    float _indoorLblLeft;
    
    BOOL _isFirst;
}
@property(nonatomic,copy) NSString *title;


@end
@implementation HomeKit_TodayBarChartView

-(instancetype)initWithFrame:(CGRect)frame{
    
    if(self = [super initWithFrame:frame]){
        
        
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    _outdoorWidth = 0;
    _indoorWidth = 0;
    _isFirst = YES;
}

-(void)draw{
    self.backgroundColor = [UIColor whiteColor];
    //    self.clipsToBounds = YES;
    //    self.layer.cornerRadius = 5;
    //创建画布
    
    float BarChartLeftSpacing = 60;
    float BarChartRightSpacing = 30;
    float kTopMargin = 50;
    float kBottomMargin = 15;
    float kChartBoxWidth = self.frame.size.width - BarChartRightSpacing - BarChartLeftSpacing;
    float kChartBoxHeight = self.frame.size.height - kTopMargin - kBottomMargin;
    
    float barHeight = kChartBoxHeight/3;
    float spacing = barHeight;
    if(barHeight > 20){
        barHeight = 20;
        spacing = kChartBoxHeight - 40;
    }
    
    
    float value1 = [self.dataResource[@"value1"] floatValue];
    CGFloat w1 = kChartBoxWidth * value1/100;
    if(w1 > kChartBoxWidth){w1 = kChartBoxWidth;}
    
    float value2 = [self.dataResource[@"value2"] floatValue];
    CGFloat w2 = kChartBoxWidth * value2/100;
    if(w2 > kChartBoxWidth){w2 = kChartBoxWidth;}
    
    if(_isFirst){
        [self addLableWithValue:@"空气质量对比"
                          frame:CGRectMake(8,  15, 130, 22)
                      textColor:[[HomeKit_ColorManager sharedInstance] color2Gray]
                       textFont:[[HomeKit_FontManager sharedInstance] fontWithSize_14]];
    }
    
    
    if(_isFirst){
        [self addLableWithValue:@"室内"
                          frame:CGRectMake(8,  kTopMargin - 5, 50, 22)
                      textColor:[UIColor colorWithRed:187.0/255.0 green:187.0/255.0 blue:187.0/255.0 alpha:1.0]
                       textFont:[[HomeKit_FontManager sharedInstance] fontWithSize_14]];
    }
    
    
    [self addImageViewWithImage:[UIImage imageNamed:@"horizantal_bar_bg"]
                          frame:CGRectMake(BarChartLeftSpacing, kTopMargin, kChartBoxWidth, barHeight)
                     firstWidth:kChartBoxWidth
                       animated:NO
                            tag:ViewTypeIndoorBg];
    
    [self addImageViewWithImage:[UIImage imageNamed:@"horizantal_bar_blue"]
                          frame:CGRectMake(BarChartLeftSpacing, kTopMargin, w1, barHeight)
                     firstWidth:_indoorWidth
                       animated:YES
                            tag:ViewTypeIndoorChart];
    _indoorWidth = w1;
    
    [self addLableWithValue:self.dataResource[@"value1"]
                      frame:CGRectMake(BarChartLeftSpacing + w1, kTopMargin, 30, barHeight)
                  textColor:[UIColor colorWithRed:34.0/255.0 green:181.0/255.0 blue:219.0/255.0 alpha:1.0]
                 leftMargin:_indoorLblLeft == 0?BarChartLeftSpacing:_indoorLblLeft
                   textFont:[[HomeKit_FontManager sharedInstance] fontWithSize_14]
                        tag:ViewTypeIndoorChartValue];
    _indoorLblLeft = BarChartLeftSpacing + w1;
    
    if(_isFirst){
        [self addLableWithValue:@"室外"
                          frame:CGRectMake(8,  kTopMargin+barHeight+spacing - 5, 50, 22)
                      textColor:[UIColor colorWithRed:187.0/255.0 green:187.0/255.0 blue:187.0/255.0 alpha:1.0]
                       textFont:[[HomeKit_FontManager sharedInstance] fontWithSize_14]];
    }
    
    
    [self addImageViewWithImage:[UIImage imageNamed:@"horizantal_bar_bg"]
                          frame:CGRectMake(BarChartLeftSpacing, kTopMargin+barHeight+spacing, kChartBoxWidth, barHeight)
                     firstWidth:kChartBoxWidth
                       animated:NO
                            tag:ViewTypeOutdoorBg];
    [self addImageViewWithImage:[UIImage imageNamed:@"horizantal_bar_orange"]
                          frame:CGRectMake(BarChartLeftSpacing, kTopMargin+barHeight+spacing, w2, barHeight)
                     firstWidth:_outdoorWidth
                       animated:YES
                            tag:ViewTypeOutdoorChart];
    _outdoorWidth = w2;
    
    [self addLableWithValue:self.dataResource[@"value2"]
                      frame:CGRectMake(BarChartLeftSpacing + w2, kTopMargin+barHeight+spacing, 30, barHeight)
                  textColor:[UIColor colorWithRed:245.0/255.0 green:146.0/255.0 blue:86.0/255.0 alpha:1.0]
                 leftMargin:_outdoorLblLeft == 0?BarChartLeftSpacing:_outdoorLblLeft
                   textFont:[[HomeKit_FontManager sharedInstance] fontWithSize_14]
                        tag:ViewTypeOutdoorChartValue];
    _outdoorLblLeft = BarChartLeftSpacing + w2;
    
    _isFirst = NO;
}

- (void)addImageViewWithImage:(UIImage *)pImage frame:(CGRect)pFrame firstWidth:(float)pFirstWidth animated:(BOOL)pAnimated tag:(NSInteger)pTag
{
    UIImageView *iv = [self viewWithTag:pTag];
    
    if(iv == nil){
        CGRect frame = CGRectMake(pFrame.origin.x, pFrame.origin.y, pFirstWidth, pFrame.size.height);
        iv = [[UIImageView alloc] initWithFrame:pAnimated?frame:pFrame];
        iv.image = pImage;
        iv.clipsToBounds = YES;
        iv.layer.cornerRadius = pFrame.size.height/2;
        iv.tag = pTag;
        [self addSubview:iv];
    }
    
    if(pAnimated){
        [UIView animateWithDuration:1.0 animations:^{
            iv.frame = pFrame;
        }];
    }
}

- (void)addLableWithValue:(NSString *)pValue frame:(CGRect)pFrame textColor:(UIColor *)pTextColor leftMargin:(float)pLeftMargin textFont:(UIFont *)pFont tag:(NSInteger)pTag
{
    
    UILabel *lbl = [self viewWithTag:pTag];
    if(lbl == nil){
        CGRect frame = CGRectMake(pLeftMargin, pFrame.origin.y, pFrame.size.width, pFrame.size.height);
        lbl = [[UILabel alloc] initWithFrame:frame];
        lbl.font = pFont;//[UIFont systemFontOfSize:12];
        
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.textColor = pTextColor;
        lbl.adjustsFontSizeToFitWidth = YES;
        lbl.tag = pTag;
        [self addSubview:lbl];
    }
    lbl.text = pValue;
    
    [UIView animateWithDuration:1.0 animations:^{
        lbl.frame = pFrame;
    }];
    
}


- (void)addLableWithValue:(NSString *)pValue frame:(CGRect)pFrame textColor:(UIColor *)pTextColor textFont:(UIFont *)pFont
{
    UILabel *lbl = [[UILabel alloc] initWithFrame:pFrame];
    lbl.font = pFont;
    lbl.text = pValue;
    lbl.textAlignment = NSTextAlignmentLeft;
    lbl.textColor = pTextColor;
    lbl.adjustsFontSizeToFitWidth = YES;
    [self addSubview:lbl];
    
}




//-(void)drawRect:(CGRect)rect{
//
//    self.backgroundColor = [UIColor whiteColor];
//    self.clipsToBounds = YES;
//    self.layer.cornerRadius = 5;
//    //创建画布
//
//    float BarChartLeftSpacing = 40;
//    float BarChartRightSpacing = 30;
//    float kTopMargin = 50;
//    float kBottomMargin = 15;
//    float kChartBoxWidth = self.frame.size.width - BarChartRightSpacing - BarChartLeftSpacing;
//    float kChartBoxHeight = self.frame.size.height - kTopMargin - kBottomMargin;
//
//    float barHeight = kChartBoxHeight/3;
//    float spacing = barHeight;
//    if(barHeight > 20){
//        barHeight = 20;
//        spacing = kChartBoxHeight - 40;
//    }
//
//
//    float value1 = [self.dataResource[@"value1"] floatValue];
//    CGFloat w1 = kChartBoxWidth * value1/100;
//    if(w1 > kChartBoxWidth){w1 = kChartBoxWidth;}
//
//    float value2 = [self.dataResource[@"value2"] floatValue];
//    CGFloat w2 = kChartBoxWidth * value2/100;
//    if(w2 > kChartBoxWidth){w2 = kChartBoxWidth;}
//
//
//    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
//    paragraph.alignment = NSTextAlignmentLeft;
//    NSDictionary * attribute = @{NSFontAttributeName:[[HomeKit_FontManager sharedInstance] fontWithSize_14],NSParagraphStyleAttributeName:paragraph,NSForegroundColorAttributeName:[[HomeKit_FontManager sharedInstance] chartTitleColor]};
//    //title
//    [@"空气质量对比" drawInRect:CGRectMake(8,  15, 130, 22) withAttributes:attribute];
//
//
//    //mark
//    NSDictionary * attributeSmall= @{NSFontAttributeName:[[HomeKit_FontManager sharedInstance] fontWithSize_14],NSParagraphStyleAttributeName:paragraph,NSForegroundColorAttributeName:[UIColor colorWithRed:187.0/255.0 green:187.0/255.0 blue:187.0/255.0 alpha:1.0]};
//    [@"室内" drawInRect:CGRectMake(8,  kTopMargin, 40, 22) withAttributes:attributeSmall];
//    [self addImageViewWithImage:[UIImage imageNamed:@"horizantal_bar_bg"]
//                          frame:CGRectMake(BarChartLeftSpacing, kTopMargin, kChartBoxWidth, barHeight)
//                       animated:NO];
//
//    [self addImageViewWithImage:[UIImage imageNamed:@"horizantal_bar_blue"]
//                          frame:CGRectMake(BarChartLeftSpacing, kTopMargin, w1, barHeight)
//                       animated:YES];
//
//    [self addLableWithValue:self.dataResource[@"value1"]
//                      frame:CGRectMake(BarChartLeftSpacing + w1, kTopMargin, 30, barHeight)
//                  textColor:[UIColor colorWithRed:34.0/255.0 green:181.0/255.0 blue:219.0/255.0 alpha:1.0]
//                 leftMargin:BarChartLeftSpacing
//                   textFont:[[HomeKit_FontManager sharedInstance] fontWithSize_14]];
//
//
//
//    [@"室外" drawInRect:CGRectMake(8,  kTopMargin+barHeight+spacing, 40, 22) withAttributes:attributeSmall];
//    [self addImageViewWithImage:[UIImage imageNamed:@"horizantal_bar_bg"]
//                          frame:CGRectMake(BarChartLeftSpacing, kTopMargin+barHeight+spacing, kChartBoxWidth, barHeight)
//                       animated:NO];
//    [self addImageViewWithImage:[UIImage imageNamed:@"horizantal_bar_orange"]
//                          frame:CGRectMake(BarChartLeftSpacing, kTopMargin+barHeight+spacing, w2, barHeight)
//                       animated:YES];
//
//    [self addLableWithValue:self.dataResource[@"value2"]
//                      frame:CGRectMake(BarChartLeftSpacing + w2, kTopMargin+barHeight+spacing, 30, barHeight)
//                  textColor:[UIColor colorWithRed:245.0/255.0 green:146.0/255.0 blue:86.0/255.0 alpha:1.0]
//                 leftMargin:BarChartLeftSpacing
//                   textFont:[[HomeKit_FontManager sharedInstance] fontWithSize_14]];
//
//
//
//}
//
//- (void)addImageViewWithImage:(UIImage *)pImage frame:(CGRect)pFrame animated:(BOOL)pAnimated
//{
//    CGRect frame = CGRectMake(pFrame.origin.x, pFrame.origin.y, 0, pFrame.size.height);
//    UIImageView *iv = [[UIImageView alloc] initWithFrame:pAnimated?frame:pFrame];
//    iv.image = pImage;
//    iv.clipsToBounds = YES;
//    iv.layer.cornerRadius = pFrame.size.height/2;
//    [self addSubview:iv];
//    if(pAnimated){
//        [UIView animateWithDuration:1.0 animations:^{
//            iv.frame = pFrame;
//        }];
//    }
//}
//
//- (void)addLableWithValue:(NSString *)pValue frame:(CGRect)pFrame textColor:(UIColor *)pTextColor leftMargin:(float)pLeftMargin textFont:(UIFont *)pFont
//{
//    CGRect frame = CGRectMake(pLeftMargin, pFrame.origin.y, pFrame.size.width, pFrame.size.height);
//    UILabel *lbl = [[UILabel alloc] initWithFrame:frame];
//    lbl.font = pFont;//[UIFont systemFontOfSize:12];
//    lbl.text = pValue;
//    lbl.textAlignment = NSTextAlignmentCenter;
//    lbl.textColor = pTextColor;
//    lbl.adjustsFontSizeToFitWidth = YES;
//    [self addSubview:lbl];
//
//    [UIView animateWithDuration:1.0 animations:^{
//        lbl.frame = pFrame;
//    }];
//
//}










@end
