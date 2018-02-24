//
//  DataManager.h
//  SciChartDemo
//
//  Created by Admin on 09.11.15.
//  Copyright © 2015 SciChart Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PriceSeries.h"
#import "DoubleSeries.h"
#import "RandomUtil.h"

@protocol SCIXyDataSeriesProtocol;
@protocol SCIXyzDataSeriesProtocol;
@protocol SCIOhlcDataSeriesProtocol;
@class SCDMultiPaneItem, SCIXyDataSeries, SCIDataSeries;

typedef struct {
    float minRandMul;
    float minRandAdd;
    float maxRandMul;
    float maxRandAdd;
    
    float add;
    float addMul;
} DataManagerRandom;

typedef void(^XyDataFunction)(id<SCIXyDataSeriesProtocol>,int);
typedef void(^OhlcDataFunction)(id<SCIOhlcDataSeriesProtocol>,int);
typedef void(^OnNewData)(SCDMultiPaneItem *);

static inline int32_t randi(int32_t min, int32_t max) {
    return rand() % (max - min) + min;
}

static inline double randf(double min, double max) {
    return [RandomUtil nextDouble] * (max - min) + min;
}

@interface DataManager : NSObject

+(void) setLissajousCurve: (id<SCIXyDataSeriesProtocol>) data
                    alpha: (double) alpha
                     beta: (double) beta
                    delta: (double) delta
                    count: (int) count;

+(void)getStraightLines:(SCIXyDataSeries*)series
                       :(double)gradient
                       :(double)yIntercept
                       :(int)pointCount;

+(void) getExponentialCurve: (id<SCIXyDataSeriesProtocol>) data
                      cound: (int) count
                   exponent: (double) exponent;

+(void)getRandomDoubleSeries: (id<SCIXyDataSeriesProtocol>) data
                       cound: (int) count;

+(void) loadXyData:(id<SCIXyDataSeriesProtocol>)data
              From:(double)min
                To:(double)max
            Random:(DataManagerRandom)params;

+(void) loadXyData:(id<SCIXyDataSeriesProtocol>)data
              From:(double)min
                To:(double)max
          Function:(XyDataFunction)func;

+(void) loadOhlcData:(id<SCIOhlcDataSeriesProtocol>)data
                From:(double)min
                  To:(double)max
            Function:(OhlcDataFunction)func;



+ (PriceSeries *)getPriceDataIndu;

+ (PriceSeries *)getPriceDataEurUsd;

+ (PriceSeries *)getPriceBarsFromPath:(NSString *)path dateFormat:(NSString *)dateFormatString;

+ (void)loadDataFromFile:(id<SCIXyDataSeriesProtocol>) dataSeries fileName:(NSString*) fileName;

+ (NSArray *)getTradeTicks;

+ (void)loadDataFromFile:(id<SCIXyDataSeriesProtocol>) dataSeries fileName:(NSString*) fileName count:(NSUInteger)count;

+ (void)putDefaultDataMultiPaneIntoDataSeries:(id<SCIXyDataSeriesProtocol>)dataSeries dataCount:(int)dataCount;



+ (void)setFourierSeries:(DoubleSeries *)doubleSeries amplitude:(double)amp phaseShift:(double)pShift count:(int)count;

+ (DoubleSeries *)getFourierSeriesWithAmplitude:(double)amp phaseShift:(double)pShift count:(int)count;

+ (void)setFourierSeriesZoomed:(DoubleSeries *)doubleSeries amplitude:(double)amp phaseShift:(double)pShift xStart:(double)xstart xEnd:(double)xend count:(int)count;

+ (DoubleSeries *)getFourierSeriesWithAmplitude:(double)amp phaseShift:(double)pShift xStart:(double)xstart xEnd:(double)xend count:(int)count;



+ (DoubleSeries *)getDampedSinewaveWithAmplitude:(double)amplitude DampingFactor:(double)dampingFactor PointCount:(int)pointCount Freq:(int)freq;
+ (DoubleSeries *)getDampedSinewaveWithPad:(int)pad Amplitude:(double)amplitude Phase:(double)phase DampingFactor:(double)dampingFactor PointCount:(int)pointCount Freq:(int)freq;
+ (DoubleSeries *)getSinewaveWithAmplitude:(double)amplitude Phase:(double)phase PointCount:(int)pointCount Freq:(int)freq;
+ (DoubleSeries *)getSinewaveWithAmplitude:(double)amplitude Phase:(double)phase PointCount:(int)pointCount;
+ (DoubleSeries *)getNoisySinewaveWithAmplitude:(double)amplitude Phase:(double)phase PointCount:(int)pointCount NoiseAmplitude:(double)noiseAmplitude;

+ (double *) offsetArray:(double *)sourceArray destArray:(double *)destArray count:(int)count offset:(double)offset;;

+ (NSArray<SCDMultiPaneItem *>*)loadPaneStockData;
+ (NSArray<SCDMultiPaneItem *> *)loadThemeData;

@end

@interface SCDMultiPaneItem : NSObject

@property double open;
@property double high;
@property double low;
@property double close;
@property double volume;
@property NSDate *dateTime;

@end

@interface SCDMovingAverage : NSObject

@property double current;

- (instancetype)initWithLength:(int)length;
- (SCDMovingAverage*)push:(double)value;
- (void)update:(double)value;

@end

@interface SCDMcadPointItem : NSObject

@property double mcad;
@property double signal;
@property double divergence;

@end

@interface MarketDataService : NSObject

-(instancetype) initWithStartDate:(NSDate *)startDate
                 TimeFrameMinutes:(int) timeFrameMinutes
               TickTimerIntervals:(int) tickTimerIntervals;

-(NSMutableArray *) getHistoricalData:(int) numberBars;

-(SCDMultiPaneItem *) getNextBar;

@end

@interface RandomPriceDataSource : NSObject

@property (nonatomic, readonly) BOOL IsRunning;
@property (nonatomic) OnNewData updateData;
@property (nonatomic) OnNewData newData;

-(instancetype) initWithCandleIntervalMinutes:(int) candleIntervalMinutes
                              SimulateDateGap:(BOOL) simulateDateGap
                                 TimeInterval:(double) timeInterval
                              UpdatesPerPrice:(int) updatesPerPrice
                                   RandomSeed:(int) randomSeed
                                StartingPrice:(double) startingPrice
                                    StartDate:(NSDate *) startDate;

-(void) startGeneratePriceBars;
-(void) stopGeneratePriceBars;
-(SCDMultiPaneItem *) getNextData;
-(SCDMultiPaneItem *) getUpdateData;
-(SCDMultiPaneItem *) getNextRandomPriceBar;
-(NSDate *) emulateDateGap: (NSDate *) candleOpenTime;
-(void) onTimerElapsed;
-(void) clearEventHandlers;
-(SCDMultiPaneItem *) tick;

@end
