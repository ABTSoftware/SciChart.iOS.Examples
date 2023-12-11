//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2023. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// ChangeColumnColorChartView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "ChangeColumnColorChartView.h"
#import "CustomSeriesInfoProvider.h"

#pragma mark - Color Palette Provider
@interface ColumnsPaletteProvider : SCIPaletteProviderBase<SCIFastColumnRenderableSeries *><ISCIFillPaletteProvider>
- (instancetype)init;
@property (nonatomic) NSInteger touchedIndex;
@end

@implementation ColumnsPaletteProvider {
    SCIUnsignedIntegerValues *_colors;
}

static unsigned int desiredColors[] = {0xFF21a0d8, 0xFFc43360};

- (instancetype)init {
    self = [super initWithRenderableSeriesType:SCIFastColumnRenderableSeries.class];
    if (self) {
        _colors = [SCIUnsignedIntegerValues new];
        _touchedIndex = -1;
    }
    return self;
}

- (void)update {
    NSInteger count = self.renderableSeries.currentRenderPassData.pointsCount;
    _colors.count = count;
    
    unsigned int *colorsArray = _colors.itemsArray;
    for (NSInteger i = 0; i < count; i++) {
        
        if (i == _touchedIndex) {
            colorsArray[i] = desiredColors[1];
        }
        else {
            colorsArray[i] = desiredColors[0];
        }
    }
}

- (SCIUnsignedIntegerValues *)fillColors {
    return _colors;
}

@end

#pragma mark - Chart Initialisation
@implementation ChangeColumnColorChartView {
    SCIHitTestInfo *_hitTestInfo;
}

- (Class)associatedType { return SCIChartSurface.class; }

- (void)initExample {
    id<ISCIAxis> xAxis = [SCINumericAxis new];
    xAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.1 max:0.1];
    
    id<ISCIAxis> yAxis = [SCINumericAxis new];
    yAxis.axisAlignment = SCIAxisAlignment_Left;
    yAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.0 max:0.1];
    
    SCIXyDataSeries *dataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double];
    int yValues[] = {50, 35, 61, 58, 50, 50, 40, 53, 55, 23, 45, 12, 59, 60};
    for (size_t i = 0; i < sizeof(yValues)/sizeof(yValues[0]); i++) {
        [dataSeries appendX:@(i) y:@(yValues[i])];
    }
    
    SCIFastColumnRenderableSeries *rSeries = [SCIFastColumnRenderableSeries new];
    rSeries.dataSeries = dataSeries;
    rSeries.dataPointWidth = 0.7;
    rSeries.paletteProvider = [ColumnsPaletteProvider new];
    CustomSeriesInfoProvider *customSeriesInfoProvider = [CustomSeriesInfoProvider new];
    customSeriesInfoProvider.delegate = self;
    rSeries.seriesInfoProvider = customSeriesInfoProvider;
    
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        [self.surface.xAxes add:xAxis];
        [self.surface.yAxes add:yAxis];
        [self.surface.renderableSeries add:rSeries];
        [self.surface.chartModifiers add:[SCITooltipModifier new]];
    }];
}

- (void)handleSingleTap:(SCITapGestureRecognizer *)recognizer {
    CGPoint location = [recognizer locationInView:recognizer.view];
    
    CGPoint hitTestPoint = [self.surface translatePoint:location hitTestable:self.surface.renderableSeriesArea];

    SCIRenderableSeriesCollection *seriesCollection = self.surface.renderableSeries;
    for (NSInteger i = 0, count = seriesCollection.count; i < count; i++) {
        id<ISCIRenderableSeries> rSeries = seriesCollection[i];
        [rSeries hitTest:_hitTestInfo at:hitTestPoint];

        ColumnsPaletteProvider *paletteProvider = (ColumnsPaletteProvider*)[rSeries paletteProvider];
        
        if (paletteProvider != nil) {
            if (_hitTestInfo.isHit) {
                paletteProvider.touchedIndex = _hitTestInfo.dataSeriesIndex;
            }
            else {
                paletteProvider.touchedIndex = -1;
            }
        }
    }
    [self.surface invalidateElement];
}

-(void)getTouchDataSeriesIndex: (NSInteger)dataSeriesIndex {
    NSLog(@"Index =>%ld", (long)self.surface.renderableSeries);
    
    SCIRenderableSeriesCollection  *seriesCollection = self.surface.renderableSeries;
    ColumnsPaletteProvider *paletteProvider = (ColumnsPaletteProvider*)[[seriesCollection firstObject] paletteProvider];
    
    if (paletteProvider != nil) {
        paletteProvider.touchedIndex = dataSeriesIndex;
        
    }
    
    [self.surface invalidateElement];
}
@end
