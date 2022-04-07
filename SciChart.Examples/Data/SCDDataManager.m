//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDDataManager.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SCDDataManager.h"
#import "SCDConstants.h"

NSString *const SCIPriceInduDailyDataPath = @"INDU_Daily.csv";
NSString *const SCIPriceEURUSDDailyDataPath = @"EURUSD_Daily.csv";
NSString *const SCITradeticksDataPath = @"TradeTicks.csv";
NSString *const SCIWaveformDataPath = @"WaveformData.txt";
NSString *const SCIFFTDataPath = @"FourierTransform.txt";

@implementation SCDDataManager

+ (void)setFourierSeries:(SCDDoubleSeries *)doubleSeries amplitude:(double)amp phaseShift:(double)pShift count:(NSInteger)count {
    double *xValuesArray = [self getValuesArray:doubleSeries.xValues count:count];
    double *yValuesArray = [self getValuesArray:doubleSeries.yValues count:count];
    
    for (int i = 0; i < count; i++) {
        double time = 10 * (double) i / (double) count;
        double wn = 2.0 * M_PI / ((double) count / 10);
        
        double y = M_PI * amp * (sin((double) i * wn + pShift) +
                                 0.33 * sin((double) i * 3 * wn + pShift) +
                                 0.20 * sin((double) i * 5 * wn + pShift) +
                                 0.14 * sin((double) i * 7 * wn + pShift) +
                                 0.11 * sin((double) i * 9 * wn + pShift) +
                                 0.09 * sin((double) i * 11 * wn + pShift));
        xValuesArray[i] = time;
        yValuesArray[i] = y;
    }
}

+ (SCDDoubleSeries *)getFourierSeriesWithAmplitude:(double)amp phaseShift:(double)pShift count:(NSInteger)count {
    SCDDoubleSeries *doubleSeries = [[SCDDoubleSeries alloc] initWithCapacity:count];
    
    [self setFourierSeries:doubleSeries amplitude:amp phaseShift:pShift count:count];
   
    return doubleSeries;
}

+ (void)setFourierSeriesZoomed:(SCDDoubleSeries *)doubleSeries amplitude:(double)amp phaseShift:(double)pShift xStart:(double)xStart xEnd:(double)xEnd count:(NSInteger)count {
    [self setFourierSeries:doubleSeries amplitude:amp phaseShift:pShift count:count];
    
    double *xValuesArray = doubleSeries.xValues.itemsArray;
    double *yValuesArray = doubleSeries.yValues.itemsArray;
    
    NSInteger startIndex = [SCIListUtil.instance findIndexInDoubleArray:xValuesArray startIndex:0 count:count isSorted:YES value:xStart searchMode:SCISearchMode_RoundDown];
    NSInteger endIndex = [SCIListUtil.instance findIndexInDoubleArray:xValuesArray startIndex:startIndex count:count - startIndex isSorted:YES value:xEnd searchMode:SCISearchMode_RoundUp];
    
    NSInteger size = endIndex - startIndex;
    memcpy(xValuesArray, xValuesArray + startIndex, size * sizeof(double));
    memcpy(yValuesArray, yValuesArray + startIndex, size * sizeof(double));
    
    doubleSeries.xValues.count = size;
    doubleSeries.yValues.count = size;
}

+ (SCDDoubleSeries *)getFourierSeriesWithAmplitude:(double)amp phaseShift:(double)pShift xStart:(double)xstart xEnd:(double)xend count:(NSInteger)count {
    SCDDoubleSeries *doubleSeries = [[SCDDoubleSeries alloc] initWithCapacity:count];
    
    [self setFourierSeriesZoomed:doubleSeries amplitude:amp phaseShift:pShift xStart:xstart xEnd:xend count:count];
    
    return doubleSeries;
}

+ (void)setLissajousCurve:(SCDDoubleSeries *)doubleSeries alpha:(double)alpha beta:(double)beta delta:(double)delta count:(NSInteger)count {
    // From http://en.wikipedia.org/wiki/Lissajous_curve
    // x = Asin(at + d), y = Bsin(bt)
    double *xValuesArray = [self getValuesArray:doubleSeries.xValues count:count];
    double *yValuesArray = [self getValuesArray:doubleSeries.yValues count:count];
    
    for (int i = 0; i < count; i++) {
        xValuesArray[i] = sin(alpha * i * 0.1 + delta);
        yValuesArray[i] = sin(beta * i * 0.1);
    }
}

