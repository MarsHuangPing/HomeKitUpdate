//
//  BarChartView.h
//  BarChart
//
//  Created by Yuanin2 on 2017/4/14.
//  Copyright © 2017年 YangLu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeKit_ParamsView: UIView

@property(nonatomic,strong) NSDictionary *dataResource;

- (void)startRotateWind;
- (void)stopRotateWind;
- (void)setValuesWithHumidity:(NSInteger)pHumidity co2:(NSString *)pCo2 speed:(NSInteger)pSpeed;

@end
