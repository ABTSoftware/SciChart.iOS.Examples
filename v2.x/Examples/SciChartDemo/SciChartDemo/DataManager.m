//
//  DataManager.m
//  SciChartDemo
//
//  Created by Admin on 09.11.15.
//  Copyright © 2015 SciChart Ltd. All rights reserved.
//

#import "DataManager.h"
#import <SciChart/SciChart.h>
#import <Accelerate/Accelerate.h>
#import "RandomUtil.h"
#import "PriceBar.h"
#import "TradeData.h"

NSString * const SCIPriceInduDailyDataPath = @"INDU_Daily.csv";
NSString * const SCIPriceEURUSDDailyDataPath = @"EURUSD_Daily.csv";
NSString * const SCITradeticksDataPath = @"TradeTicks.csv";

@implementation DataManager

+ (void)setFourierSeries:(DoubleSeries *)doubleSeries amplitude:(double)amp phaseShift:(double)pShift count:(int)count {
    for (int i = 0; i < count; i++) {
        double time = 10 * (double) i / (double) count;
        double wn = 2.0 * M_PI / ((double) count / 10);
        
        double y = M_PI * amp * (sin((double) i * wn + pShift) +
                                 0.33 * sin((double) i * 3 * wn + pShift) +
                                 0.20 * sin((double) i * 5 * wn + pShift) +
                                 0.14 * sin((double) i * 7 * wn + pShift) +
                                 0.11 * sin((double) i * 9 * wn + pShift) +
                                 0.09 * sin((double) i * 11 * wn + pShift));
        [doubleSeries addX:time Y:y];
    }
}

+ (DoubleSeries *)getFourierSeriesWithAmplitude:(double)amp phaseShift:(double)pShift count:(int)count {
    DoubleSeries * doubleSeries = [[DoubleSeries alloc] initWithCapacity:count];
    
    [self setFourierSeries:doubleSeries amplitude:amp phaseShift:pShift count:count];
   
    return doubleSeries;
}

+ (void)setFourierSeriesZoomed:(DoubleSeries *)doubleSeries amplitude:(double)amp phaseShift:(double)pShift xStart:(double)xstart xEnd:(double)xend count:(int)count {
    [self setFourierSeries:doubleSeries amplitude:amp phaseShift:pShift count:count];
    
    int startIndex = 0, endIndex = 0;
    
    for (int i = 0; i < count; i++) {
        if (SCIGenericDouble([doubleSeries.getXArray valueAt:i]) > xstart && startIndex == 0) {
            startIndex = i;
        }
        if (SCIGenericDouble([doubleSeries.getXArray valueAt:i]) > xend && endIndex == 0) {
            endIndex = i;
            break;
        }
    }
    
    [doubleSeries.getXArray removeRangeFrom:endIndex Count:count - endIndex];
    [doubleSeries.getYArray removeRangeFrom:endIndex Count:count - endIndex];
    [doubleSeries.getXArray removeRangeFrom:0 Count:startIndex];
    [doubleSeries.getYArray removeRangeFrom:0 Count:startIndex];
}

+ (DoubleSeries *)getFourierSeriesWithAmplitude:(double)amp phaseShift:(double)pShift xStart:(double)xstart xEnd:(double)xend count:(int)count {
    DoubleSeries * doubleSeries = [[DoubleSeries alloc] initWithCapacity:count];
    
    [self setFourierSeriesZoomed:doubleSeries amplitude:amp phaseShift:pShift xStart:xstart xEnd:xend count:count];
    
    return doubleSeries;
}

+ (void)loadXyData:(id <SCIXyDataSeriesProtocol>)data From:(double)min To:(double)max Random:(DataManagerRandom)params {
    for (int j = min; j < max; j++) {
        double yValue = randf(j * params.minRandMul + params.minRandAdd, j * params.maxRandMul + params.maxRandAdd);
        yValue += j * params.addMul + params.add;
        if (([data xType] == SCIDataType_DateTime)
                && ([data yType] == SCIDataType_DateTime)) {
            [data appendX:SCIGeneric([NSDate dateWithTimeIntervalSinceNow:j]) Y:SCIGeneric([NSDate dateWithTimeIntervalSinceNow:yValue])];
        } else if ([data xType] == SCIDataType_DateTime) {
            [data appendX:SCIGeneric([NSDate dateWithTimeIntervalSinceNow:j]) Y:SCIGeneric(yValue)];
        } else if ([data yType] == SCIDataType_DateTime) {
            [data appendX:SCIGeneric(j) Y:SCIGeneric([NSDate dateWithTimeIntervalSinceNow:yValue])];
        } else {
            [data appendX:SCIGeneric(j) Y:SCIGeneric(yValue)];
        }
    }
}

