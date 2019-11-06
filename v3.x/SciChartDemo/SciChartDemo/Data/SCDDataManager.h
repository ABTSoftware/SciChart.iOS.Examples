//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDDataManager.h is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SCDDoubleSeries.h"
#import "SCDPriceSeries.h"
#import "SCDPriceBar.h"
#import "SCDMacdPoints.h"
#import "SCDMovingAverage.h"
#import "SCDMarketDataService.h"
#import "SCDRadix2FFT.h"
#import "SCDTradeData.h"
#import "SCDRandomUtil.h"
#import "SCDRandomWalkGenerator.h"
#import "SCDRandomPricesDataSource.h"

NS_ASSUME_NONNULL_BEGIN

@interface SCDDataManager : NSObject

+ (void)setFourierSeries:(SCDDoubleSeries *)doubleSeries amplitude:(double)amp phaseShift:(double)pShift count:(int)count;

+ (SCDDoubleSeries *)getFourierSeriesWithAmplitude:(double)amp phaseShift:(double)pShift count:(int)count;

+ (void)setFourierSeriesZoomed:(SCDDoubleSeries *)doubleSeries amplitude:(double)amp phaseShift:(double)pShift xStart:(double)xstart xEnd:(double)xend count:(int)count;

+ (SCDDoubleSeries *)getFourierSeriesWithAmplitude:(double)amp phaseShift:(double)pShift xStart:(double)xstart xEnd:(double)xend count:(int)count;

+ (void)setLissajousCurve:(SCDDoubleSeries *)doubleSeries alpha:(double)alpha beta:(double)beta delta:(double)delta count:(int)count;

+ (SCDDoubleSeries *)getLissajousCurveWithAlpha:(double)alpha beta:(double)beta delta:(double)delta count:(int)count;

+ (void)setStraightLines:(SCDDoubleSeries *)doubleSeries gradient:(double)gradient yIntercept:(double)yIntercept pointCount:(int)pointCount;

+ (SCDDoubleSeries *)getStraightLinesWithGradient:(double)gradient yIntercept:(double)yIntercept pointCount:(int)pointCount;

+ (SCDDoubleSeries *)getExponentialCurveWithExponent:(double)exponent count:(int)count;

+ (void)setRandomDoubleSeries:(SCDDoubleSeries *)doubleSeries count:(int)count;

+ (SCDDoubleSeries *)getRandomDoubleSeriesWithCount:(int)count;

+ (SCDPriceSeries *)getPriceDataIndu;

+ (SCDPriceSeries *)getPriceDataEurUsd;

+ (SCDPriceSeries *)getPriceBarsFromPath:(NSString *)path dateFormat:(NSString *)dateFormatString;

+ (NSArray<SCDTradeData *> *)getTradeTicks;

+ (SCDDoubleSeries *)getButterflyCurve:(int)count;

+ (NSArray *)loadWaveformData;

+ (SCDDoubleSeries *)getDampedSinewaveWithAmplitude:(double)amplitude DampingFactor:(double)dampingFactor PointCount:(int)pointCount Freq:(int)freq;

+ (SCDDoubleSeries *)getDampedSinewaveWithPad:(int)pad Amplitude:(double)amplitude Phase:(double)phase DampingFactor:(double)dampingFactor PointCount:(int)pointCount Freq:(int)freq;

+ (SCDDoubleSeries *)getSinewaveWithAmplitude:(double)amplitude Phase:(double)phase PointCount:(int)pointCount Freq:(int)freq;

+ (SCDDoubleSeries *)getSinewaveWithAmplitude:(double)amplitude Phase:(double)phase PointCount:(int)pointCount;

+ (SCDDoubleSeries *)getNoisySinewaveWithAmplitude:(double)amplitude Phase:(double)phase PointCount:(int)pointCount NoiseAmplitude:(double)noiseAmplitude;

+ (SCIDoubleValues *)offset:(SCIDoubleValues *)input offset:(double)offset;

+ (SCIDoubleValues *)computeMovingAverageOf:(SCIDoubleValues *)input length:(int)length;

+ (SCIDoubleValues *)scaleValues:(SCIDoubleValues *)input scale:(double)scale;

+ (NSArray<SCIDoubleValues *> *)loadFFT;

+ (double)getGaussianRandomNumber:(double)mean stdDev:(double)stdDev;

+ (unsigned int)randomColor;

+ (float)randomScale;

+ (BOOL)randomBool;

@end

NS_ASSUME_NONNULL_END
