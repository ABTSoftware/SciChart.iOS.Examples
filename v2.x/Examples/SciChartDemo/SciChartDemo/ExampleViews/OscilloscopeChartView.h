//
//  OscilloscopeChartView.h
//  SciChartDemo
//
//  Created by Yaroslav Pelyukh on 4/6/17.
//  Copyright © 2017 ABT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SciChartBaseViewProtocol.h"

typedef enum : NSUInteger {
    FourierSeries,
    Lissajous
} DataSourceEnum;

@interface OscilloscopeChartView : UIView<SciChartBaseViewProtocol>

@end