+ (void)loadXyData:(id <SCIXyDataSeriesProtocol>)data From:(double)min To:(double)max Function:(XyDataFunction)func {
    for (int j = min; j < max; j++) {
        func(data, j);
    }
}

+ (void)loadOhlcData:(id <SCIOhlcDataSeriesProtocol>)data From:(double)min To:(double)max Function:(OhlcDataFunction)func {
    for (int j = min; j < max; j++) {
        func(data, j);
    }
}

+ (NSArray *)getTradeTicks {
    NSMutableArray * result = [NSMutableArray new];
    
    NSString * rawData = [NSString stringWithContentsOfFile:[self getBundleFilePathFrom:SCITradeticksDataPath] encoding:NSUTF8StringEncoding error:nil];
    NSArray * lines = [rawData componentsSeparatedByString:@"\r\n"];
    
    NSDateFormatter * dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"HH:mm:ss.s";
    
    for (int i = 0; i < lines.count - 1; i++) {
        NSArray * split  = [lines[i] componentsSeparatedByString:@","];
        if (split.count != 0) {
            NSDate * date = [dateFormatter dateFromString:split[0]];
            TradeData * data = [[TradeData alloc] initWithTradeDate:date tradePrice:[split[1] doubleValue] tradeSize:[split[2] doubleValue]];
            
            [result addObject:data];
        }
    }
    
    return result;
}

+ (void)setLissajousCurve:(id <SCIXyDataSeriesProtocol>)data
                    alpha:(double)alpha
                     beta:(double)beta
                    delta:(double)delta
                    count:(int)count {
    // From http://en.wikipedia.org/wiki/Lissajous_curve
    // x = Asin(at + d), y = Bsin(bt)
    double *xValues = malloc(sizeof(double) * count);
    double *yValues = malloc(sizeof(double) * count);

    for (int i = 0; i < count; i++) {
        xValues[i] = alpha * i * 0.1 + delta;
        yValues[i] = beta * i * 0.1;
    }

    double *xSinValues = malloc(sizeof(double) * count);
    double *ySinValues = malloc(sizeof(double) * count);

    vvsin(xSinValues, xValues, &count);
    vvsin(ySinValues, yValues, &count);

    for (int i = 0; i < count; i++) {
        [data appendX:SCIGeneric(xSinValues[i]) Y:SCIGeneric(ySinValues[i])];
    }
}

+ (void)getExponentialCurve:(id <SCIXyDataSeriesProtocol>)data cound:(int)count exponent:(double)exponent {
    double x = 0.00001;
    double y;
    double fudgeFactor = 1.4;

    for (int i = 0; i < count; i++) {
        x *= fudgeFactor;
        y = pow(i + 1, exponent);

        [data appendX:SCIGeneric(x) Y:SCIGeneric(y)];
    }
}

+ (void)getRandomDoubleSeries:(id <SCIXyDataSeriesProtocol>)data cound:(int)count {
    double amplitude = randf(0.0, 1.0) + 0.5;
    double freq = M_PI * (randf(0.0, 1.0) + 0.5) * 10;
    double offset = randf(0.0, 1.0) - 0.5;

    for (int i = 0; i < count; i++) {
        [data appendX:SCIGeneric(i) Y:SCIGeneric(offset + amplitude + sin(freq * i))];
    }
}

+ (PriceSeries *)getPriceDataIndu {
    return [self getPriceBarsFromPath:SCIPriceInduDailyDataPath dateFormat:@"MM/dd/yyyy"];
}

+ (PriceSeries *)getPriceDataEurUsd {
    return [self getPriceBarsFromPath:SCIPriceEURUSDDailyDataPath dateFormat:@"yyyy.MM.dd"];
}

+ (NSString *)getBundleFilePathFrom:(NSString *)path {
    NSArray * components = [path componentsSeparatedByString:@"."];
    NSString * fileName = components[0];
    NSString * extension = components[1];
    
    NSString * filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:extension];

    return filePath;
}

