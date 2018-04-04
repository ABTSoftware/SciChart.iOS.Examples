//
//  RealtimeTickingStockChartView.h
//  SciChartDemo
//
//  Created by Yaroslav Pelyukh on 7/19/16.
//  Copyright © 2016 ABT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PriceBar.h"

@interface RealtimeTickingStockChartView : UIView

- (void)onNewPrice:(PriceBar *)price;

@end
