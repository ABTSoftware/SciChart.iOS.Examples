//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// BandChartView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "IncludeAxisModifiersView.h"
#import "SCDDataManager.h"

@implementation IncludeAxisModifiersView {
    NSString *xAxisId;
    NSString *yLeftAxisId;
    NSString *yRightAxisId;
}

- (Class)associatedType { return SCIChartSurface.class; }

- (void)initExample {
    
    xAxisId = @"xAxis";
    yLeftAxisId = @"yLeftAxis";
    yRightAxisId = @"yRightAxis";
    
    // MARK: - Axes
    // Create X Axis
    SCINumericAxis *xAxis = [SCINumericAxis new];
    xAxis.axisId = xAxisId;
    xAxis.axisAlignment = SCIAxisAlignment_Bottom;
    xAxis.axisTitle = @"X Axis (Shared)";
    xAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.1 max:0.1];

    // Create Left Y Axis
    SCINumericAxis *yLeftAxis = [SCINumericAxis new];
    yLeftAxis.axisId = yLeftAxisId;
    yLeftAxis.axisAlignment = SCIAxisAlignment_Left;
    yLeftAxis.axisTitle = @"Left Y Axis (Not Fixed)";
    yLeftAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.1 max:0.2];
    yLeftAxis.tickLabelStyle = [[SCIFontStyle alloc] initWithFontSize:12
                                                    andTextColorCode:0xFF47BDE6];

    // Create Right Y Axis
    SCINumericAxis *yRightAxis = [SCINumericAxis new];
    yRightAxis.axisId = yRightAxisId;
    yRightAxis.axisAlignment = SCIAxisAlignment_Right;
    yRightAxis.axisTitle = @"Right Y Axis (Fixed)";
    yRightAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.1 max:0.1];
    yRightAxis.tickLabelStyle = [[SCIFontStyle alloc] initWithFontSize:12
                                                     andTextColorCode:0xFFAE418D];

    // MARK: - Data Series
    // Create data series for left axis
    SCDDoubleSeries *leftData = [SCDDataManager getFourierSeriesWithAmplitude:1.0
                                                                  phaseShift:0.1
                                                                       count:5000];
    SCIXyDataSeries *leftDataSeries =
        [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double];
    [leftDataSeries appendValuesX:leftData.xValues y:leftData.yValues];

    // Create data series for right axis
    SCDDoubleSeries *rightData = [SCDDataManager getDampedSinewaveWithAmplitude:3.0 DampingFactor:0.005 PointCount:5000 Freq:10];
    SCIXyDataSeries *rightDataSeries =
        [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double];
    [rightDataSeries appendValuesX:rightData.xValues y:rightData.yValues];

    // MARK: - Renderable Series
    // Create renderable series for left axis
    SCIFastLineRenderableSeries *leftSeries = [SCIFastLineRenderableSeries new];
    leftSeries.dataSeries = leftDataSeries;
    leftSeries.xAxisId = xAxisId;
    leftSeries.yAxisId = yLeftAxisId;
    leftSeries.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFF47BDE6
                                                                thickness:2.0];

    // Create renderable series for right axis
    SCIFastLineRenderableSeries *rightSeries = [SCIFastLineRenderableSeries new];
    rightSeries.dataSeries = rightDataSeries;
    rightSeries.xAxisId = xAxisId;
    rightSeries.yAxisId = yRightAxisId;
    rightSeries.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFFAE418D
                                                                 thickness:2.0];

    // MARK: - Modifiers
    // Create ZoomPanModifier that ONLY works on LEFT Y AXIS
    SCIZoomPanModifier *zoomPanModifier = [SCIZoomPanModifier new];
    zoomPanModifier.receiveHandledEvents = YES;
    [zoomPanModifier includeYAxis:yRightAxis isIncluded:NO];

    // Create PinchZoomModifier that ONLY works on LEFT Y AXIS
    SCIPinchZoomModifier *pinchZoomModifier = [SCIPinchZoomModifier new];
    pinchZoomModifier.receiveHandledEvents = YES;
    [pinchZoomModifier includeYAxis:yRightAxis isIncluded:NO];

    // Create Y Axis Drag Modifier that ONLY works on LEFT Y AXIS
    SCIYAxisDragModifier *yAxisDragModifier = [SCIYAxisDragModifier new];
    [yAxisDragModifier includeYAxis:yRightAxis isIncluded:NO];

    // Create X Axis Drag Modifier (works on X axis by default)
    SCIXAxisDragModifier *xAxisDragModifier = [SCIXAxisDragModifier new];

    // Create Zoom Extents Modifier that EXCLUDES the RIGHT Y AXIS
    SCIZoomExtentsModifier *zoomExtentsModifier = [SCIZoomExtentsModifier new];
    [zoomExtentsModifier includeYAxis:yRightAxis isIncluded:NO];

    // MARK: - Annotation
    SCITextAnnotation *annotation = [SCITextAnnotation new];
    annotation.text = @"Try pinch-zoom and Y-axis drag:\n"
                       "• Left Y Axis (blue) is zoomable\n"
                       "• Right Y Axis (purple) is fixed\n"
                       "• Double-tap zooms only left axis";
    [annotation setX1:@1];
    [annotation setY1:@3.5];
    annotation.yAxisId = yLeftAxisId;
    annotation.xAxisId = xAxisId;
    annotation.verticalAnchorPoint = SCIVerticalAnchorPoint_Bottom;
    annotation.fontStyle = [[SCIFontStyle alloc] initWithFontSize:14
                                                   andTextColor:SCIColor.whiteColor];

    // MARK: - Chart Setup
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        [self.surface.xAxes add:xAxis];
        [self.surface.yAxes add:yLeftAxis];
        [self.surface.yAxes add:yRightAxis];
        [self.surface.renderableSeries add:leftSeries];
        [self.surface.renderableSeries add:rightSeries];
        [self.surface.annotations add:annotation];
        [self.surface.chartModifiers addAll:zoomPanModifier,
                                            pinchZoomModifier,
                                            yAxisDragModifier,
                                            xAxisDragModifier,
                                            zoomExtentsModifier, nil];
    }];

}

@end
