//
//  RealtimeGhostTracesLayout.h
//  SciChartDemo
//
//  Created by admin on 3/16/18.
//  Copyright © 2018 ABT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SciChart/SciChart.h>
#import "ExampleViewBase.h"

typedef void(^ActionWithSlider)(UISlider * sender);

@interface RealtimeGhostTracesLayout : ExampleViewBase

@property (nonatomic, copy) ActionWithSlider speedChanged;

@property (weak, nonatomic) IBOutlet UISlider * slider;
@property (weak, nonatomic) IBOutlet UILabel * millisecondsLabel;
@property (weak, nonatomic) IBOutlet SCIChartSurface * surface;

@end
