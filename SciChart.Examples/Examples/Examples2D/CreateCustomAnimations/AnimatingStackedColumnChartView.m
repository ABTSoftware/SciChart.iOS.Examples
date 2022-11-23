//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2022. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// AnimatingStackedColumnChartView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "AnimatingStackedColumnChartView.h"
#import <SciChart/SCIBaseRenderPassDataTransformation+Protected.h>
#import "SCDRandomUtil.h"
#import "SCDToolbarButton.h"
#import "SCDToolbarButtonsGroup.h"

@interface SCDUpdatedPointTransformation : SCIBaseRenderPassDataTransformation<SCIStackedColumnRenderPassData *>

- (instancetype)init;

@end

@implementation SCDUpdatedPointTransformation {
    SCIFloatValues *_startYCoordinates;
    SCIFloatValues *_startPrevSeriesYCoordinates;
    
    SCIFloatValues *_originalYCoordinates;
    SCIFloatValues *_originalPrevSeriesYCoordinates;
}

- (instancetype)init {
    self = [super initWithRenderPassDataType:SCIStackedColumnRenderPassData.class];
    if (self) {
        _startYCoordinates = [SCIFloatValues new];
        _startPrevSeriesYCoordinates = [SCIFloatValues new];
        
        _originalYCoordinates = [SCIFloatValues new];
        _originalPrevSeriesYCoordinates = [SCIFloatValues new];
    }
    return self;
}

- (void)saveOriginalData {
    if (!self.renderPassData.isValid) return;
    
    [SCITransformationHelpers copyDataFromSource:self.renderPassData.yCoords toDest:_originalYCoordinates];
    [SCITransformationHelpers copyDataFromSource:self.renderPassData.prevSeriesYCoords toDest:_originalPrevSeriesYCoordinates];
}

- (void)applyTransformation {
    if (!self.renderPassData.isValid) return;
    
    NSInteger count = self.renderPassData.pointsCount;
    
    if (_startPrevSeriesYCoordinates.count != count ||
        _startYCoordinates.count != count ||
        _originalYCoordinates.count != count ||
        _originalPrevSeriesYCoordinates.count != count) {
        return;
    }
    
    float currentTransformationValue = self.currentTransformationValue;

    for (NSInteger i = 0; i < count; i++) {
        float startYCoord = [_startYCoordinates getValueAt:i];
        float originalYCoordinate = [_originalYCoordinates getValueAt:i];
        float additionalY = startYCoord + (originalYCoordinate - startYCoord) * currentTransformationValue;
        
        float startPrevSeriesYCoords = [_startPrevSeriesYCoordinates getValueAt:i];
        float originalPrevSeriesYCoordinate = [_originalPrevSeriesYCoordinates getValueAt:i];
        float additionalPrevSeriesY = startPrevSeriesYCoords + (originalPrevSeriesYCoordinate - startPrevSeriesYCoords) * currentTransformationValue;

        [self.renderPassData.yCoords set:additionalY at:i];
        [self.renderPassData.prevSeriesYCoords set:additionalPrevSeriesY at:i];
    }
}

- (void)discardTransformation {
    [SCITransformationHelpers copyDataFromSource:_originalYCoordinates toDest:self.renderPassData.yCoords];
    [SCITransformationHelpers copyDataFromSource:_originalPrevSeriesYCoordinates toDest:self.renderPassData.prevSeriesYCoords];
}

- (void)onInternalRenderPassDataChanged {
    [self applyTransformation];
}

- (void)onAnimationEnd {
    [super onAnimationEnd];
    
    [SCITransformationHelpers copyDataFromSource:_originalYCoordinates toDest:_startYCoordinates];
    [SCITransformationHelpers copyDataFromSource:_originalPrevSeriesYCoordinates toDest:_startPrevSeriesYCoordinates];
}

@end

static double const timeInterval = 1;
static double const animationDuration = 0.5;
static int const xValuesCount = 12;
static double const maxYValue = 50;

@interface AnimatingStackedColumnChartView ()
@property (nonatomic, strong) SCDToolbarButton *refreshDataButton;
@end

@implementation AnimatingStackedColumnChartView {
    SCIXyDataSeries *_dataSeries1;
    SCIXyDataSeries *_dataSeries2;
    
    SCIStackedColumnRenderableSeries *_rSeries1;
    SCIStackedColumnRenderableSeries *_rSeries2;
    
    SCIValueAnimator *_animator1;
    SCIValueAnimator *_animator2;
    
    NSTimer *_timer;
    BOOL _isRunning;
}

- (Class)associatedType { return SCIChartSurface.class; }

- (BOOL)showDefaultModifiersInToolbar { return NO; }

- (SCDToolbarButton *)refreshDataButton {
    if (!_refreshDataButton) {
        __weak typeof(self) wSelf = self;
        _refreshDataButton = [[SCDToolbarButton alloc] initWithTitle:@"Refresh data" image:nil andAction:^{
            if (self->_isRunning) {
                [self->_timer invalidate];
                [wSelf p_SCD_refreshData];
                self->_timer = [wSelf p_SCD_createTimer];
            } else {
                [wSelf p_SCD_refreshData];
            }
        }];
    }
    return _refreshDataButton;
}

