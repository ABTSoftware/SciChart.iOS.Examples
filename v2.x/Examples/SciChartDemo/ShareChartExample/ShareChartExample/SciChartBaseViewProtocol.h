//
//  SciChartBaseViewProtocol.h
//  SciChartDemo
//
//  Created by Yaroslav Pelyukh on 04.05.16.
//  Copyright © 2016 ABT. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SCIChartSurfaceView;
@class SCIChartSurface;

@protocol SciChartBaseViewProtocol <NSObject>

@property (nonatomic, strong) SCIChartSurfaceView * sciChartSurfaceView;

@property (nonatomic, strong) SCIChartSurface * surface;

@end
