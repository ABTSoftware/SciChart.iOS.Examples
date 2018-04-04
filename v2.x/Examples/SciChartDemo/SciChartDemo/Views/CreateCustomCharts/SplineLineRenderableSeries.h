//
//  SplineLineRenderableSeries.h
//  SciChartDemo
//
//  Created by Admin on 03/05/2017.
//  Copyright © 2017 ABT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SciChart/SciChart.h>

@interface SplineLineRenderableSeries : SCICustomRenderableSeries

@property (nonatomic) BOOL isSplineEnabled;
@property (nonatomic) int upSampleFactor;

@end
