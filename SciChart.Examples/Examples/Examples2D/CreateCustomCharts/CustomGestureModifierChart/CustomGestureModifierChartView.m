//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// ImpulseChartView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "CustomGestureModifierChartView.h"
#import "SCDDataManager.h"
#import "SCDCustomGestureModifier.h"

@implementation CustomGestureModifierChartView

- (Class)associatedType { return SCIChartSurface.class; }

- (BOOL)showDefaultModifiersInToolbar { return NO; }

- (void)initExample {
    id<ISCIAxis> xAxis = [SCINumericAxis new];
    xAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.1 max:0.1];
    
    id<ISCIAxis> yAxis = [SCINumericAxis new];
    yAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.1 max:0.1];
    
    SCDDoubleSeries *ds1Points = [SCDDataManager getDampedSinewaveWithAmplitude:1.0 DampingFactor:0.05 PointCount:50 Freq:5];
    SCIXyDataSeries *dataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double];
    [dataSeries appendValuesX:ds1Points.xValues y:ds1Points.yValues];
    
    SCIEllipsePointMarker *ellipsePointMarker = [SCIEllipsePointMarker new];
    ellipsePointMarker.strokeStyle = SCIPenStyle.TRANSPARENT;
    ellipsePointMarker.fillStyle = [[SCISolidBrushStyle alloc] initWithColorCode:0xFF47bde6];
    ellipsePointMarker.size = CGSizeMake(10, 10);
    
    SCIFastImpulseRenderableSeries *rSeries = [SCIFastImpulseRenderableSeries new];
    rSeries.dataSeries = dataSeries;
    rSeries.pointMarker = ellipsePointMarker;
    rSeries.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFF47bde6 thickness:1.0];
    
#if TARGET_OS_OSX
    NSString *zoomText = @"Pan vertically to Zoom In/Out.";
#elif TARGET_OS_IOS
    NSString *zoomText = @"Double Tap and pan vertically to Zoom In/Out.";
#endif
    
    SCITextAnnotation *annotation = [SCITextAnnotation new];
    annotation.text = [NSString stringWithFormat:@"%@ %@",zoomText, @"\nDouble tap to Zoom Extents."];
    annotation.fontStyle = [[SCIFontStyle alloc] initWithFontSize:16 andTextColor:SCIColor.whiteColor];
    annotation.x1 = @(0.5);
    annotation.y1 = @(0);
    annotation.coordinateMode = SCIAnnotationCoordinateMode_Relative;
    annotation.verticalAnchorPoint = SCIVerticalAnchorPoint_Top;
    annotation.horizontalAnchorPoint = SCIHorizontalAnchorPoint_Center;
    
    SCDCustomGestureModifier *customGestureModifier = [SCDCustomGestureModifier new];
    customGestureModifier.receiveHandledEvents = YES;
    
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        [self.surface.xAxes add:xAxis];
        [self.surface.yAxes add:yAxis];
        [self.surface.renderableSeries add:rSeries];
        [self.surface.annotations add:annotation];
        [self.surface.chartModifiers addAll:customGestureModifier, [SCIZoomExtentsModifier new], nil];

        [SCIAnimations waveSeries:rSeries duration:3.0 andEasingFunction:[SCICubicEase new]];
    }];
}

@end
