//
//  PMDescriptionView.m
//  FreshAir
//
//  Created by mars on 24/03/2018.
//  Copyright © 2018 mars. All rights reserved.
//

#import "HomeKit_PMDescriptionView.h"
#import "NSString+MP.h"
#import "HomeKit_CommonAPI.h"

@interface HomeKit_PMDescriptionView()
{
    UILabel *_lblDescription;
}

@end

@implementation HomeKit_PMDescriptionView


- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
    self.layer.cornerRadius = 12;
    self.clipsToBounds = YES;
}

- (void)updatePMDescriptionWithPMValue:(NSInteger)pValue description:(NSString *)pDescription
{
    
    float width = [pDescription mp_widthWithFont:[UIFont fontWithName:@"PingFangSC-Regular" size:12] height:20] + 20;
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(updateConstraint:)]) {
        [self.delegate updateConstraint:width];
    }
    
    if(_lblDescription){
        [_lblDescription removeFromSuperview];
        _lblDescription = nil;
    }
    
    _lblDescription = [[UILabel alloc] init];
    CGRect rect = self.bounds;
    rect.size.width = width;
    _lblDescription.frame = rect;
    _lblDescription.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    _lblDescription.textAlignment = NSTextAlignmentCenter;
    _lblDescription.text = pDescription;
    
    UIColor *textColor;
    if(pValue <= 60){
        textColor = [UIColor colorWithRed:1/255.0 green:177/255.0 blue:235/255.0 alpha:1];
    }
    else{
        textColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1];
    }
    _lblDescription.textColor = textColor;
    
    [self addSubview:_lblDescription];
    [self flavescentGradientLayerWithValue:pValue];
//    [self flavescentGradientLayerWithValue:pValue width:width];
    [self setNeedsDisplay];
    
}

- (void)flavescentGradientLayerWithValue:(float)pmValue
{
    
    AirLevel airLevel = [[HomeKit_CommonAPI sharedInstance] getAirLevelWithPM:pmValue];
    
    UIColor *textColor;
    if(airLevel == AirLevelOne){
        textColor = RGB(1, 177, 235);
    }
    else{
        textColor = RGB(255, 255, 255);
    }
    _lblDescription.textColor = textColor;
    
    UIColor *color = RGB(255, 255, 255);
    switch (airLevel) {
        case AirLevelOne:
        {
            color = RGB(255, 255, 255);
            break;
        }
        case AirLevelTwo:
        {
            color = RGB(246, 231, 24);
            break;
        }
        case AirLevelThree:
        {
            color = RGB(227, 127, 31);
            break;
        }
        case AirLevelFour:
        {
            color = RGB(222, 51, 23);
            break;
        }
        case AirLevelFive:
        {
            color = RGB(177, 50, 189);
            break;
        }
        case AirLevelSix:
        {
            color = RGB(146, 14, 51);
            break;
        }
    }
    
    self.backgroundColor = color;
    
}

//- (void)flavescentGradientLayerWithValue:(float)pmValue width:(float)pWidth
//{
//
//
//    float value = pmValue > 255.0 ? 255.0 : pmValue;
//
//    float leftValueR = (255-value) * 55/255 + 200;
//    leftValueR = leftValueR < 200 ? 200 : leftValueR;
//
//    float leftValueB = 255 - value;
//
//    float baseForG = 5.0;
//    float leftScale = (255.0 - baseForG)/255.0;
//    float leftValueG = leftValueB * leftScale + baseForG;
//
//    float rightScale = (255.0 - 138.0)/255.0;
//    float rightValueB = 255 - value;
//    float rightValueG = rightValueB * rightScale + 138;
//
//
//    UIColor *leftColor = [UIColor colorWithRed:leftValueR/255.0 green:leftValueG/255.0 blue:leftValueB/255.0 alpha:1];
//    self.backgroundColor = [[HomeKit_CommonAPI sharedInstance] getColorWithValue:pmValue];
////    UIColor *rightColor = [UIColor colorWithRed:1.0 green:rightValueG/255.0 blue:rightValueB/255.0 alpha:1];
////    NSArray *gradientColors = [NSArray arrayWithObjects:(id)leftColor.CGColor, (id)rightColor.CGColor, nil];
////
////    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
////    CGRect rect = self.bounds;
////    rect.origin.x = 0;
////    rect.size.width = pWidth;
////    gradientLayer.frame = rect;
////    gradientLayer.colors = gradientColors;
////    gradientLayer.startPoint = CGPointMake(0, .5);
////    gradientLayer.endPoint = CGPointMake(1, .5);
////
////    [self.layer insertSublayer:gradientLayer atIndex:0];
//
//
//
//}




@end