+ (PriceSeries *)getPriceBarsFromPath:(NSString *)path dateFormat:(NSString *)dateFormatString {
    PriceSeries * result = [PriceSeries new];
    
    NSString * rawData = [NSString stringWithContentsOfFile:[self getBundleFilePathFrom:path] encoding:NSUTF8StringEncoding error:nil];
    NSArray * lines = [rawData componentsSeparatedByString:@"\r\n"];
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateFormatString];

    for (int i = 0; i < lines.count - 1; i++) {
        NSArray * split  = [lines[i] componentsSeparatedByString:@","];
        
        NSDate * date = [dateFormatter dateFromString:split[0]];
        PriceBar * priceBar = [[PriceBar alloc] initWithDate:date
                                                        open:[split[1] doubleValue]
                                                        high:[split[2] doubleValue]
                                                         low:[split[3] doubleValue]
                                                       close:[split[4] doubleValue]
                                                      volume:[split[5] doubleValue]];
        [result add:priceBar];
    }
    
    return result;
}

+ (void)loadDataFromFile:(id <SCIXyDataSeriesProtocol>)dataSeries fileName:(NSString *)fileName {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"txt"];
    NSString *data = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    NSArray *items = [data componentsSeparatedByString:@"\n"];

    for (int i = 0; i < items.count; i++) {
        [dataSeries appendX:SCIGeneric(i) Y:SCIGeneric([items[i] floatValue])];
    }
}

+ (void)loadDataFromFile:(id <SCIXyDataSeriesProtocol>)dataSeries fileName:(NSString *)fileName count:(NSUInteger)count {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"txt"];
    NSString *data = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    NSArray *items = [data componentsSeparatedByString:@"\n"];
    
    count = count == 0 || count > items.count ? items.count : count;
    NSArray *subItems;
    for (int i = 0; i < count; i++) {
        subItems = [items[i] componentsSeparatedByString:@","];
        [dataSeries appendX:SCIGeneric(i) Y:SCIGeneric([subItems[1] floatValue])];
    }
}

+ (void)putDefaultDataMultiPaneIntoDataSeries:(id <SCIXyDataSeriesProtocol>)dataSeries dataCount:(int)dataCount {

    SCIGenericType yData;
    yData.floatData = arc4random_uniform(100);
    yData.type = SCIDataType_Float;
    int32_t prevoius = 1;
    for (int i = 0; i < dataCount; i++) {
        prevoius = randi(prevoius, prevoius + 10);
        NSDate *date = [NSDate dateWithTimeIntervalSinceNow:60 * 60 * 24 * prevoius];
        SCIGenericType xData = SCIGeneric(date);
        float value = yData.floatData + randf(-5.0, 5.0);
        yData.floatData = value;
        [dataSeries appendX:xData Y:yData];
    }

}

+ (NSArray<SCDMultiPaneItem *> *)loadThemeData {

    int count = 250;

    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"FinanceData"
                                                         ofType:@"txt"];

    NSString *data = [NSString stringWithContentsOfFile:filePath
                                               encoding:NSUTF8StringEncoding
                                                  error:nil];

    NSArray *items = [data componentsSeparatedByString:@"\n"];
    NSArray *subItems;

    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:count];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];

    //    if(!reversed)
    for (int i = 0; i < count; i++) {
        subItems = [items[i] componentsSeparatedByString:@","];

        SCDMultiPaneItem *item = [SCDMultiPaneItem new];
        item.dateTime = [dateFormatter dateFromString:subItems[0]];
        item.open = [subItems[1] doubleValue];
        item.high = [subItems[2] doubleValue];
        item.low = [subItems[3] doubleValue];
        item.close = [subItems[4] doubleValue];
        item.volume = [subItems[5] doubleValue];

        [array addObject:item];

    }

    return array;
}

+ (NSArray<SCDMultiPaneItem *> *)loadPaneStockData {

    int count = 3000;

    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"EURUSD_Daily"
                                                         ofType:@"txt"];

    NSString *data = [NSString stringWithContentsOfFile:filePath
                                               encoding:NSUTF8StringEncoding
                                                  error:nil];

    NSArray *items = [data componentsSeparatedByString:@"\n"];
    NSArray *subItems;

    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:count];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];

    //    if(!reversed)
    for (int i = 0; i < count; i++) {
        subItems = [items[i] componentsSeparatedByString:@","];

        SCDMultiPaneItem *item = [SCDMultiPaneItem new];
        item.dateTime = [dateFormatter dateFromString:subItems[0]];
        item.open = [subItems[1] doubleValue];
        item.high = [subItems[2] doubleValue];
        item.low = [subItems[3] doubleValue];
        item.close = [subItems[4] doubleValue];
        item.volume = [subItems[5] doubleValue];

        [array addObject:item];

    }

    return array;
}

