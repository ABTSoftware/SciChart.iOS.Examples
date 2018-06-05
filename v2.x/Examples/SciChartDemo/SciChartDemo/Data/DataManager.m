//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// DataManager.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "DataManager.h"
#import "RandomUtil.h"
#import "TradeData.h"

NSString * const SCIPriceInduDailyDataPath = @"INDU_Daily.csv";
NSString * const SCIPriceEURUSDDailyDataPath = @"EURUSD_Daily.csv";
NSString * const SCITradeticksDataPath = @"TradeTicks.csv";
NSString * const SCIWaveformDataPath = @"WaveformData.txt";

@implementation DataManager

+ (void)setFourierSeries:(DoubleSeries *)doubleSeries amplitude:(double)amp phaseShift:(double)pShift count:(int)count {
    [doubleSeries clear];
    
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

+ (void)setLissajousCurve:(DoubleSeries *)doubleSeries alpha:(double)alpha beta:(double)beta delta:(double)delta count:(int)count {
    // From http://en.wikipedia.org/wiki/Lissajous_curve
    // x = Asin(at + d), y = Bsin(bt)
    [doubleSeries clear];
    
    for (int i = 0; i < count; i++) {
        [doubleSeries addX:sin(alpha * i * 0.1 + delta) Y:sin(beta * i * 0.1)];
    }
}

+ (DoubleSeries *)getLissajousCurveWithAlpha:(double)alpha beta:(double)beta delta:(double)delta count:(int)count {
    DoubleSeries * doubleSeries = [DoubleSeries new];
    
    [self setLissajousCurve:doubleSeries alpha:alpha beta:beta delta:delta count:count];
    
    return doubleSeries;
}

+ (void)setStraightLines:(DoubleSeries *)doubleSeries gradient:(double)gradient yIntercept:(double)yIntercept pointCount:(int)pointCount {
    [doubleSeries clear];

    for (int i = 0; i < pointCount; i++) {
        double x = i + 1;
        [doubleSeries addX:x Y:gradient * x + yIntercept];
    }
}

+ (DoubleSeries *)getStraightLinesWithGradient:(double)gradient yIntercept:(double)yIntercept pointCount:(int)pointCount {
    DoubleSeries * doubleSeries = [DoubleSeries new];
    
    [self setStraightLines:doubleSeries gradient:gradient yIntercept:yIntercept pointCount:pointCount];
    
    return doubleSeries;
}

+ (DoubleSeries *)getExponentialCurveWithExponent:(double)exponent count:(int)count {
    DoubleSeries * doubleSeries = [[DoubleSeries alloc] initWithCapacity:count];
    
    double x = 0.00001;
    double y;
    
    double fudgeFactor = 1.4;
    for (int i = 0; i < count; i++) {
        x *= fudgeFactor;
        y = pow(i + 1, exponent);
        
        [doubleSeries addX:x Y:y];
    }
    
    return doubleSeries;
}

+ (void)setRandomDoubleSeries:(DoubleSeries *)doubleSeries count:(int)count {
    [doubleSeries clear];
    
    double amplitude = randf(0.0, 1.0) + 0.5;
    double freq = M_PI * (randf(0.0, 1.0) + 0.5) * 10;
    double offset = randf(0.0, 1.0) - 0.5;
    for (int i = 0; i < count; i++) {
        [doubleSeries addX:i Y:offset + amplitude + sin(freq * i)];
    }
}

+ (DoubleSeries *)getRandomDoubleSeriesWithCount:(int)count {
    DoubleSeries * doubleSeries = [[DoubleSeries alloc] initWithCapacity:count];
    
    [self setRandomDoubleSeries:doubleSeries count:count];
    
    return doubleSeries;
}

+ (PriceSeries *)getPriceDataIndu {
    return [self getPriceBarsFromPath:SCIPriceInduDailyDataPath dateFormat:@"MM/dd/yyyy"];
}

+ (PriceSeries *)getPriceDataEurUsd {
    return [self getPriceBarsFromPath:SCIPriceEURUSDDailyDataPath dateFormat:@"yyyy.MM.dd"];
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

+ (NSArray *)loadWaveformData {
    NSMutableArray * result = [NSMutableArray new];

    NSString * rawData = [NSString stringWithContentsOfFile:[self getBundleFilePathFrom:SCIWaveformDataPath] encoding:NSUTF8StringEncoding error:nil];
    NSArray * lines = [rawData componentsSeparatedByString:@"\n"];
    for (int i = 0; i < lines.count; i++) {
        [result addObject:lines[i]];
    }
    
    return result;
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

+ (double *)offsetArray:(double *)sourceArray destArray:(double *)destArray count:(int)count offset:(double)offset {
    for (int i = 0; i < count; i++) {
        destArray[i] = sourceArray[i] + offset;
    }
    return destArray;
}

+ (double *)computeMovingAverageOf:(double *)sourceArray destArray:(double *)destArray sourceArraySize:(int)sourceArraySize length:(int)length {
    for (int i = 0; i < sourceArraySize; i++) {
        if (i < length) {
            destArray[i] = NAN;
            continue;
        }
        destArray[i] = [self averageOf:sourceArray from:i - length to:i];
    }
    
    return destArray;
}

+ (double)averageOf:(double *)sourceArray from:(int)from to:(int)to {
    double result = 0;
    for (int i = from; i < to; i++) {
        result += sourceArray[i];
    }
    return result / (to - from);
}

+ (void)scaleValues:(SCIArrayController *)array {
    for (int i = 0; i < array.count; i++) {
        double value = SCIGenericDouble([array valueAt:i]);
        [array setValue:SCIGeneric((value + 1) * 5) At:i];
    }
}

+ (NSString *)getBundleFilePathFrom:(NSString *)path {
    NSArray * components = [path componentsSeparatedByString:@"."];
    NSString * fileName = components[0];
    NSString * extension = components[1];
    
    NSString * filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:extension];
    
    return filePath;
}

@end
