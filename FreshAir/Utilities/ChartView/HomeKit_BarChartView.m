//
//  BarChartView.m
//  BarChart
//
//  Created by Mars on 2017/4/14.
//  Copyright © 2017年 Mars. All rights reserved.
//



#define kChartBoxWidth self.frame.size.width - BarChartRightSpacing - BarChartLeftSpacing

#define BarChartLeftSpacing  40
#define BarChartRightSpacing 30
#define barChartColumnW 15

#define kTopMargin 90
#define kBottomMargin 60
#define kChartBoxHeight (self.frame.size.height - kTopMargin - kBottomMargin)

#import "HomeKit_BarChartView.h"
#import "HomeKit_FontManager.h"


@interface HomeKit_BarChartView()
//y轴刻度
@property(nonatomic,strong) NSMutableArray *yArr;

@property(nonatomic,copy) NSString *yUnit;//Y轴单位

@property(nonatomic, assign) int level;

@property(nonatomic, copy) NSString *type;

@property(nonatomic,assign)int avverage;//平均值

@end
@implementation HomeKit_BarChartView
-(NSMutableArray *)yArr{
    if(!_yArr){
        _yArr = [NSMutableArray array];
    }
    return _yArr;
}
-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 5;
        
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

-(void)setDataResource:(NSArray *)dataResource{
    _dataResource = dataResource;
    [self getYDataArrWithDataResource:_dataResource];
    
}


