//
//  MLDataPicker.h
//  NewPeek2
//
//  Created by Tyler on 13-4-23.
//  Copyright (c) 2013年 Delaware consulting. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MLPicker.h"

@protocol MLDataPickerDelegate;

@interface MLDataPicker : MLPicker

@property (nonatomic, weak) id<MLDataPickerDelegate> delegate;

- (id)initWithDefaultIndex:(int)pIndex
                     items:(NSMutableArray *)pItems;

@end

@protocol MLDataPickerDelegate <NSObject>

- (void)dataPicker:(MLDataPicker *)pDataPicker index:(NSInteger)pIndex;

@end
