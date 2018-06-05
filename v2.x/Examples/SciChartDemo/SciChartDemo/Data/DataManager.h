//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// DataManager.h is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import <Foundation/Foundation.h>
#import "PriceSeries.h"
#import "DoubleSeries.h"
#import "RandomUtil.h"
#import "PriceBar.h"

@interface DataManager : NSObject

+ (void)setFourierSeries:(DoubleSeries *)doubleSeries amplitude:(double)amp phaseShift:(double)pShift count:(int)count;

+ (DoubleSeries *)getFourierSeriesWithAmplitude:(double)amp phaseShift:(double)pShift count:(int)count;

+ (void)setFourierSeriesZoomed:(DoubleSeries *)doubleSeries amplitude:(double)amp phaseShift:(double)pShift xStart:(double)xstart xEnd:(double)xend count:(int)count;

+ (DoubleSeries *)getFourierSeriesWithAmplitude:(double)amp phaseShift:(double)pShift xStart:(double)xstart xEnd:(double)xend count:(int)count;

+ (void)setLissajousCurve:(DoubleSeries *)doubleSeries alpha:(double)alpha beta:(double)beta delta:(double)delta count:(int)count;

+ (DoubleSeries *)getLissajousCurveWithAlpha:(double)alpha beta:(double)beta delta:(double)delta count:(int)count;

+ (void)setStraightLines:(DoubleSeries *)doubleSeries gradient:(double)gradient yIntercept:(double)yIntercept pointCount:(int)pointCount;

+ (DoubleSeries *)getStraightLinesWithGradient:(double)gradient yIntercept:(double)yIntercept pointCount:(int)pointCount;

+ (DoubleSeries *)getExponentialCurveWithExponent:(double)exponent count:(int)count;

+ (void)setRandomDoubleSeries:(DoubleSeries *)doubleSeries count:(int)count;

+ (DoubleSeries *)getRandomDoubleSeriesWithCount:(int)count;

+ (PriceSeries *)getPriceDataIndu;

+ (PriceSeries *)getPriceDataEurUsd;

+ (PriceSeries *)getPriceBarsFromPath:(NSString *)path dateFormat:(NSString *)dateFormatString;

+ (NSArray *)getTradeTicks;

+ (NSArray *)loadWaveformData;

+ (DoubleSeries *)getDampedSinewaveWithAmplitude:(double)amplitude DampingFactor:(double)dampingFactor PointCount:(int)pointCount Freq:(int)freq;

+ (DoubleSeries *)getDampedSinewaveWithPad:(int)pad Amplitude:(double)amplitude Phase:(double)phase DampingFactor:(double)dampingFactor PointCount:(int)pointCount Freq:(int)freq;

+ (DoubleSeries *)getSinewaveWithAmplitude:(double)amplitude Phase:(double)phase PointCount:(int)pointCount Freq:(int)freq;

+ (DoubleSeries *)getSinewaveWithAmplitude:(double)amplitude Phase:(double)phase PointCount:(int)pointCount;

+ (DoubleSeries *)getNoisySinewaveWithAmplitude:(double)amplitude Phase:(double)phase PointCount:(int)pointCount NoiseAmplitude:(double)noiseAmplitude;

+ (double *)offsetArray:(double *)sourceArray destArray:(double *)destArray count:(int)count offset:(double)offset;

+ (double *)computeMovingAverageOf:(double *)sourceArray destArray:(double *)destArray sourceArraySize:(int)sourceArraySize length:(int)length;

+ (void)scaleValues:(SCIArrayController *)array;

@end
