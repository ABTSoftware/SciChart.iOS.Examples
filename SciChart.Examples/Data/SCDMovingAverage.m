//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDMovingAverage.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SCDMovingAverage.h"
#import "SCDPriceBar.h"

@implementation SCDMovingAverage {
    int _circIndex;
    bool _filled;
    double _current;
    double _oneOverLength;
    double * _circularBuffer;
    double _total;
}

@synthesize length = _length;

- (instancetype)initWithLength:(NSInteger)length {
    self = [super init];
    if (self) {
        _circIndex = -1;
        _current = NAN;
        _length = length;
        _oneOverLength = 1.0 / (double)length;
        _circularBuffer = calloc(length, sizeof(double));
    }
    return self;
}

- (SCDMovingAverage *)update:(double)value {
    double lostValue = _circularBuffer[_circIndex];
    _circularBuffer[_circIndex] = value;
    
    // Maintain totals for Push function
    _total += value;
    _total -= lostValue;
    
    // If not yet filled, just return. Current value should be double.NaN
    if (!_filled) {
        _current = NAN;
        return self;
    }
    
    // Compute the average
    double average = 0.0;
    for (int i = 0; i < _length; i++) {
        average += _circularBuffer[i];
    }
    
    _current = average * _oneOverLength;

    return self;
}

- (SCDMovingAverage *)push:(double)value {
    if (++_circIndex == _length) {
        _circIndex = 0;
    }
    
    double lostValue = _circularBuffer[_circIndex];
    _circularBuffer[_circIndex] = value;
    
    // Compute the average
    _total += value;
    _total -= lostValue;
    
    // If not yet filled, just return. Current value should be NAN
    if (!_filled && _circIndex != _length - 1) {
        _current = NAN;
        return self;
    } else {
        // Set a flag to indicate this is the first time the buffer has been filled
        _filled = true;
    }
    _current = _total * _oneOverLength;
    
    return self;
}

- (double)current {
    return _current;
}

+ (SCIDoubleValues *)movingAverage:(SCIDoubleValues *)input period:(NSInteger)period {
    SCDMovingAverage *ma = [[SCDMovingAverage alloc] initWithLength:period];
    
    SCIDoubleValues *output = [[SCIDoubleValues alloc] initWithCapacity:input.count];
    
    for (NSInteger i = 0, count = input.count; i < count; i++) {
        [ma push:[input getValueAt:i]];
        [output add:ma.current];
    }
    
    return output;
}

+ (SCIDoubleValues *)rsi:(SCDPriceSeries *)input period:(NSInteger)period {
    SCDMovingAverage *averageGain = [[SCDMovingAverage alloc] initWithLength:period];
    SCDMovingAverage *averageLoss = [[SCDMovingAverage alloc] initWithLength:period];

    SCIDoubleValues *output = [[SCIDoubleValues alloc] initWithCapacity:input.count];
    
    // skip first point
    SCDPriceBar *previousBar = (SCDPriceBar *)[input itemAt:0];
    [output add:NAN];
    
    for (NSInteger i = 1, count = input.count; i < count; i++) {
        SCDPriceBar *priceBar = (SCDPriceBar *)[input itemAt:i];
        
        double gain = priceBar.close.doubleValue > previousBar.close.doubleValue ? priceBar.close.doubleValue - previousBar.close.doubleValue : 0.0;
        double loss = previousBar.close.doubleValue > priceBar.close.doubleValue ? previousBar.close.doubleValue - priceBar.close.doubleValue : 0.0;
        
        [averageGain push:gain];
        [averageLoss push:loss];
        
        double relativeStrength = isnan(averageGain.current) || isnan(averageLoss.current) ? NAN : averageGain.current / averageLoss.current;
        	
        [output add:isnan(relativeStrength) ? NAN : 100.0 - (100.0 / (1.0 + relativeStrength))];
        
        previousBar = priceBar;
    }
    return output;
}

+ (SCDMacdPoints *)macd:(SCIDoubleValues *)input slow:(NSInteger)slow fast:(NSInteger)fast signal:(NSInteger)signal {
    SCDMovingAverage *maSlow = [[SCDMovingAverage alloc] initWithLength:slow];
    SCDMovingAverage *maFast = [[SCDMovingAverage alloc] initWithLength:fast];
    SCDMovingAverage *maSignal = [[SCDMovingAverage alloc] initWithLength:signal];
    
    SCDMacdPoints *output = [SCDMacdPoints new];

    for (NSInteger i = 0, count = input.count; i < count; i++) {
        double item = [input getValueAt:i];
        double macd = [maSlow push:item].current - [maFast push:item].current;
        double signalLine = isnan(macd) ? NAN : [maSignal push:macd].current;
        double divergence = isnan(macd) || isnan(signalLine) ? NAN : macd - signalLine;
        
        [output addMacd:macd signal:signalLine divergence:divergence];
    }
    return output;
}

- (void)dealloc {
    free(_circularBuffer);
}

@end
