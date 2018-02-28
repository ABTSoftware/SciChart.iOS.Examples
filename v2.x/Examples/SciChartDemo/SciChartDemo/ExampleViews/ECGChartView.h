//
//  ECGChartView.h
//  SciChartDemo
//
//  Created by Admin on 21.03.16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SciChartBaseViewProtocol.h"

typedef enum : NSUInteger {
    TraceA,
    TraceB
} TraceAOrB;

@interface ECGChartView : UIView<SciChartBaseViewProtocol>

@end
