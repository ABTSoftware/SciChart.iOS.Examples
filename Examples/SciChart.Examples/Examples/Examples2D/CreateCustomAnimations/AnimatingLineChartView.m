//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2022. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// AnimatingLineChartView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "AnimatingLineChartView.h"
#import <SciChart/SCIBaseRenderPassDataTransformation+Protected.h>
#import "SCDRandomUtil.h"
#import "SCDToolbarItem.h"
#import "SCDToolbarButtonsGroup.h"

@interface SCDAppendedPointTransformation : SCIBaseRenderPassDataTransformation<SCILineRenderPassData *>

- (instancetype)init;

@end

@implementation SCDAppendedPointTransformation {
    SCIFloatValues *_originalXCoordinates;
    SCIFloatValues *_originalYCoordinates;
}

- (instancetype)init {
    self = [super initWithRenderPassDataType:SCILineRenderPassData.class];
    if (self) {
        _originalXCoordinates = [SCIFloatValues new];
        _originalYCoordinates = [SCIFloatValues new];
    }
    return self;
}

- (void)saveOriginalData {
    if (!self.renderPassData.isValid) return;
    
    [SCITransformationHelpers copyDataFromSource:self.renderPassData.xCoords toDest:_originalXCoordinates];
    [SCITransformationHelpers copyDataFromSource:self.renderPassData.yCoords toDest:_originalYCoordinates];
}

- (void)applyTransformation {
    if (!self.renderPassData.isValid) return;

    id<ISCICoordinateCalculator> xCalculator = self.renderPassData.xCoordinateCalculator;
    id<ISCICoordinateCalculator> yCalculator = self.renderPassData.yCoordinateCalculator;

    NSInteger count = self.renderPassData.pointsCount;

    float firstXStart = [xCalculator getCoordinateFrom:0];
    float xStart = count <= 1 ? firstXStart : [_originalXCoordinates getValueAt:count - 2];
    float xFinish = [_originalXCoordinates getValueAt:count - 1];
    float additionalX = xStart + (xFinish - xStart) * self.currentTransformationValue;
    [self.renderPassData.xCoords set:additionalX at:count - 1];

    float firstYStart = [yCalculator getCoordinateFrom:0];
    float yStart = count <= 1 ? firstYStart : [_originalYCoordinates getValueAt:count - 2];
    float yFinish = [_originalYCoordinates getValueAt:count - 1];
    float additionalY = yStart + (yFinish - yStart) * self.currentTransformationValue;
    [self.renderPassData.yCoords set:additionalY at:count - 1];
}

- (void)discardTransformation {
    [SCITransformationHelpers copyDataFromSource:_originalXCoordinates toDest:self.renderPassData.xCoords];
    [SCITransformationHelpers copyDataFromSource:_originalYCoordinates toDest:self.renderPassData.yCoords];
}

- (void)onInternalRenderPassDataChanged {
    [self applyTransformation];
}

@end

static int const fifoCapacicty = 20;
static double const timeInterval = 1;
static double const animationDuration = 0.5;
static double const visibleRangeMax = 10;
static double const maxYValue = 100;

@implementation AnimatingLineChartView {
    SCIXyDataSeries *_dataSeries;
    SCIFastLineRenderableSeries *_rSeries;
    
    NSTimer *_timer;
    BOOL _isRunning;
    double _currentXValue;
}

- (Class)associatedType { return SCIChartSurface.class; }

- (BOOL)showDefaultModifiersInToolbar { return NO; }

- (NSArray<id<ISCDToolbarItem>> *)provideExampleSpecificToolbarItems {
    __weak typeof(self) wSelf = self;

    return @[[[SCDToolbarButtonsGroup alloc] initWithToolbarItems:@[
        [[SCDToolbarItem alloc] initWithTitle:@"Start" image:[SCIImage imageNamed:@"chart.play"] andAction:^{ self->_isRunning = YES; }],
        [[SCDToolbarItem alloc] initWithTitle:@"Pause" image:[SCIImage imageNamed:@"chart.pause"] andAction:^{ self->_isRunning = NO; }],
        [[SCDToolbarItem alloc] initWithTitle:@"Stop" image:[SCIImage imageNamed:@"chart.stop"] andAction:^{
            self->_isRunning = NO;
            [wSelf resetChart];
        }],
    ]]];
}

- (void)initExample {
    _dataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double];
    _dataSeries.fifoCapacity = fifoCapacicty;
    
    _rSeries = [SCIFastLineRenderableSeries new];
    _rSeries.dataSeries = _dataSeries;
    _rSeries.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFF4083B7 thickness:6];
    
    _currentXValue = 0;
    
    id<ISCIAxis> xAxis = [SCINumericAxis new];
    xAxis.visibleRange = [[SCIDoubleRange alloc] initWithMin:-1 max:visibleRangeMax];
    
    id<ISCIAxis> yAxis = [SCINumericAxis new];
    yAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.0 max:0.1];
    yAxis.visibleRange = [[SCIDoubleRange alloc] initWithMin:0 max:maxYValue];
    
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        [self.surface.xAxes add:xAxis];
        [self.surface.yAxes add:yAxis];
        [self.surface.renderableSeries add:self->_rSeries];
    }];
    
    [self p_SCD_addPointAnimated];
    _timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(p_SCD_updateData) userInfo:nil repeats:YES];
    _isRunning = YES;
}

- (void)p_SCD_updateData {
    if (!_isRunning) return;
    
    [self p_SCD_addPointAnimated];
}

- (void)p_SCD_addPointAnimated {
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        [self->_dataSeries appendX:@(self->_currentXValue) y:@(SCDRandomUtil.nextDouble * maxYValue)];
    }];
    
    [SCIAnimations animateSeries:_rSeries withTransformation:[SCDAppendedPointTransformation new] duration:animationDuration andEasingFunction:[SCICubicEase new]];
    
    _currentXValue += timeInterval;
    
    [self p_SCD_animateVisibleRangeIfNeeded];
}

- (void)p_SCD_animateVisibleRangeIfNeeded {
    if (_currentXValue > visibleRangeMax) {
        id<ISCIAxis> xAxis = [self.surface.xAxes itemAt:0];
        id<ISCIRange> newRange = [[SCIDoubleRange alloc] initWithMin:xAxis.visibleRange.minAsDouble + timeInterval max:xAxis.visibleRange.maxAsDouble + timeInterval];
        [xAxis animateVisibleRangeTo:newRange withDuration:animationDuration];
    }
}

- (void)resetChart {
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        [self->_dataSeries clear];
    }];
    
    _currentXValue = 0;
    id<ISCIAxis> xAxis = [self.surface.xAxes itemAt:0];
    [xAxis animateVisibleRangeTo:[[SCIDoubleRange alloc] initWithMin:-1 max:visibleRangeMax] withDuration:animationDuration];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [_timer invalidate];
    _timer = nil;
}

@end
