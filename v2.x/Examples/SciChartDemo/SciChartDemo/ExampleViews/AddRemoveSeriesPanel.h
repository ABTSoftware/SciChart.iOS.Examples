//
//  AddRemoveSeriesPanel.h
//  SciChartDemo
//
//  Created by Yaroslav Pelyukh on 25/04/2017.
//  Copyright © 2017 ABT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LinePerformanceControlPanelView.h"

@interface AddRemoveSeriesPanel : UIView

@property (nonatomic, copy) Callback onClearClicked;
@property (nonatomic, copy) Callback onAddClicked;
@property (nonatomic, copy) Callback onRemoveClicked;

@end
