//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// OscilloscopeChartView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "OscilloscopeChartView.h"
#import "SCDDataManager.h"

static double const TimeInterval = 30.0;

@implementation OscilloscopeChartView {

    NSTimer *_timer;
    
    DataSourceEnum _selectedSource;
    
    SCIXyDataSeries *_dataSeries1;
    SCIXyDataSeries *_dataSeries2;
    
    SCIFastLineRenderableSeries *_rSeries;
    
    double _phase0;
    double _phase1;
    double _phaseIncrement;
    
    id<ISCIAxis> _xAxis;
    id<ISCIAxis> _yAxis;
}

- (void)initExample {
    _phaseIncrement = M_PI * 0.1;
    
    _xAxis = [SCINumericAxis new];
    _xAxis.autoRange = SCIAutoRange_Never;
    _xAxis.axisTitle = @"Time (ms)";
    _xAxis.visibleRange = [[SCIDoubleRange alloc] initWithMin:2.5 max:4.5];
    
    _yAxis = [SCINumericAxis new];
    _yAxis.autoRange = SCIAutoRange_Never;
    _yAxis.axisTitle = @"Voltage (mV)";
    _yAxis.visibleRange = [[SCIDoubleRange alloc] initWithMin:-12.5 max:12.5];
    
    _dataSeries1 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double];
    _dataSeries1.acceptsUnsortedData = YES;
    _dataSeries2 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double];
    _dataSeries2.acceptsUnsortedData = YES;
    
    _rSeries = [SCIFastLineRenderableSeries new];
    
    [self.surface.xAxes add:_xAxis];
    [self.surface.yAxes add:_yAxis];
    [self.surface.renderableSeries add:_rSeries];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:TimeInterval / 1000.0 target:self selector:@selector(updateOscilloscopeData:) userInfo:nil repeats:YES];
}

- (void)updateOscilloscopeData:(NSTimer *)timer {
    SCDDoubleSeries *doubleSeries = [SCDDoubleSeries new];
    if (_selectedSource == Lissajous) {
        [SCDDataManager setLissajousCurve:doubleSeries alpha:0.12 beta:_phase1 delta:_phase0 count:2500];
        [_dataSeries1 clear];
        [_dataSeries1 appendValuesX:doubleSeries.xValues y:doubleSeries.yValues];
        _rSeries.dataSeries = _dataSeries1;
    } else {
        [SCDDataManager setFourierSeries:doubleSeries amplitude:2.0 phaseShift:_phase0 count:1000];
        [_dataSeries2 clear];
        [_dataSeries2 appendValuesX:doubleSeries.xValues y:doubleSeries.yValues];
        _rSeries.dataSeries = _dataSeries2;
    }
    
    _phase0 += _phaseIncrement;
    _phase1 += _phaseIncrement * 0.005;
}

- (void)onFourierSeriesSelected {
    self->_selectedSource = FourierSeries;
    [self.surface.xAxes itemAt:0].visibleRange = [[SCIDoubleRange alloc] initWithMin:2.5 max:4.5];
    [self.surface.yAxes itemAt:0].visibleRange = [[SCIDoubleRange alloc] initWithMin:-12.5 max:12.5];
    self->_phaseIncrement = M_PI * 0.1;
}

- (void)onLissajousSelected {
    self->_selectedSource = Lissajous;
    [self.surface.xAxes itemAt:0].visibleRange = [[SCIDoubleRange alloc] initWithMin:-1.2 max:1.2];
    [self.surface.yAxes itemAt:0].visibleRange = [[SCIDoubleRange alloc] initWithMin:-1.2 max:1.2];
    self->_phaseIncrement = M_PI * 0.2;
}

- (void)onIsDigitalLineChanged:(BOOL)isDigitalLine {
    _rSeries.isDigitalLine = isDigitalLine;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [_timer invalidate];
    _timer = nil;
}

@end
