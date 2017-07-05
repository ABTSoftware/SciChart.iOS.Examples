//
//  RealTimeTickingStocksControlPanelView.h
//  SciChartDemo
//
//  Created by Yaroslav Pelyukh on 7/20/16.
//  Copyright © 2016 ABT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SciChartBaseViewProtocol.h"

typedef void(^Callback)(UIButton *sender);

@interface RealTimeTickingStocksControlPanelView : UIView

@property (nonatomic, copy) Callback seriesTypeTouched;
@property (nonatomic, copy) Callback pauseTickingTouched;
@property (nonatomic, copy) Callback continueTickingTouched;

@end
