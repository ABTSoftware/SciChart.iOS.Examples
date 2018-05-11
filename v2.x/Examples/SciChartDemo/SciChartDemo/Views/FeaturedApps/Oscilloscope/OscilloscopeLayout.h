//
//  OscilloscoppeChartLayout.h
//  SciChartDemo
//
//  Created by admin on 4/5/18.
//  Copyright © 2018 ABT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SciChart/SciChart.h>
#import "ExampleViewBase.h"

@interface OscilloscopeLayout : ExampleViewBase

@property (weak, nonatomic) IBOutlet SCIChartSurface * surface;

@property (nonatomic, copy) SCIActionBlock seriesTypeTouched;
@property (nonatomic, copy) SCIActionBlock rotateTouched;
@property (nonatomic, copy) SCIActionBlock flippedVerticallyTouched;
@property (nonatomic, copy) SCIActionBlock flippedHorizontallyTouched;

@end