+ (SCDDoubleSeries *)getLissajousCurveWithAlpha:(double)alpha beta:(double)beta delta:(double)delta count:(NSInteger)count {
    SCDDoubleSeries *doubleSeries = [SCDDoubleSeries new];
    
    [self setLissajousCurve:doubleSeries alpha:alpha beta:beta delta:delta count:count];
    
    return doubleSeries;
}

+ (void)setStraightLines:(SCDDoubleSeries *)doubleSeries gradient:(double)gradient yIntercept:(double)yIntercept pointCount:(NSInteger)pointCount {
    double *xValuesArray = [self getValuesArray:doubleSeries.xValues count:pointCount];
    double *yValuesArray = [self getValuesArray:doubleSeries.yValues count:pointCount];

    for (NSInteger i = 0; i < pointCount; i++) {
        double x = i + 1;
        xValuesArray[i] = x;
        yValuesArray[i] = gradient * x + yIntercept;
    }
}

+ (SCDDoubleSeries *)getStraightLinesWithGradient:(double)gradient yIntercept:(double)yIntercept pointCount:(NSInteger)pointCount {
    SCDDoubleSeries *doubleSeries = [SCDDoubleSeries new];
    
    [self setStraightLines:doubleSeries gradient:gradient yIntercept:yIntercept pointCount:pointCount];
    
    return doubleSeries;
}

+ (SCDDoubleSeries *)getExponentialCurveWithExponent:(double)exponent count:(NSInteger)count {
    SCDDoubleSeries *doubleSeries = [[SCDDoubleSeries alloc] initWithCapacity:count];
    
    double x = 0.00001;
    double y;
    
    double fudgeFactor = 1.4;
    for (int i = 0; i < count; i++) {
        x *= fudgeFactor;
        y = pow(i + 1, exponent);
        
        [doubleSeries addX:x y:y];
    }
    
    return doubleSeries;
}

+ (void)setRandomDoubleSeries:(SCDDoubleSeries *)doubleSeries count:(NSInteger)count {
    double *xValuesArray = [self getValuesArray:doubleSeries.xValues count:count];
    double *yValuesArray = [self getValuesArray:doubleSeries.yValues count:count];
    
    double amplitude = randf(0.0, 1.0) + 0.5;
    double freq = M_PI * (randf(0.0, 1.0) + 0.5) * 10;
    double offset = randf(0.0, 1.0) - 0.5;
    for (int i = 0; i < count; i++) {
        xValuesArray[i] = i;
        yValuesArray[i] = offset + amplitude + sin(freq * i);
    }
}

+ (SCDDoubleSeries *)getRandomDoubleSeriesWithCount:(NSInteger)count {
    SCDDoubleSeries *doubleSeries = [[SCDDoubleSeries alloc] initWithCapacity:count];
    
    [self setRandomDoubleSeries:doubleSeries count:count];
    
    return doubleSeries;
}

+ (SCDPriceSeries *)getPriceDataIndu {
    return [self getPriceBarsFromPath:SCIPriceInduDailyDataPath dateFormat:@"MM/dd/yyyy"];
}

+ (SCDPriceSeries *)getPriceDataEurUsd {
    return [self getPriceBarsFromPath:SCIPriceEURUSDDailyDataPath dateFormat:@"yyyy.MM.dd"];
}

+ (SCDPriceSeries *)getPriceBarsFromPath:(NSString *)path dateFormat:(NSString *)dateFormatString {
    SCDPriceSeries *result = [SCDPriceSeries new];
    
    NSString *rawData = [NSString stringWithContentsOfFile:[self getBundleFilePathFrom:path] encoding:NSUTF8StringEncoding error:nil];
    NSArray *lines = [rawData componentsSeparatedByString:@"\n"];
    
    NSDateFormatter *dateFormatter = [NSDateFormatter createWithFormat:dateFormatString locale:NSLocale.currentLocale timeZone:NSTimeZone.localTimeZone];

    for (NSUInteger i = 0; i < lines.count - 1; i++) {
        NSArray *split = [lines[i] componentsSeparatedByString:@","];
        
        NSDate *date = [dateFormatter dateFromString:split[0]];
        SCDPriceBar *priceBar = [[SCDPriceBar alloc] initWithDate:date
                                                        open:@([split[1] doubleValue])
                                                        high:@([split[2] doubleValue])
                                                         low:@([split[3] doubleValue])
                                                       close:@([split[4] doubleValue])
                                                      volume:@([split[5] doubleValue])];
        [result add:priceBar];
    }
    
    return result;
}