-(void)drawRect:(CGRect)rect{
    
    if(self.yArr.count == 0) return;
    
    self.backgroundColor = [UIColor whiteColor];
    self.clipsToBounds = YES;
    self.layer.cornerRadius = 5;
    //创建画布
    
    float threshould = 20;
    float barWidth,interval;
    NSInteger totalCount = 6+14;
    float chartBoxWidth = kChartBoxWidth;
    if(chartBoxWidth/totalCount>threshould){
        barWidth = threshould;
        interval = (chartBoxWidth - 14 * barWidth)/6;
    }
    else{
        barWidth = chartBoxWidth/(6+14);
        interval = barWidth;
    }
    
    CGContextRef ctr = UIGraphicsGetCurrentContext();
    //title
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.alignment = NSTextAlignmentLeft;
    NSDictionary * attribute = @{NSFontAttributeName:[[HomeKit_FontManager sharedInstance] fontWithSize_14],NSParagraphStyleAttributeName:paragraph,NSForegroundColorAttributeName:[[HomeKit_FontManager sharedInstance] chartTitleColor]};
    
    [self.yUnit drawInRect:CGRectMake(8,  25, 130, 22) withAttributes:attribute];
    
    //mark
    NSDictionary * attributeSmall= @{NSFontAttributeName:[[HomeKit_FontManager sharedInstance] fontWithSize_13],NSParagraphStyleAttributeName:paragraph,NSForegroundColorAttributeName:[UIColor colorWithRed:187.0/255.0 green:187.0/255.0 blue:187.0/255.0 alpha:1.0]};
    [self addImageViewWithImage:[UIImage imageNamed:@"chart_circle_blue"] frame:CGRectMake(self.frame.size.width - 140,  25, 15, 15)];
    [@"室内" drawInRect:CGRectMake(self.frame.size.width - 120,  25, 40, 22) withAttributes:attributeSmall];
    [self addImageViewWithImage:[UIImage imageNamed:@"chart_circle_orange"] frame:CGRectMake(self.frame.size.width - 70,  25, 15, 15)];
    [@"室外" drawInRect:CGRectMake(self.frame.size.width - 50,  25, 40, 22) withAttributes:attributeSmall];
    
    NSInteger yLableText = 12;
    NSInteger chatBoxHeight = self.frame.size.height - kTopMargin - kBottomMargin;
    NSInteger ySpacing = (chatBoxHeight)/5;
    //绘制区域轴
    
    NSMutableParagraphStyle *paragraphOrdinate = [[NSMutableParagraphStyle alloc] init];
    paragraphOrdinate.alignment = NSTextAlignmentRight;
    NSDictionary * attributeOrdinate= @{NSFontAttributeName:[[HomeKit_FontManager sharedInstance] fontWithSize_12],NSParagraphStyleAttributeName:paragraphOrdinate,NSForegroundColorAttributeName:[UIColor colorWithRed:187.0/255.0 green:187.0/255.0 blue:187.0/255.0 alpha:1.0]};

    
    for (int i = 0 ; i < 6 ; i++) {
        
        [[UIColor colorWithRed:187.0/255.0 green:187.0/255.0 blue:187.0/255.0 alpha:1.0] set];
        
        if (i==0) {
            CGContextSetLineWidth(ctr, 0.5);
            CGContextMoveToPoint(ctr, BarChartLeftSpacing, kTopMargin * (i + 1));
            CGContextAddLineToPoint(ctr, self.frame.size.width - BarChartRightSpacing, kTopMargin);
            CGContextStrokePath(ctr);
            //绘制y轴刻度
            [self.yArr[5 - i] drawInRect:CGRectMake(8, kTopMargin - yLableText, BarChartLeftSpacing - 10, 22) withAttributes:attributeOrdinate];
        }else if (i==5){
            CGContextSetLineWidth(ctr, 0.5);
            CGContextMoveToPoint(ctr, BarChartLeftSpacing, ySpacing * 5 + kTopMargin);
            CGContextAddLineToPoint(ctr, self.frame.size.width - BarChartRightSpacing, ySpacing * 5 + kTopMargin);
            CGContextStrokePath(ctr);
            //绘制y轴刻度
            [self.yArr[5 - i] drawInRect:CGRectMake(8, kTopMargin+ySpacing * 5 - yLableText, BarChartLeftSpacing - 10, 22) withAttributes:attributeOrdinate];
        }else{
            CGContextSetLineWidth(ctr, 0.5);
            CGContextMoveToPoint(ctr, BarChartLeftSpacing, kTopMargin+ySpacing*i);
            CGContextAddLineToPoint(ctr, self.frame.size.width - BarChartRightSpacing, kTopMargin+ySpacing*i);
            CGContextStrokePath(ctr);
            //绘制y轴刻度
            [self.yArr[5 - i] drawInRect:CGRectMake(8, kTopMargin+ySpacing*i - yLableText, BarChartLeftSpacing - 10, 22) withAttributes:attributeOrdinate];
        }
        
        
    }
    
    
    //绘制x轴
    for (int i = 0; i < 7 ; i++) {
        [self drawAbscissaWithCtr:ctr
                             from:CGPointMake(BarChartLeftSpacing + barWidth + i * (barWidth * 2 +interval) , ySpacing * 5 + kTopMargin)
                               to:CGPointMake(BarChartLeftSpacing + barWidth + i * (barWidth * 2 +interval), ySpacing * 5 + kTopMargin + 3)];
        
    }
    
    UIImage *imgInner = [UIImage imageNamed:@"barblue"];
    UIImage *imgOuter = [UIImage imageNamed:@"bar"];
//handle for crash
    if(self.dataResource.count < 7){
        return;
    }
    
    for (int i = 0 ; i < 7 ; i++) {
        
        //绘制X轴坐标
        NSDictionary *dataDic = self.dataResource[i];
        NSString *date = dataDic[@"date"];
        
        NSString *value1 = dataDic[@"value1"];
        CGFloat num1 = [value1 floatValue] / self.level;
        CGFloat scale1 = 0.0;
        scale1=num1/[[self.yArr lastObject] floatValue];
        
        NSInteger barHeight1 = scale1 * chatBoxHeight;
        
        NSInteger x1 = round(BarChartLeftSpacing + i * (barWidth * 2 +interval));
        NSInteger x2 = x1 + round(barWidth);
        
        [self drawMyRectWithCornerX:x1
                               andY:ySpacing * 5 + kTopMargin
                          andRadius:10
                           andWidth:round(barWidth)
                          andHeight:- barHeight1
                             andCtr:ctr
                                 bg:imgInner];
        
        NSString *value2 = dataDic[@"value2"];
        CGFloat num2 = [value2 floatValue] / self.level;
        CGFloat scale2 = 0.0;
        scale2=num2/[[self.yArr lastObject] floatValue];
        NSInteger barHeight2 = scale2 * chatBoxHeight;
        [self drawMyRectWithCornerX:x2
                               andY:ySpacing * 5 + kTopMargin
                          andRadius:10
                           andWidth:round(barWidth)
                          andHeight:- barHeight2
                             andCtr:ctr
                                 bg:imgOuter];
        
        //绘制柱子
        UILabel *lblDate = [[UILabel alloc] initWithFrame:CGRectMake(BarChartLeftSpacing + i * (barWidth * 2 +interval),
                                                                      self.frame.size.height - kBottomMargin,
                                                                        barWidth * 2, 22)];
        lblDate.font = [[HomeKit_FontManager sharedInstance] fontWithSize_11];
        lblDate.text = date;
        lblDate.textAlignment = NSTextAlignmentCenter;
        lblDate.textColor = [UIColor colorWithRed:187.0/255.0 green:187.0/255.0 blue:187.0/255.0 alpha:1.0];
        lblDate.adjustsFontSizeToFitWidth = YES;
        [self addSubview:lblDate];
    }
    
    //footer
    paragraph.alignment = NSTextAlignmentLeft;
    NSDictionary * attributeFooter = @{NSFontAttributeName:[[HomeKit_FontManager sharedInstance] fontWithSize_12],NSParagraphStyleAttributeName:paragraph,NSForegroundColorAttributeName:[UIColor colorWithRed:187.0/255.0 green:187.0/255.0 blue:187.0/255.0 alpha:1.0]};
    NSInteger footerHeightY = self.frame.size.height - 30;
    [@"室外数据来自PM2.5" drawInRect:CGRectMake(8,  footerHeightY, 130, 22) withAttributes:attributeFooter];
}

