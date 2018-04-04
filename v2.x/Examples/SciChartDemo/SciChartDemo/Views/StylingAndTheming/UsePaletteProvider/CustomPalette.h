//
//  CustomPalette.h
//  SciChartDemo
//
//  Created by Yaroslav Pelyukh on 27/04/2017.
//  Copyright © 2017 ABT. All rights reserved.
//

#import <SciChart/SciChart.h>

typedef enum : NSUInteger {
    line,
    column,
    ohlc,
    mountain,
    candles,
    scatter
} RenderableSeriesType;

@interface CustomPalette : SCIPaletteProvider

@end