+ (void)getStraightLines:(SCIXyDataSeries *)series :(double)gradient :(double)yIntercept :(int)pointCount {
    for (int i = 0; i < pointCount; i++) {
        double x = i + 1;
        [series appendX:SCIGeneric(x) Y:SCIGeneric(gradient * x + yIntercept)];
    }
}

+ (DoubleSeries *)getDampedSinewaveWithAmplitude:(double)amplitude DampingFactor:(double)dampingFactor PointCount:(int)pointCount Freq:(int)freq {
    return [self getDampedSinewaveWithPad:0 Amplitude:amplitude Phase:0.0 DampingFactor:dampingFactor PointCount:pointCount Freq:freq];
}

+ (DoubleSeries *)getDampedSinewaveWithPad:(int)pad Amplitude:(double)amplitude Phase:(double)phase DampingFactor:(double)dampingFactor PointCount:(int)pointCount Freq:(int)freq {
    DoubleSeries *doubleSeries = [[DoubleSeries alloc] initWithCapacity:pointCount];

    for (int i = 0; i < pad; i++) {
        double time = 10 * i / (double) pointCount;
        [doubleSeries addX:time Y:0];
    }

    for (int i = pad, j = 0; i < pointCount; i++, j++) {
        double time = 10 * i / (double) pointCount;
        double wn = 2 * M_PI / (pointCount / (double) freq);

        const double d = amplitude * sin(j * wn + phase);
        [doubleSeries addX:time Y:d];

        amplitude *= (1.0 - dampingFactor);
    }

    return doubleSeries;
}

+ (DoubleSeries *)getSinewaveWithAmplitude:(double)amplitude Phase:(double)phase PointCount:(int)pointCount Freq:(int)freq {
    return [self getDampedSinewaveWithPad:0 Amplitude:amplitude Phase:phase DampingFactor:0 PointCount:pointCount Freq:freq];
}

+ (DoubleSeries *)getSinewaveWithAmplitude:(double)amplitude Phase:(double)phase PointCount:(int)pointCount {
    return [self getSinewaveWithAmplitude:amplitude Phase:phase PointCount:pointCount Freq:10];
}

+ (DoubleSeries *)getNoisySinewaveWithAmplitude:(double)amplitude Phase:(double)phase PointCount:(int)pointCount NoiseAmplitude:(double)noiseAmplitude {
    DoubleSeries *doubleSeries = [self getSinewaveWithAmplitude:amplitude Phase:phase PointCount:pointCount];
    SCIGenericType yValues = doubleSeries.yValues;

    for (int i = 0; i < pointCount; i++) {
        double y = yValues.doublePtr[i];
        yValues.doublePtr[i] = y + [RandomUtil nextDouble] * noiseAmplitude - noiseAmplitude * 0.5;
    }

    return doubleSeries;
}

+ (double *) offsetArray:(double *)sourceArray destArray:(double *)destArray count:(int)count offset:(double)offset {
    for (int i = 0; i < count; i++) {
        destArray[i] = sourceArray[i] + offset;
    }
    return destArray;
}

@end

@implementation SCDMultiPaneItem

@end

@implementation SCDMovingAverage {
    int _lenght;
    int _circIndex;
    bool _filled;
    double _current;
    double _oneOverLength;
    NSMutableArray <NSNumber *> *_circularBuffer;
    double _total;
}

- (instancetype)initWithLength:(int)length {
    self = [super init];
    if (self) {
        _lenght = length;
        _oneOverLength = 1.0 / (double) length;
        _circularBuffer = [[NSMutableArray alloc] initWithCapacity:_lenght];
        _circIndex = -1;
        _current = NAN;
    }
    return self;
}

- (void)update:(double)value {

    double lostValue = _circularBuffer[_circIndex].doubleValue;
    _circularBuffer[_circIndex] = @(value);

    // Maintain totals for Push function
    _total += value;
    _total -= lostValue;

    // If not yet filled, just return. Current value should be double.NaN
    if (!_filled) {
        _current = NAN;
        return;
    }

    // Compute the average
    double average = 0.0;
    for (int i = 0; i < _circularBuffer.count; i++) {
        average += _circularBuffer[i].doubleValue;
    }

    _current = average * _oneOverLength;

}