+ (NSArray<SCDTradeData *> *)getTradeTicks {
    NSMutableArray<SCDTradeData *> *result = [NSMutableArray<SCDTradeData *> new];
    
    NSString *rawData = [NSString stringWithContentsOfFile:[self getBundleFilePathFrom:SCITradeticksDataPath] encoding:NSUTF8StringEncoding error:nil];
    NSArray *lines = [rawData componentsSeparatedByString:@"\n"];
    
    NSDateFormatter *dateFormatter = [NSDateFormatter createWithFormat:@"HH:mm:ss.s" locale:NSLocale.currentLocale timeZone:NSTimeZone.localTimeZone];
    
    for (NSUInteger i = 0; i < lines.count - 1; i++) {
        NSArray *split  = [lines[i] componentsSeparatedByString:@","];
        if (split.count != 0) {
            NSDate *date = [dateFormatter dateFromString:split[0]];
            SCDTradeData *data = [[SCDTradeData alloc] initWithTradeDate:date tradePrice:@([split[1] doubleValue]) tradeSize:@([split[2] doubleValue])];
            
            [result addObject:data];
        }
    }
    
    return result;
}

+ (NSArray<SCIDoubleValues *> *)loadFFT {
    NSMutableArray *result = [NSMutableArray new];
    NSString *rawData = [NSString stringWithContentsOfFile:[self getBundleFilePathFrom:SCIFFTDataPath] encoding:NSUTF8StringEncoding error:nil];
    NSArray *lines = [rawData componentsSeparatedByString:@"\n"];
    for (NSUInteger i = 0; i < lines.count; i++) {
        SCIDoubleValues *fft = [SCIDoubleValues new];
        NSArray *tokens = [lines[i] componentsSeparatedByString:@","];
        for (NSUInteger i = 0; i < tokens.count; ++i) {
            [fft add: [tokens[i] doubleValue]];
        }
        [result addObject:fft];
    }
    
    return result;
}

+ (SCDDoubleSeries *)getButterflyCurve:(NSInteger)count {
    // From http://en.wikipedia.org/wiki/Butterfly_curve_%28transcendental%29
    // x = sin(t) * (e^cos(t) - 2cos(4t) - sin^5(t/12))
    // y = cos(t) * (e^cos(t) - 2cos(4t) - sin^5(t/12))
    double temp = 0.01;
    SCDDoubleSeries *doubleSeries = [[SCDDoubleSeries alloc] initWithCapacity:count];
    for (NSInteger i = 0; i < count; i++) {
        double t = i * temp;

        double multiplier = pow(M_E, cos(t)) - 2 * cos(4 * t) - pow(sin(t / 12), 5);

        double x = sin(t) * multiplier;
        double y = cos(t) * multiplier;
        [doubleSeries addX:x y:y];
    }
    return doubleSeries;
}

+ (NSArray *)loadWaveformData {
    NSMutableArray *result = [NSMutableArray new];

    NSString *rawData = [NSString stringWithContentsOfFile:[self getBundleFilePathFrom:SCIWaveformDataPath] encoding:NSUTF8StringEncoding error:nil];
    NSArray *lines = [rawData componentsSeparatedByString:@"\n"];
    for (NSUInteger i = 0; i < lines.count; i++) {
        [result addObject:lines[i]];
    }
    
    return result;
}

+ (SCDDoubleSeries *)getDampedSinewaveWithAmplitude:(double)amplitude DampingFactor:(double)dampingFactor PointCount:(NSInteger)pointCount Freq:(NSInteger)freq {
    return [self getDampedSinewaveWithPad:0 Amplitude:amplitude Phase:0.0 DampingFactor:dampingFactor PointCount:pointCount Freq:freq];
}

+ (SCDDoubleSeries *)getDampedSinewaveWithPad:(NSInteger)pad Amplitude:(double)amplitude Phase:(double)phase DampingFactor:(double)dampingFactor PointCount:(NSInteger)pointCount Freq:(NSInteger)freq {
    SCDDoubleSeries *doubleSeries = [[SCDDoubleSeries alloc] initWithCapacity:pointCount];

    for (NSInteger i = 0; i < pad; i++) {
        double time = 10 * i / (double) pointCount;
        [doubleSeries addX:time y:0];
    }

    for (NSInteger i = pad, j = 0; i < pointCount; i++, j++) {
        double time = 10 * i / (double) pointCount;
        double wn = 2 * M_PI / (pointCount / (double) freq);

        const double d = amplitude * sin(j * wn + phase);
        [doubleSeries addX:time y:d];

        amplitude *= (1.0 - dampingFactor);
    }

    return doubleSeries;
}

