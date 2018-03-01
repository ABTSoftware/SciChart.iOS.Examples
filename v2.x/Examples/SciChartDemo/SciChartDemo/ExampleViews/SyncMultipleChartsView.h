//
//  MultipleSurfaceView.h
//  SciChartDemo
//
//  Created by Admin on 14.04.16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SciChartBaseViewProtocol.h"

@interface SyncMultipleChartsView : UIView

@property (nonatomic, strong) SCIChartSurface * surface1;
@property (nonatomic, strong) SCIChartSurface * surface2;

@end