- (SCDMovingAverage *)push:(double)value {

    if (++_circIndex == _lenght) {
        _circIndex = 0;
    }


    double lostValue = _circIndex < _circularBuffer.count ? _circularBuffer[_circIndex].doubleValue : 0.0;
    _circularBuffer[_circIndex] = @(value);

    _total += value;
    _total -= lostValue;

    if (!_filled && _circIndex != _lenght - 1) {
        _current = NAN;
        return self;
    } else {
        _filled = true;
    }

    _current = _total * _oneOverLength;

    return self;

}

@end

@implementation SCDMcadPointItem

@end

@implementation MarketDataService {
    NSDate *_startDate;
    int _timeFrameMinutes;
    int _tickTimerIntervals;
    RandomPriceDataSource *_generator;
}

- (instancetype)initWithStartDate:(NSDate *)startDate
                 TimeFrameMinutes:(int)timeFrameMinutes
               TickTimerIntervals:(int)tickTimerIntervals {
    self = [super init];
    if (self) {
        _startDate = startDate;
        _timeFrameMinutes = timeFrameMinutes;
        _tickTimerIntervals = tickTimerIntervals;

        _generator = [[RandomPriceDataSource alloc] initWithCandleIntervalMinutes:_timeFrameMinutes SimulateDateGap:true TimeInterval:_tickTimerIntervals UpdatesPerPrice:25 RandomSeed:100 StartingPrice:30 StartDate:_startDate];
    }
    return self;
}

- (void)subscribePriceUpdate:(OnNewData)callback {
    _generator.updateData = callback;
    _generator.newData = callback;

    [_generator startGeneratePriceBars];
}

- (void)clearSubscriptions {
    if (_generator.IsRunning) {
        [_generator stopGeneratePriceBars];
        [_generator clearEventHandlers];
    }
}

- (NSMutableArray *)getHistoricalData:(int)numberBars {
    NSMutableArray *prices = [[NSMutableArray alloc] initWithCapacity:numberBars];

    for (int i = 0; i < numberBars; i++) {
        [prices addObject:[_generator getNextData]];
    }

    return prices;
}

- (SCDMultiPaneItem *)getNextBar {
    return [_generator tick];
}

@end

@implementation RandomPriceDataSource {
    NSTimer *_timer;
    double Frequency;
    int _candleIntervalMinutes;
    bool _simulateDateGap;

    SCDMultiPaneItem *_lastPriceBar;
    SCDMultiPaneItem *_initialPriceBar;
    double _currentTime;
    int _updatesPerPrice;
    int _currentUpdateCount;
    NSTimeInterval _openMarketTime;
    NSTimeInterval _closeMarketTime;

    int _randomSeed;
    double _timeInerval;
}

@synthesize IsRunning;

- (instancetype)initWithCandleIntervalMinutes:(int)candleIntervalMinutes
                              SimulateDateGap:(BOOL)simulateDateGap
                                 TimeInterval:(double)timeInterval
                              UpdatesPerPrice:(int)updatesPerPrice
                                   RandomSeed:(int)randomSeed
                                StartingPrice:(double)startingPrice
                                    StartDate:(NSDate *)startDate {
    self = [super init];
    if (self) {
        Frequency = 1.1574074074074073E-05;
        _openMarketTime = 360;
        _closeMarketTime = 720;

        _candleIntervalMinutes = candleIntervalMinutes;
        _simulateDateGap = simulateDateGap;
        _updatesPerPrice = updatesPerPrice;

        _timeInerval = timeInterval;

        _initialPriceBar = [[SCDMultiPaneItem alloc] init];
        _initialPriceBar.close = startingPrice;
        _initialPriceBar.dateTime = startDate;

        _lastPriceBar = [[SCDMultiPaneItem alloc] init];
        _lastPriceBar.close = _initialPriceBar.close;
        _lastPriceBar.dateTime = _initialPriceBar.dateTime;
        _lastPriceBar.high = _initialPriceBar.close;
        _lastPriceBar.low = _initialPriceBar.close;
        _lastPriceBar.open = _initialPriceBar.close;
        _lastPriceBar.volume = 0;

        _randomSeed = randomSeed;
    }

    return self;
}

- (BOOL)IsRunning {
    return _timer.isValid;
}

- (void)startGeneratePriceBars {
    _timer = [NSTimer scheduledTimerWithTimeInterval:_timeInerval
                                              target:self
                                            selector:@selector(onTimerElapsed)
                                            userInfo:nil
                                             repeats:YES];
}