+ (SCDDoubleSeries *)getSinewaveWithAmplitude:(double)amplitude Phase:(double)phase PointCount:(NSInteger)pointCount Freq:(NSInteger)freq {
    return [self getDampedSinewaveWithPad:0 Amplitude:amplitude Phase:phase DampingFactor:0 PointCount:pointCount Freq:freq];
}

+ (SCDDoubleSeries *)getSinewaveWithAmplitude:(double)amplitude Phase:(double)phase PointCount:(NSInteger)pointCount {
    return [self getSinewaveWithAmplitude:amplitude Phase:phase PointCount:pointCount Freq:10];
}

+ (SCDDoubleSeries *)getNoisySinewaveWithAmplitude:(double)amplitude Phase:(double)phase PointCount:(NSInteger)pointCount NoiseAmplitude:(double)noiseAmplitude {
    SCDDoubleSeries *doubleSeries = [self getSinewaveWithAmplitude:amplitude Phase:phase PointCount:pointCount];
    SCIDoubleValues *yValues = doubleSeries.yValues;

    for (int i = 0; i < pointCount; i++) {
        double y = [yValues getValueAt:i];
        [yValues set:y + [SCDRandomUtil nextDouble] * noiseAmplitude - noiseAmplitude * 0.5 at:i];
    }

    return doubleSeries;
}

+ (SCIDoubleValues *)offset:(SCIDoubleValues *)input offset:(double)offset {
    SCIDoubleValues *result = [SCIDoubleValues new];
    for (NSInteger i = 0, count = input.count; i < count; i++) {
        [result add:[input getValueAt:i] + offset];
    }
    return result;
}

+ (SCIDoubleValues *)computeMovingAverageOf:(SCIDoubleValues *)input length:(NSInteger)length {
    SCIDoubleValues *result = [SCIDoubleValues new];
    for (NSInteger i = 0, count = input.count; i < count; i++) {
        if (i < length) {
            [result add:NAN];
            continue;
        }
        [result add:[self p_SCD_averageOf:input from:i - length to:i]];
    }
    return result;
}

+ (double)p_SCD_averageOf:(SCIDoubleValues *)input from:(NSInteger)from to:(NSInteger)to {
    double result = 0;
    for (NSInteger i = from; i < to; i++) {
        result += [input getValueAt:i];
    }
    return result / (to - from);
}

+ (SCIDoubleValues *)scaleValues:(SCIDoubleValues *)input scale:(double)scale {
    SCIDoubleValues *result = [SCIDoubleValues new];
    for (NSInteger i = 0, count = input.count; i < count; i++) {
        [result add:[input getValueAt:i] * scale];
    }
    return result;
}

+ (NSString *)getBundleFilePathFrom:(NSString *)path {
    NSArray *components = [path componentsSeparatedByString:@"."];
    NSString *fileName = components[0];
    NSString *extension = components[1];
    
    NSString *filePath = [[NSBundle bundleWithIdentifier:ExamplesBundleId] pathForResource:fileName ofType:extension];
    
    return filePath;
}

+ (double *)getValuesArray:(SCIDoubleValues *)values count:(NSInteger)count {
    [values clear];
    
    values.count = count;
    
    return values.itemsArray;
}

+ (double)getGaussianRandomNumber:(double)mean stdDev:(double)stdDev {
    double u1 = [SCDRandomUtil nextDouble];
    double u2 = [SCDRandomUtil nextDouble];
    double randStdNormal = sqrt(-2.0 * log(u1)) * sin(2.0 * M_PI * u2);
    
    return mean * stdDev * randStdNormal;
}

+ (unsigned int)randomColor {
    CGFloat red = arc4random_uniform(256) / 255.0;
    CGFloat green = arc4random_uniform(256) / 255.0;
    CGFloat blue = arc4random_uniform(256) / 255.0;
    SCIColor *color = [SCIColor colorWithRed:red green:green blue:blue alpha:1.0];
    return color.colorARGBCode;
}

+ (float)randomScale {
    return ([SCDRandomUtil nextFloat] + 0.5) * 3.0;
}

+ (BOOL)randomBool {
    return arc4random_uniform(2) == 0;
}

+ (SCDAscData *)ascDataFromFile:(NSString *)fileName {
    NSString *rawData = [NSString stringWithContentsOfFile:[self getBundleFilePathFrom:fileName] encoding:NSUTF8StringEncoding error:nil];
    NSArray<NSString *> *lines = [rawData componentsSeparatedByString:@"\n"];
    
    if (lines.count <= 6) return nil;
    
    SCDAscData *result = [[SCDAscData alloc] initWithRawData:lines];
    
    return result;
}

@end
