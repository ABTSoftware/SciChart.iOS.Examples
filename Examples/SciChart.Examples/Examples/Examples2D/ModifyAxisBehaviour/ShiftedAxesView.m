//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// ShiftedAxesView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "ShiftedAxesView.h"
#import "SCDDataManager.h"

#pragma mark - Inner Top/Left Layout Strategies

@interface CenteredTopAlignmentInnerAxisLayoutStrategy : SCITopAlignmentInnerAxisLayoutStrategy
- (instancetype)initWithYAxis:(id<ISCIAxis>)yAxis;
@end
@implementation CenteredTopAlignmentInnerAxisLayoutStrategy {
    id<ISCIAxis> _yAxis;
}

- (instancetype)initWithYAxis:(id<ISCIAxis>)yAxis {
    self = [super init];
    if (self) {
        _yAxis = yAxis;
    }
    return self;
}

- (void)layoutWithLeft:(CGFloat)left top:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom {
    // find the coordinate of 0 on the Y Axis in pixels
    // place the stack of the top-aligned X Axes at this coordinate
    CGFloat topCoord = [_yAxis.currentCoordinateCalculator getCoordinateFrom:0];
    [SCIHorizontalAxisLayoutStrategy layoutAxesFromTopToBottom:self.axes withLeft:left top:topCoord right:right];
}
@end

@interface CenteredLeftAlignmentInnerAxisLayoutStrategy : SCILeftAlignmentInnerAxisLayoutStrategy
- (instancetype)initWithXAxis:(id<ISCIAxis>)xAxis;
@end
@implementation CenteredLeftAlignmentInnerAxisLayoutStrategy {
    id<ISCIAxis> _xAxis;
}

- (instancetype)initWithXAxis:(id<ISCIAxis>)xAxis {
    self = [super init];
    if (self) {
        _xAxis = xAxis;
    }
    return self;
}

- (void)layoutWithLeft:(CGFloat)left top:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom {
    // find the coordinate of 0 on the X Axis in pixels
    // place the stack of the left-aligned Y Axes at this coordinate
    CGFloat leftCoord = [_xAxis.currentCoordinateCalculator getCoordinateFrom:0];
    [SCIVerticalAxisLayoutStrategy layoutAxesFromLeftToRight:self.axes withLeft:leftCoord top:top bottom:bottom];
}
@end

#pragma mark - Layout Manager

@interface CenterLayoutManager : NSObject<ISCILayoutManager>
- (instancetype)initWithXAxis:(id<ISCIAxis>)xAxis andYAxis:(id<ISCIAxis>)yAxis;
@end
@implementation CenterLayoutManager {
    SCIDefaultLayoutManager *_layoutManager;
    BOOL _isFirstLayout;
}

- (instancetype)initWithXAxis:(id<ISCIAxis>)xAxis andYAxis:(id<ISCIAxis>)yAxis {
    self = [super init];
    if (self) {
        // need to override default inner layout strategies for bottom and right aligned axes
        // because xAxis has right axis alignment and yAxis has bottom axis alignment
        _layoutManager = [SCIDefaultLayoutManager new];
        _layoutManager.leftInnerAxisLayoutStrategy = [[CenteredLeftAlignmentInnerAxisLayoutStrategy alloc] initWithXAxis:xAxis];
        _layoutManager.topInnerAxisLayoutStrategy = [[CenteredTopAlignmentInnerAxisLayoutStrategy alloc] initWithYAxis:yAxis];
    }
    return self;
}

- (void)attachAxis:(id<ISCIAxis>)axis isXAxis:(BOOL)isXAxis {
    [_layoutManager attachAxis:axis isXAxis:isXAxis];
}

- (void)detachAxis:(id<ISCIAxis>)axis {
    [_layoutManager detachAxis:axis];
}

- (void)onAxisPlacementChanged:(id<ISCIAxis>)axis oldAxisAlignment:(SCIAxisAlignment)oldAxisAlignment oldIsCenterAxis:(BOOL)oldIsCenterAxis newAxisAlignment:(SCIAxisAlignment)newAxisAlignment newIsCenterAxis:(BOOL)newIsCenterAxis {
    [_layoutManager onAxisPlacementChanged:axis oldAxisAlignment:oldAxisAlignment oldIsCenterAxis:oldIsCenterAxis newAxisAlignment:newAxisAlignment newIsCenterAxis:newIsCenterAxis];
}

- (void)attachTo:(id<ISCIServiceContainer>)services {
    [_layoutManager attachTo:services];
    
    // need to perform 2 layout passes during first layout of chart
    _isFirstLayout = YES;
}

- (void)detach {
    [_layoutManager detach];
}

- (BOOL)isAttached {
    return _layoutManager.isAttached;
}

- (CGSize)onLayoutChartWithAvailableSize:(CGSize)size {
    // need to perform additional layout pass if it is a first layout pass
    // because we don't know correct size of axes during first layout pass
    if (_isFirstLayout) {
        [_layoutManager onLayoutChartWithAvailableSize:size];
        _isFirstLayout = NO;
    }
    return [_layoutManager onLayoutChartWithAvailableSize:size];
}

@end

@implementation ShiftedAxesView

- (Class)associatedType { return SCIChartSurface.class; }

- (BOOL)showDefaultModifiersInToolbar { return NO; }

- (void)initExample {
    id<ISCIAxis> xAxis = [self newAxisWithAlignment:SCIAxisAlignment_Top];
    id<ISCIAxis> yAxis = [self newAxisWithAlignment:SCIAxisAlignment_Left];
    
    SCDDoubleSeries *butterflyCurve = [SCDDataManager getButterflyCurve:20000];
    SCIXyDataSeries *dataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double];
    dataSeries.acceptsUnsortedData = YES;
    [dataSeries appendValuesX:butterflyCurve.xValues y:butterflyCurve.yValues];
    
    SCIFastLineRenderableSeries *rSeries = [SCIFastLineRenderableSeries new];
    rSeries.dataSeries = dataSeries;
    
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        self.surface.layoutManager = [[CenterLayoutManager alloc] initWithXAxis:xAxis andYAxis:yAxis];
        
        [self.surface.xAxes add:xAxis];
        [self.surface.yAxes add:yAxis];
        [self.surface.renderableSeries add:rSeries];
        [self.surface.chartModifiers add:[SCDExampleBaseViewController createDefaultModifiers]];
        
        [SCIAnimations sweepSeries:rSeries duration:20 andEasingFunction:nil];
    }];
}

- (id<ISCIAxis>)newAxisWithAlignment:(SCIAxisAlignment)axisAlignment {
    id<ISCIAxis> axis = [SCINumericAxis new];
    axis.axisAlignment = axisAlignment;
    axis.majorTickLineStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFFFFFFFF thickness:2];
    axis.textFormatting = @"0.00";
    axis.drawMinorTicks = NO;
    axis.isCenterAxis = YES;
    axis.growBy = [[SCIDoubleRange alloc] initWithMin:0.1 max:0.1];
    
    return axis;
}

@end