- (void)stopGeneratePriceBars {
    if (_timer.isValid)
        [_timer invalidate];
}

- (SCDMultiPaneItem *)getNextData {

    return [self getNextRandomPriceBar];
}

- (SCDMultiPaneItem *)getUpdateData {
    double num = _lastPriceBar.close + ([self randf:0 max:_randomSeed] - 48) * (_lastPriceBar.close / 1000.0);
    double high = num > _lastPriceBar.high ? num : _lastPriceBar.high;
    double low = num < _lastPriceBar.low ? num : _lastPriceBar.low;
    long volumeInc = ([self randf:0 max:_randomSeed] * 3 + 2) * 0.5;

    _lastPriceBar.high = high;
    _lastPriceBar.low = low;
    _lastPriceBar.close = num;
    _lastPriceBar.volume += volumeInc;

    return _lastPriceBar;
}

- (double)randf:(double)min max:(double)max {
    return [RandomUtil nextDouble] * (max - min) + min;
}

- (SCDMultiPaneItem *)getNextRandomPriceBar {
    double close = _lastPriceBar.close;
    double num = (randf(0.0, 1.0) - 0.9) * _initialPriceBar.close / 30.0;
    double num2 = randf(0.0, 1.0);
    double num3 = _initialPriceBar.close + _initialPriceBar.close / 2.0 * sin(7.27220521664304E-06 * _currentTime) + _initialPriceBar.close / 16.0 * cos(7.27220521664304E-05 * _currentTime) + _initialPriceBar.close / 32.0 * sin(7.27220521664304E-05 * (10.0 + num2) * _currentTime) + _initialPriceBar.close / 64.0 * cos(7.27220521664304E-05 * (20.0 + num2) * _currentTime) + num;
    double num4 = fmax(close, num3);
    double num5 = randf(0.0, 1.0) * _initialPriceBar.close / 100.0;
    double high = num4 + num5;
    double num6 = fmin(close, num3);
    double num7 = randf(0.0, 1.0) * _initialPriceBar.close / 100.0;
    double low = num6 - num7;
    long volume = (long) (randf(0.0, 1.0) * 30000 + 20000);
    NSDate *openTime = _simulateDateGap ? [self emulateDateGap:_lastPriceBar.dateTime] : _lastPriceBar.dateTime;
    NSDate *closeTime = [openTime dateByAddingTimeInterval:_candleIntervalMinutes];

    SCDMultiPaneItem *candle = [[SCDMultiPaneItem alloc] init];
    candle.close = num3;
    candle.dateTime = closeTime;
    candle.high = high;
    candle.low = low;
    candle.volume = volume;
    candle.open = close;

    _lastPriceBar = [[SCDMultiPaneItem alloc] init];
    _lastPriceBar.close = candle.close;
    _lastPriceBar.dateTime = candle.dateTime;
    _lastPriceBar.high = candle.high;
    _lastPriceBar.low = candle.low;
    _lastPriceBar.open = candle.open;
    _lastPriceBar.volume = candle.volume;

    _currentTime += _candleIntervalMinutes;
    return candle;
}

- (NSDate *)emulateDateGap:(NSDate *)candleOpenTime {
    NSDate *result = candleOpenTime;

    if ([candleOpenTime timeIntervalSince1970] > _closeMarketTime) {
        NSDate *dateTime = candleOpenTime;
        dateTime = [dateTime dateByAddingTimeInterval:500];
        result = [dateTime dateByAddingTimeInterval:_openMarketTime];
    }
    while ([result timeIntervalSince1970] < 500) {
        result = [result dateByAddingTimeInterval:500];
    }
    return result;
}

- (void)onTimerElapsed {
    if (_currentUpdateCount < _updatesPerPrice) {
        _currentUpdateCount++;
        SCDMultiPaneItem *updatedData = [self getUpdateData];
        if (updatedData != nil) {
            _updateData(updatedData);
        }
    } else {
        _currentUpdateCount = 0;
        SCDMultiPaneItem *nextData = [self getNextData];
        if (nextData != nil) {
            _newData(nextData);
        }
    }
}

- (void)clearEventHandlers {

}

- (SCDMultiPaneItem *)tick {
    if (_currentUpdateCount < _updatesPerPrice) {
        _currentUpdateCount++;
        return [self getUpdateData];
    } else {
        _currentUpdateCount = 0;
        return [self getNextData];
    }
}


@end
