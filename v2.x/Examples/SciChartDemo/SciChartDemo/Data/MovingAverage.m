//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// MovingAverage.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************
#import "MovingAverage.h"
#import "PriceBar.h"

@implementation MovingAverage {
    int _lenght;
    int _circIndex;
    bool _filled;
    double _current;
    double _oneOverLength;
    double * _circularBuffer;
    double _total;
}

- (instancetype)initWithLength:(int)length {
    self = [super init];
    if (self) {
        _circIndex = -1;
        _current = NAN;
        _lenght = length;
        _oneOverLength = 1.0 / (double) length;
        _circularBuffer = calloc(length, sizeof(double));
    }
    return self;
}

- (MovingAverage *)update:(double)value {
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
    for (int i = 0; i < _lenght; i++) {
        average += _circularBuffer[i];
    }
    
    _current = average * _oneOverLength;

    return self;
}

- (MovingAverage *)push:(double)value {
    if (++_circIndex == _lenght) {
        _circIndex = 0;
    }
    
    double lostValue = _circularBuffer[_circIndex];
    _circularBuffer[_circIndex] = value;
    
    // Compute the average
    _total += value;
    _total -= lostValue;
    
    // If not yet filled, just return. Current value should be NAN
    if (!_filled && _circIndex != _lenght - 1) {
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

- (int)length {
    return _lenght;
}

+ (double *)movingAverage:(double *)input output:(double *)output count:(int)count period:(int)period {
    MovingAverage * ma = [[MovingAverage alloc] initWithLength:period];
    
    for (int i = 0; i < count; i++) {
        [ma push:input[i]];
        output[i] = ma.current;
    }
    
    return output;
}

+ (double *)rsi:(PriceSeries *)input output:(double *)output count:(int)count period:(int)period {
    MovingAverage * averageGain = [[MovingAverage alloc] initWithLength:period];
    MovingAverage * averageLoss = [[MovingAverage alloc] initWithLength:period];

    // skip first point
    PriceBar * previousBar = (PriceBar *)[input itemAt:0];
    output[0] = NAN;
    
    for (int i = 1; i < input.size; i++) {
        PriceBar * priceBar = (PriceBar *)[input itemAt:i];
        
        double gain = priceBar.close > previousBar.close ? priceBar.close - previousBar.close : 0.0;
        double loss = previousBar.close > priceBar.close ? previousBar.close - priceBar.close : 0.0;
        
        [averageGain push:gain];
        [averageLoss push:loss];
        
        double relativeStrength = isnan(averageGain.current) || isnan(averageLoss.current) ? NAN : averageGain.current / averageLoss.current;
        
        output[i] = isnan(relativeStrength) ? NAN : 100.0 - (100.0 / (1.0 + relativeStrength));
        
        previousBar = priceBar;
    }
    return output;
}

+ (MacdPoints *)macd:(double *)input count:(int)count slow:(int)slow fast:(int)fast signal:(int)signal {
    MovingAverage * maSlow = [[MovingAverage alloc] initWithLength:slow];
    MovingAverage * maFast = [[MovingAverage alloc] initWithLength:fast];
    MovingAverage * maSignal = [[MovingAverage alloc] initWithLength:signal];
    
    MacdPoints * output = [MacdPoints new];

    for (int i = 0; i < count; i++) {
        double item = input[i];
        double macd = [maSlow push:item].current - [maFast push:item].current;
        double signalLine = isnan(macd) ? NAN : [maSignal push:macd].current;
        double divergence = isnan(macd) || isnan(signalLine) ? NAN : macd - signalLine;
        
        [output addMacd:macd signal:signalLine divergence:divergence];
    }
    return output;
}

@end
