//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// FixedWidthAxisChartView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "FixedWidthAxisChartView.h"
#import "SCDDataManager.h"

#pragma mark - Chart Initialization

@implementation FixedWidthAxisChartView

- (Class)associatedType { return SCIChartSurface.class; }

- (BOOL)showDefaultModifiersInToolbar { return NO; }

- (void)initExample {
    NSMutableArray<id<ISCIXyDataSeries>> *dataSeries = [NSMutableArray<id<ISCIXyDataSeries>> new];
    SCIXyDataSeries *ds = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double];
    [dataSeries addObject:ds];
    
    SCDDoubleSeries *sinewave = [SCDDataManager getSinewaveWithAmplitude:3 Phase:0 PointCount:1000];
    [ds appendValuesX:sinewave.xValues y:sinewave.yValues];
    
    self.yLeftAxisTitle = @"Y Left Axis";
    self.yLeftAxis = [self newAxisWithTitle:self.yLeftAxisTitle axisAlignment:SCIAxisAlignment_Left axisTickLabelAlignment:self.yLeftAxisTickLabelAlignment axisTitleAlignment:SCIAlignment_Center textFormatting:@"$ 0.0"];
    self.yLeftAxis.axisThickness = 60;
    
    self.yRightAxisTitle = @"Y Right Axis";
    self.yRightAxis = [self newAxisWithTitle:self.yRightAxisTitle axisAlignment:SCIAxisAlignment_Right axisTickLabelAlignment:self.yRightAxisTickLabelAlignment axisTitleAlignment:SCIAlignment_Center textFormatting:@"0.0"];
    self.yRightAxis.axisId = @"Ch2";
    
    self.xBottomAxisTitle = @"x Bottom Axis";
    self.xBottomAxis = [self newAxisWithTitle:self.xBottomAxisTitle axisAlignment:SCIAxisAlignment_Bottom axisTickLabelAlignment:self.xBottomAxisTickLabelAlignment axisTitleAlignment:SCIAlignment_Center textFormatting:@"0.0"];
    self.xBottomAxis.axisThickness = 50;
    
    self.xTopAxisTitle = @"x Top Axis";
    self.xTopAxis = [self newAxisWithTitle:self.xTopAxisTitle axisAlignment:SCIAxisAlignment_Top axisTickLabelAlignment:self.xTopAxisTickLabelAlignment axisTitleAlignment:SCIAlignment_Center textFormatting:@"0.0"];
    self.xTopAxis.axisId = @"Ch2";
    
    SCIFastLineRenderableSeries *rSeries = [SCIFastLineRenderableSeries new];
    rSeries.dataSeries = dataSeries[0];
    rSeries.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFFFF1919 thickness:1];
    
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        [self.surface.xAxes add:self.xBottomAxis];
        [self.surface.yAxes add:self.yLeftAxis];
        [self.surface.xAxes add:self.xTopAxis];
        [self.surface.yAxes add:self.yRightAxis];
        
        [self.surface.renderableSeries add:rSeries];
        
        [self.surface.chartModifiers add:[SCDExampleBaseViewController createDefaultModifiers]];
    }];
    
    [self.surface zoomExtents];
}

- (SCINumericAxis *)newAxisWithTitle:(NSString *)axisTitle
                       axisAlignment:(SCIAxisAlignment)axisAlignment
               axisTickLabelAlignment:(SCIAlignment)axisTickLabelAlignment
                axisTitleAlignment:(SCIAlignment)axisTitleAlignment
                     textFormatting:(NSString *)textFormatting {
    SCINumericAxis *axis = [[SCINumericAxis alloc] init];
    
    if (axisAlignment) {
        axis.axisAlignment = axisAlignment;
    }
    
    axis.axisTitle = axisTitle;
    axis.visibleRange = [[SCIDoubleRange alloc] initWithMin:-2 max:2];
    axis.autoRange = SCIAutoRange_Never;
    axis.drawMajorBands = NO;
    axis.drawMajorGridLines = NO;
    axis.drawMinorGridLines = NO;
    
    if (axisTitleAlignment) {
        axis.axisTitleAlignment = axisTitleAlignment;
    }
    
    if (textFormatting) {
        axis.textFormatting = textFormatting;
    }
    
    if (axisTickLabelAlignment) {
#if TARGET_OS_OSX
        axis.axisTickLabelStyle = [[SCIAxisTickLabelStyle alloc] initWithAlignment:axisTickLabelAlignment andMargins:NSEdgeInsetsZero];
#else
        axis.axisTickLabelStyle = [[SCIAxisTickLabelStyle alloc] initWithAlignment:axisTickLabelAlignment andMargins:UIEdgeInsetsZero];
#endif
    }
    
    return axis;
}


@end
