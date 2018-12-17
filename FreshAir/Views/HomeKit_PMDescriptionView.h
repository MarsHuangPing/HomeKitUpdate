//
//  PMDescriptionView.h
//  FreshAir
//
//  Created by mars on 24/03/2018.
//  Copyright © 2018 mars. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PMDescriptionViewDelegate <NSObject>
- (void)updateConstraint:(float)pWidth;
@end


@interface HomeKit_PMDescriptionView : UIView

@property (nonatomic, assign) id<PMDescriptionViewDelegate> delegate;

- (void)updatePMDescriptionWithPMValue:(NSInteger)pValue description:(NSString *)pDescription;

@end
