//
//  OscilloscopeChartView.h
//  SciChartDemo
//
//  Created by Yaroslav Pelyukh on 4/6/17.
//  Copyright © 2017 ABT. All rights reserved.
//

#import "OscilloscopeLayout.h"

typedef enum : NSUInteger {
    FourierSeries,
    Lissajous
} DataSourceEnum;

@interface OscilloscopeChartView : OscilloscopeLayout

@end
