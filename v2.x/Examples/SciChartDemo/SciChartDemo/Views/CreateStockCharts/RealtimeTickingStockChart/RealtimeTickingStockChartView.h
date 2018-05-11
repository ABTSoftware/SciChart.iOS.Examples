//
//  RealtimeTickingStockChartView.h
//  SciChartDemo
//
//  Created by Yaroslav Pelyukh on 7/19/16.
//  Copyright © 2016 ABT. All rights reserved.
//

#import "RealtimeTickingStockChartLayout.h"
#import "PriceBar.h"

@interface RealtimeTickingStockChartView : RealtimeTickingStockChartLayout

- (void)onNewPrice:(PriceBar *)price;

@end