- (void)addImageViewWithImage:(UIImage *)pImage frame:(CGRect)pFrame
{
    UIImageView *iv = [[UIImageView alloc] initWithFrame:pFrame];
    iv.image = pImage;
    [self addSubview:iv];
}

- (void)drawAbscissaWithCtr:(CGContextRef)pCtr from:(CGPoint)pFrom to:(CGPoint)pTo
{
    CGContextSetLineWidth(pCtr, 0.5);
    [[UIColor colorWithRed:187.0/255.0 green:187.0/255.0 blue:187.0/255.0 alpha:1.0] set];
    CGContextMoveToPoint(pCtr, pFrom.x, pFrom.y);
    CGContextAddLineToPoint(pCtr, pTo.x, pTo.y);
    CGContextStrokePath(pCtr);
}

- (void)drawMyRectWithCornerX:(CGFloat)x andY:(CGFloat)y andRadius:(CGFloat)radius andWidth:(CGFloat)width andHeight:(CGFloat)height andCtr:(CGContextRef)ctr bg:(UIImage *)pBg
{
    UIImageView  *ivBar=[[UIImageView alloc] init];
    ivBar.frame=CGRectMake(x, y, width, height);
    ivBar.alpha = .9;
    [self addSubview:ivBar];
    

    UIGraphicsBeginImageContextWithOptions(ivBar.bounds.size, NO, 1.0);
    [[UIBezierPath bezierPathWithRoundedRect:ivBar.bounds
                           byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerTopRight)
                                 cornerRadii:CGSizeMake(10, 10)] addClip];
    // Draw your image
    [pBg drawInRect:ivBar.bounds];
    
    // Get the image, here setting the UIImageView image
    ivBar.image = UIGraphicsGetImageFromCurrentImageContext();
    
    // Lets forget about that we were drawing
    UIGraphicsEndImageContext();
    
    ivBar.frame=CGRectMake(x, y, width, 0);
    [UIView animateWithDuration:1.0 animations:^{
        ivBar.frame=CGRectMake(x, y, width, height);
        ivBar.clipsToBounds = YES;
//        [ivBar layoutIfNeeded];
    }];
    
}


-(void)getYDataArrWithDataResource:(NSArray *)dataResource{
    
    CGFloat maxValue = [self maxValueWithDataResource:dataResource];
    
    [self getUnitWithMaxValues:maxValue];
}

-(CGFloat)maxValueWithDataResource:(NSArray *)dataResource{
    //获取最大值
    if(self.dataResource.count == 0) return 0;
    if(![self.dataResource[0] isKindOfClass:[NSDictionary class]]) return 0;
    NSDictionary *dic = self.dataResource[0];
    NSInteger maxValue = [dic[@"value1"] integerValue];
    NSInteger compareValue = [dic[@"value2"] integerValue];
    if(maxValue < compareValue){
        maxValue = compareValue;
    }
    
    for(int i = 1 ; i < dataResource.count ; i++){
        NSDictionary *dic = self.dataResource[i];
        NSInteger compareValue1 = [dic[@"value1"] integerValue];
        if(maxValue < compareValue1){
            maxValue = compareValue1;
        }
        
        NSInteger compareValue2 = [dic[@"value2"] integerValue];
        if(maxValue < compareValue2){
            maxValue = compareValue2;
        }
    }
    
    NSInteger delta = 10;
    NSInteger multiple = maxValue/delta;
    NSInteger remainder = maxValue % delta;
    NSInteger result = multiple * delta;
    if(remainder != 0){
        result = result + delta;
    }
    
    return result;
    
}
-(void)getUnitWithMaxValues:(CGFloat)maxValue{
    CGFloat AverageValue=maxValue/5.0;
    self.avverage=(int)ceilf(AverageValue);
    for (int i=0; i<6; i++) {
        [self.yArr addObject:[NSString stringWithFormat:@"%d",self.avverage*i]];
    }
    self.yUnit=@"近7日空气质量对比";
    self.level = 1.00;
}



@end
