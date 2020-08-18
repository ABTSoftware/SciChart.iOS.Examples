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
#import "SCDAscData.h"
#import "SCDRandomUtil.h"
#import "SCDRandomWalkGenerator.h"
#import "SCDRandomPricesDataSource.h"

NS_ASSUME_NONNULL_BEGIN

@interface SCDDataManager : NSObject

+ (void)setFourierSeries:(SCDDoubleSeries *)doubleSeries amplitude:(double)amp phaseShift:(double)pShift count:(NSInteger)count;

+ (SCDDoubleSeries *)getFourierSeriesWithAmplitude:(double)amp phaseShift:(double)pShift count:(NSInteger)count;

+ (void)setFourierSeriesZoomed:(SCDDoubleSeries *)doubleSeries amplitude:(double)amp phaseShift:(double)pShift xStart:(double)xstart xEnd:(double)xend count:(NSInteger)count;

+ (SCDDoubleSeries *)getFourierSeriesWithAmplitude:(double)amp phaseShift:(double)pShift xStart:(double)xstart xEnd:(double)xend count:(NSInteger)count;

+ (void)setLissajousCurve:(SCDDoubleSeries *)doubleSeries alpha:(double)alpha beta:(double)beta delta:(double)delta count:(NSInteger)count;

+ (SCDDoubleSeries *)getLissajousCurveWithAlpha:(double)alpha beta:(double)beta delta:(double)delta count:(NSInteger)count;

+ (void)setStraightLines:(SCDDoubleSeries *)doubleSeries gradient:(double)gradient yIntercept:(double)yIntercept pointCount:(NSInteger)pointCount;

+ (SCDDoubleSeries *)getStraightLinesWithGradient:(double)gradient yIntercept:(double)yIntercept pointCount:(NSInteger)pointCount;

+ (SCDDoubleSeries *)getExponentialCurveWithExponent:(double)exponent count:(NSInteger)count;

+ (void)setRandomDoubleSeries:(SCDDoubleSeries *)doubleSeries count:(NSInteger)count;

+ (SCDDoubleSeries *)getRandomDoubleSeriesWithCount:(NSInteger)count;

+ (SCDPriceSeries *)getPriceDataIndu;

+ (SCDPriceSeries *)getPriceDataEurUsd;

+ (SCDPriceSeries *)getPriceBarsFromPath:(NSString *)path dateFormat:(NSString *)dateFormatString;

+ (NSArray<SCDTradeData *> *)getTradeTicks;

+ (SCDDoubleSeries *)getButterflyCurve:(NSInteger)count;

+ (NSArray *)loadWaveformData;

+ (SCDDoubleSeries *)getDampedSinewaveWithAmplitude:(double)amplitude DampingFactor:(double)dampingFactor PointCount:(NSInteger)pointCount Freq:(NSInteger)freq;

+ (SCDDoubleSeries *)getDampedSinewaveWithPad:(NSInteger)pad Amplitude:(double)amplitude Phase:(double)phase DampingFactor:(double)dampingFactor PointCount:(NSInteger)pointCount Freq:(NSInteger)freq;

+ (SCDDoubleSeries *)getSinewaveWithAmplitude:(double)amplitude Phase:(double)phase PointCount:(NSInteger)pointCount Freq:(NSInteger)freq;

+ (SCDDoubleSeries *)getSinewaveWithAmplitude:(double)amplitude Phase:(double)phase PointCount:(NSInteger)pointCount;

+ (SCDDoubleSeries *)getNoisySinewaveWithAmplitude:(double)amplitude Phase:(double)phase PointCount:(NSInteger)pointCount NoiseAmplitude:(double)noiseAmplitude;

+ (SCIDoubleValues *)offset:(SCIDoubleValues *)input offset:(double)offset;

+ (SCIDoubleValues *)computeMovingAverageOf:(SCIDoubleValues *)input length:(NSInteger)length;

+ (SCIDoubleValues *)scaleValues:(SCIDoubleValues *)input scale:(double)scale;

+ (NSArray<SCIDoubleValues *> *)loadFFT;

+ (NSString *)getBundleFilePathFrom:(NSString *)path;

+ (double)getGaussianRandomNumber:(double)mean stdDev:(double)stdDev;

+ (unsigned int)randomColor;

+ (float)randomScale;

+ (BOOL)randomBool;

+ (nullable SCDAscData *)ascDataFromFile:(NSString *)fileName;

@end

NS_ASSUME_NONNULL_END