- (NSArray<id<ISCDToolbarItem>> *)provideExampleSpecificToolbarItems {
    NSMutableArray<id<ISCDToolbarItem>> *items = [NSMutableArray arrayWithArray:@[[[SCDToolbarButtonsGroup alloc] initWithToolbarItems:@[
        [[SCDToolbarButton alloc] initWithTitle:@"Start" image:[SCIImage imageNamed:@"chart.play"] andAction:^{ self->_isRunning = YES; }],
        [[SCDToolbarButton alloc] initWithTitle:@"Pause" image:[SCIImage imageNamed:@"chart.pause"] andAction:^{ self->_isRunning = NO; }]
    ]]]];
    
#if TARGET_OS_OSX
    [items insertObject:self.refreshDataButton atIndex:0];
#endif
    
    return items;
}

#if TARGET_OS_IOS
- (SCIView *)providePanel {
    return [self.refreshDataButton createView];
}
#endif

- (void)initExample {
    _dataSeries1 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double];
    _dataSeries2 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double];
    
    _rSeries1 = [SCIStackedColumnRenderableSeries new];
    _rSeries2 = [SCIStackedColumnRenderableSeries new];
    
    _animator1 = [self p_SCD_createAnimatorForSeries:_rSeries1];
    _animator2 = [self p_SCD_createAnimatorForSeries:_rSeries2];
    
    [self p_SCD_configureRenderableSeries:_rSeries1 dataSeries:_dataSeries1 fillColor:0xff47bde6];
    [self p_SCD_configureRenderableSeries:_rSeries2 dataSeries:_dataSeries2 fillColor:0xffe8c667];
    
    [self p_SCD_fillWithInitialData];
    
    SCIVerticallyStackedColumnsCollection *columnCollection = [SCIVerticallyStackedColumnsCollection new];
    [columnCollection add:_rSeries1];
    [columnCollection add:_rSeries2];
    
    id<ISCIAxis> xAxis = [SCINumericAxis new];
    xAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.1 max:0.1];
    
    id<ISCIAxis> yAxis = [SCINumericAxis new];
    yAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.1 max:0.1];
    yAxis.visibleRange = [[SCIDoubleRange alloc] initWithMin:0 max:maxYValue * 2];

    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        [self.surface.xAxes add:xAxis];
        [self.surface.yAxes add:yAxis];
        [self.surface.renderableSeries add:columnCollection];
    }];

    _timer = [self p_SCD_createTimer];
    _isRunning = YES;
}

- (void)p_SCD_configureRenderableSeries:(SCIStackedColumnRenderableSeries *)rSeries dataSeries:(SCIXyDataSeries *)dataSeries fillColor:(unsigned int)fillColor {
    rSeries.dataSeries = dataSeries;
    rSeries.fillBrushStyle = [[SCISolidBrushStyle alloc] initWithColorCode:fillColor];
    rSeries.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:fillColor thickness:1.0];
}

- (void)p_SCD_fillWithInitialData {
    __weak typeof(self) wSelf = self;
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        for (NSInteger i = 0, count = xValuesCount; i < count; i++) {
            [self->_dataSeries1 appendX:@(i) y:@([wSelf p_SCD_getRandomYValue])];
            [self->_dataSeries2 appendX:@(i) y:@([wSelf p_SCD_getRandomYValue])];
        }
    }];
    
    [self p_SCD_refreshData];
}

- (NSTimer *)p_SCD_createTimer {
    return [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(p_SCD_updateData) userInfo:nil repeats:YES];
}

- (void)p_SCD_updateData {
    if (!_isRunning) return;
    
    [self p_SCD_refreshData];
}

- (void)p_SCD_refreshData {
    [_animator1 cancel];
    [_animator2 cancel];
    
    __weak typeof(self) wSelf = self;
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        for (NSInteger i = 0, count = xValuesCount; i < count; i++) {
            [self->_dataSeries1 updateY:@([wSelf p_SCD_getRandomYValue]) at:i];
            [self->_dataSeries2 updateY:@([wSelf p_SCD_getRandomYValue]) at:i];
        }
    }];
    
    [_animator1 startWithDuration:animationDuration];
    [_animator2 startWithDuration:animationDuration];
}

- (double)p_SCD_getRandomYValue {
    return SCDRandomUtil.nextDouble * maxYValue;
}

- (SCIValueAnimator *)p_SCD_createAnimatorForSeries:(id<ISCIRenderableSeries>)rSeries {
    SCIValueAnimator *animator = [SCIAnimations createAnimatorForSeries:rSeries withTransformation:[SCDUpdatedPointTransformation new]];
    animator.easingFunction = [SCICubicEase new];
    
    return animator;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [_timer invalidate];
    _timer = nil;
}

@end
