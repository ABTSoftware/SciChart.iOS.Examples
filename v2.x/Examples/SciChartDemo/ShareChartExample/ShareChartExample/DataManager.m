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
#import <SciChart/SciChart.h>
#import <Accelerate/Accelerate.h>
#import "RandomUtil.h"

@implementation DataManager

+ (void)getFourierSeries:(id<SCIXyDataSeriesProtocol>)dataSeries
               amplitude:(double)amp
              phaseShift:(double)pShift
                   count:(int)count{

    for(int i=0; i<count; i++){
        double time = 10 * (double)i / (double)count;
        double wn = 2.0 * M_PI / ((double)count/10);
        double y = M_PI * amp * (sin((double)i * wn + pShift)
                                 + 0.33 * sin((double)i * 3 * wn + pShift)
                                 + 0.20 * sin((double)i * 5 * wn + pShift)
                                 + 0.14 * sin((double)i * 7 * wn + pShift)
                                 + 0.11 * sin((double)i * 9 * wn + pShift)
                                 + 0.09 * sin((double)i * 11 * wn + pShift));
        [dataSeries appendX:SCIGeneric(time) Y:SCIGeneric(y)];
    }
}

+ (void)getFourierSeriesZoomed:(id<SCIXyDataSeriesProtocol>)dataSeries
                     amplitude:(double)amp
                    phaseShift:(double)pShift
                        xStart:(double)xstart
                          xEnd:(double)xend
                         count:(int)count{
    [self getFourierSeries:dataSeries amplitude:amp phaseShift:pShift count:count];

    int index0 = 0;
    int index1 = 0;

    for (int i=0; i<count; i++) {
        if(SCIGenericDouble([[dataSeries xValues] valueAt:i]) > xstart && index0 == 0){
            index0 = i;
        }

        if(SCIGenericDouble([[dataSeries xValues] valueAt:i]) > xend && index1 == 0){
            index1 = i;
            break;
        }
    }

    [[dataSeries xValues] removeRangeFrom:index1 Count:count-index1];
    [[dataSeries yValues] removeRangeFrom:index1 Count:count-index1];
    [[dataSeries xValues] removeRangeFrom:0 Count:index0];
    [[dataSeries yValues] removeRangeFrom:0 Count:index0];
}

+ (id<SCIXyDataSeriesProtocol>)p_generateXDateTimeSeriesWithYValues:(NSArray*)yValues {
    SCIXyDataSeries *dataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_DateTime
                                                                   YType:SCIDataType_Double
                                                             ];
    SCIGenericType yData;
    yData.doubleData = arc4random_uniform(100);
    yData.type = SCIDataType_Double;

    for (int i = 0; i < yValues.count; i++) {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:60*60*24*i];
        SCIGenericType xData = SCIGeneric(date);
        double value = [yValues[i] doubleValue];
        yData.doubleData = value;
        [dataSeries appendX:xData Y:yData];
    }

    dataSeries.dataDistributionCalculator = [SCIUserDefinedDistributionCalculator new];

    return dataSeries;
}

+ (id<SCIXyDataSeriesProtocol>)porkDataSeries {
    NSArray *porkData = [NSArray arrayWithObjects: @10, @13, @7, @16, @4, @6, @20, @14, @16, @10, @24, @11, nil];
    return [self p_generateXDateTimeSeriesWithYValues:porkData];
}

+ (id<SCIXyDataSeriesProtocol>)vealDataSeries {
    NSArray *vealData = [NSArray arrayWithObjects: @12, @17, @21, @15, @19, @18, @13, @21, @22, @20, @5, @10, nil];
    return [self p_generateXDateTimeSeriesWithYValues:vealData];
}

+ (id<SCIXyDataSeriesProtocol>)pepperDataSeries {
    NSArray *pepperData = [NSArray arrayWithObjects: @7, @24, @21, @11, @19, @17, @14, @27, @26, @22, @28, @16, nil];
    return [self p_generateXDateTimeSeriesWithYValues:pepperData];
}

+ (id<SCIXyDataSeriesProtocol>)tomatoesDataSeries {
    NSArray *tomatoesData = [NSArray arrayWithObjects: @7, @30, @27, @24, @21, @15, @17, @26, @22, @28, @21, @22, nil];
    return [self p_generateXDateTimeSeriesWithYValues:tomatoesData];
}

+ (id<SCIXyDataSeriesProtocol>)cucumberDataSeries {
    NSArray *cucumberData = [NSArray arrayWithObjects: @16, @10, @9, @8, @22, @14, @12, @27, @25, @23, @17, @17, nil];
    return [self p_generateXDateTimeSeriesWithYValues:cucumberData];
}

+ (NSArray<SCIDataSeries*>*)stackedVerticalColumnSeries {
    return @[[self porkDataSeries], [self vealDataSeries], [self tomatoesDataSeries], [self cucumberDataSeries], [self pepperDataSeries]];
}

+ (NSArray<SCIDataSeries*>*)stackedBarChartSeries {

    NSMutableArray<SCIDataSeries*> *dataSeries = [[NSMutableArray alloc] initWithCapacity:3];

    NSArray *yValues_1 = [NSArray arrayWithObjects: @0.0, @0.1, @0.2, @0.4, @0.8, @1.1, @1.5, @2.4, @4.6, @8.1, @11.7, @14.4, @16.0, @13.7, @10.1, @6.4, @3.5, @2.5, @5.4, @6.4, @7.1, @8.0, @9.0, nil];
    NSArray *yValues_2 = [NSArray arrayWithObjects: @2.0, @10.1, @10.2, @10.4, @10.8, @1.1, @11.5, @3.4, @4.6, @0.1, @1.7, @14.4, @16.0, @13.7, @10.1, @6.4, @3.5, @2.5, @1.4, @0.4, @10.1, @0.0, @0.0, nil];
    NSArray *yValues_3 = [NSArray arrayWithObjects: @20.0, @4.1, @4.2, @10.4, @10.8, @1.1, @11.5, @3.4, @4.6, @5.1, @5.7, @14.4, @16.0, @13.7, @10.1, @6.4, @3.5, @2.5, @1.4, @10.4, @8.1, @10.0, @15.0, nil];


    SCIXyDataSeries *data1 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    SCIXyDataSeries *data2 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    SCIXyDataSeries *data3 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];

    for (int i = 0; i < yValues_1.count; i++) {
        [data1 appendX:SCIGeneric(i) Y:SCIGeneric([yValues_1[i] doubleValue])];
        [data2 appendX:SCIGeneric(i) Y:SCIGeneric([yValues_2[i] doubleValue])];
        [data3 appendX:SCIGeneric(i) Y:SCIGeneric([yValues_3[i] doubleValue])];
    }

    [dataSeries addObject:data1];
    [dataSeries addObject:data2];
    [dataSeries addObject:data3];

    return dataSeries;
}

+ (NSArray<SCIDataSeries*>*)stackedSideBySideDataSeries {

    NSArray *china = @[@1.269, @1.330, @1.356, @1.304];
    NSArray *india = @[@1.004, @1.173, @1.236, @1.656];
    NSArray *usa = @[@0.282, @0.310, @0.319, @0.439];
    NSArray *indonesia = @[@0.214, @0.243, @0.254, @0.313];
    NSArray *brazil = @[@0.176, @0.201, @0.203, @0.261];
    NSArray *pakistan = @[@0.146, @0.184, @0.196, @0.276];
    NSArray *nigeria = @[@0.123, @0.152, @0.177, @0.264];
    NSArray *bangladesh = @[@0.130, @0.156, @0.166, @0.234];
    NSArray *russia = @[@0.147, @0.139, @0.142, @0.109];
    NSArray *japan = @[@0.126, @0.127, @0.127, @0.094];
    NSArray *restOfWorld = @[@2.466, @2.829, @3.005, @4.306];

    SCIXyDataSeries *data1 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    SCIXyDataSeries *data2 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    SCIXyDataSeries *data3 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    SCIXyDataSeries *data4 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    SCIXyDataSeries *data5 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    SCIXyDataSeries *data6 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    SCIXyDataSeries *data7 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    SCIXyDataSeries *data8 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    SCIXyDataSeries *data9 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    SCIXyDataSeries *data10 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    SCIXyDataSeries *data11 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    SCIXyDataSeries *data12 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];

    for (int i = 0; i < 4; i++) {

        double xValue = 2000;

        if (i == 1) {
            xValue = 2010;
        }
        else if (i == 2) {
            xValue = 2014;
        }
        else if (i == 3) {
            xValue = 2050;
        }

        [data1 appendX:SCIGeneric(xValue) Y: SCIGeneric([china[i] doubleValue])];

        if (i != 2) {
            [data2 appendX:SCIGeneric(xValue) Y: SCIGeneric([india[i] doubleValue])];
            [data3 appendX:SCIGeneric(xValue) Y: SCIGeneric([usa[i] doubleValue])];
            [data4 appendX:SCIGeneric(xValue) Y: SCIGeneric([indonesia[i] doubleValue])];
            [data5 appendX:SCIGeneric(xValue) Y: SCIGeneric([brazil[i] doubleValue])];
        }
        else {
            [data2 appendX:SCIGeneric(xValue) Y: SCIGeneric(NAN)];
            [data3 appendX:SCIGeneric(xValue) Y: SCIGeneric(NAN)];
            [data4 appendX:SCIGeneric(xValue) Y: SCIGeneric(NAN)];
            [data5 appendX:SCIGeneric(xValue) Y: SCIGeneric(NAN)];
        }

        [data6 appendX:SCIGeneric(xValue) Y: SCIGeneric([pakistan[i] doubleValue])];
        [data7 appendX:SCIGeneric(xValue) Y: SCIGeneric([nigeria[i] doubleValue])];
        [data8 appendX:SCIGeneric(xValue) Y: SCIGeneric([bangladesh[i] doubleValue])];
        [data9 appendX:SCIGeneric(xValue) Y: SCIGeneric([russia[i] doubleValue])];
        [data10 appendX:SCIGeneric(xValue) Y: SCIGeneric([japan[i] doubleValue])];
        [data11 appendX:SCIGeneric(xValue) Y: SCIGeneric([restOfWorld[i] doubleValue])];
        [data12 appendX:SCIGeneric(xValue) Y: SCIGeneric([china[i] doubleValue] + [india[i] doubleValue] + [usa[i] doubleValue] + [indonesia[i] doubleValue] + [brazil[i] doubleValue] + [pakistan[i] doubleValue] + [nigeria[i] doubleValue] + [bangladesh[i] doubleValue] + [russia[i] doubleValue] + [japan[i] doubleValue] + [restOfWorld[i] doubleValue])];

    }

    NSArray<SCIDataSeries*> *dataSeries = [[NSArray alloc] initWithObjects:data1, data2, data3, data4, data5, data6, data7, data8, data9, data10, data11, data12, nil];

    return dataSeries;
}

+(void) loadXyData:(id<SCIXyDataSeriesProtocol>)data From:(double)min To:(double)max Random:(DataManagerRandom)params {
    for (int j = min; j < max; j++) {
        double yValue = randf(j * params.minRandMul + params.minRandAdd, j * params.maxRandMul + params.maxRandAdd);
        yValue += j*params.addMul + params.add;
        if ( ([data xType] == SCIDataType_DateTime)
            && ([data yType] == SCIDataType_DateTime) )
        {
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

+(void) loadXyData:(id<SCIXyDataSeriesProtocol>)data From:(double)min To:(double)max Function:(XyDataFunction)func {
    for (int j = min; j < max; j++) {
        func(data,j);
    }
}

+(void) loadOhlcData:(id<SCIOhlcDataSeriesProtocol>)data From:(double)min To:(double)max Function:(OhlcDataFunction)func {
    for (int j = min; j < max; j++) {
        func(data,j);
    }
}

+(void) getTradeTicks:(id<SCIXyzDataSeriesProtocol>) dataSeries
             fileName:(NSString*) fileName{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName
                                                         ofType:@"csv"];

    NSString *data = [NSString stringWithContentsOfFile:filePath
                                               encoding:NSUTF8StringEncoding
                                                  error:nil];

    NSArray* items = [data componentsSeparatedByString:@"\r\n"];
    NSArray* subItems;

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss.s"];

    for (int i=0; i<items.count-1; i++) {
        subItems = [items[i] componentsSeparatedByString:@","];
        if (subItems.count==0)
            continue;

        NSDate * date =[dateFormatter dateFromString: subItems[0]];
        [dataSeries appendX:SCIGeneric(date)
                          Y:SCIGeneric([subItems[1] floatValue])
                          Z:SCIGeneric([subItems[2] floatValue])];
    }
}

+(void) setLissajousCurve: (id<SCIXyDataSeriesProtocol>) data
                    alpha: (double) alpha
                     beta: (double) beta
                    delta: (double) delta
                    count: (int) count{
    // From http://en.wikipedia.org/wiki/Lissajous_curve
    // x = Asin(at + d), y = Bsin(bt)
    double *xValues = malloc(sizeof(double)*count);
    double *yValues = malloc(sizeof(double)*count);
    
    for (int i=0; i<count; i++) {
        xValues[i] = alpha * i * 0.1 + delta;
        yValues[i] = beta * i * 0.1;
    }
    
    double *xSinValues = malloc(sizeof(double)*count);
    double *ySinValues = malloc(sizeof(double)*count);
    
    vvsin(xSinValues, xValues, &count);
    vvsin(ySinValues, yValues, &count);
    
    for (int i = 0; i < count; i++) {
        [data appendX:SCIGeneric(xSinValues[i])
                    Y:SCIGeneric(ySinValues[i])];
    }
}

+(void) getExponentialCurve: (id<SCIXyDataSeriesProtocol>) data
                      cound: (int) count
                   exponent: (double) exponent{
    double x = 0.00001;
    double y;
    double fudgeFactor = 1.4;

    for (int i=0; i<count; i++) {
        x *= fudgeFactor;
        y = pow(i+1, exponent);

        [data appendX:SCIGeneric(x) Y:SCIGeneric(y)];
    }
}

+(void)getRandomDoubleSeries: (id<SCIXyDataSeriesProtocol>) data
                       cound: (int) count{
    double amplitude = randf(0.0, 1.0) + 0.5;
    double freq = M_PI * (randf(0.0, 1.0)+0.5)*10;
    double offset = randf(0.0, 1.0) - 0.5;

    for (int i=0; i<count; i++){
        [data appendX:SCIGeneric(i) Y:SCIGeneric(offset+amplitude+sin(freq*i))];
    }
}

+(void) loadPriceData:(id<SCIOhlcDataSeriesProtocol>) dataSeries
             fileName:(NSString*) fileName
           isReversed:(BOOL) reversed
                count:(int) count{

    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName
                                                         ofType:@"txt"];

    NSString *data = [NSString stringWithContentsOfFile:filePath
                                               encoding:NSUTF8StringEncoding
                                                  error:nil];

    NSArray* items = [data componentsSeparatedByString:@"\n"];
    NSArray* subItems;
    if(!reversed)
        for (int i=0; i<count; i++) {
            subItems = [items[i] componentsSeparatedByString:@","];

            [dataSeries appendX:SCIGeneric(i)
                           Open:SCIGeneric([subItems[1] floatValue])
                           High:SCIGeneric([subItems[2] floatValue])
                            Low:SCIGeneric([subItems[3] floatValue])
                          Close:SCIGeneric([subItems[4] floatValue])];
        }
    else{
        int j=0;
        for (int i=count-1; i>=0; i--) {
            subItems = [items[i] componentsSeparatedByString:@","];

            [dataSeries appendX:SCIGeneric(j)
                           Open:SCIGeneric([subItems[1] floatValue])
                           High:SCIGeneric([subItems[2] floatValue])
                            Low:SCIGeneric([subItems[3] floatValue])
                          Close:SCIGeneric([subItems[4] floatValue])];
            ++j;
        }
    }
}

+(void) getPriceIndu:(NSString*)fileName data:(id<SCIOhlcDataSeriesProtocol>) dataSeries{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName
                                                         ofType:@"csv"];

    NSString *data = [NSString stringWithContentsOfFile: filePath
                                               encoding:NSUTF8StringEncoding
                                                  error:nil];

    NSArray* items = [data componentsSeparatedByString:@"\r\n"];
    NSArray* subItems;

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"LL/dd/yyyy"];

    for (int i = 0; i< items.count-1; i++) {
        subItems = [items[i] componentsSeparatedByString:@","];

        NSDate * date =[dateFormatter dateFromString: subItems[0]];

        [dataSeries appendX:SCIGeneric(date)
                       Open:SCIGeneric([subItems[1] floatValue])
                       High:SCIGeneric([subItems[2] floatValue])
                        Low:SCIGeneric([subItems[3] floatValue])
                      Close:SCIGeneric([subItems[4] floatValue])];
    }
}

+(NSArray<NSDictionary*>*) getPriceIndu:(NSString*)fileName {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName
                                                         ofType:@"csv"];
    
    NSString *data = [NSString stringWithContentsOfFile: filePath
                                               encoding:NSUTF8StringEncoding
                                                  error:nil];
    
    NSArray* items = [data componentsSeparatedByString:@"\r\n"];
    NSArray* subItems;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"LL/dd/yyyy"];
    
    NSMutableArray *dataSource = [[NSMutableArray alloc] initWithCapacity:items.count];
    
    for (int i = 0; i< items.count-1; i++) {
        subItems = [items[i] componentsSeparatedByString:@","];
        
        NSDate * date =[dateFormatter dateFromString: subItems[0]];
        
        [dataSource addObject:@{@"X" : date, @"Y" : subItems[1]}];

    }
    
    return dataSource;
}

+(void) loadDataFromFile:(id<SCIXyDataSeriesProtocol>) dataSeries
                fileName:(NSString*) fileName
              startIndex:(int) startIndex
               increment:(int) increment
                 reverse:(BOOL)reverse
{

    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName
                                                         ofType:@"txt"];

    NSString *data = [NSString stringWithContentsOfFile: filePath
                                               encoding:NSUTF8StringEncoding
                                                  error:nil];

    NSArray* items = [data componentsSeparatedByString:@"\n"];
    NSArray* subItems;

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];

    if (reverse) {
        for (int i = (int)(items.count - 1); i >= startIndex; i -= increment) {
            subItems = [items[i] componentsSeparatedByString:@","];

            NSDate * date =[dateFormatter dateFromString: subItems[0]];

            [dataSeries appendX:SCIGeneric(date)
                              Y: SCIGeneric([subItems[1] floatValue])];
        }
    } else {
        for (int i = startIndex; i < items.count; i += increment) {
            subItems = [items[i] componentsSeparatedByString:@","];

            NSDate * date =[dateFormatter dateFromString: subItems[0]];

            [dataSeries appendX:SCIGeneric(date)
                              Y: SCIGeneric([subItems[1] floatValue])];
        }
    }
}

+(void) loadDataFromFile:(id<SCIXyDataSeriesProtocol>) dataSeries
                fileName:(NSString*) fileName{

    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"txt"];

    NSString *data = [NSString stringWithContentsOfFile: filePath encoding:NSUTF8StringEncoding error:nil];

    NSArray* items = [data componentsSeparatedByString:@"\n"];

    for (int i=0; i<items.count; i++) {
        [dataSeries appendX:SCIGeneric(i) Y: SCIGeneric([items[i] floatValue])];
    }
}

+(void) loadDataFromFile:(id<SCIXyDataSeriesProtocol>) dataSeries
                fileName:(NSString*) fileName
                   count:(NSUInteger)count {

    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"txt"];

    NSString *data = [NSString stringWithContentsOfFile: filePath encoding:NSUTF8StringEncoding error:nil];

    NSArray* items = [data componentsSeparatedByString:@"\n"];
    count = count == 0 || count > items.count ? items.count : count;
    NSArray* subItems;
    for (int i=0; i<count; i++) {
        subItems = [items[i] componentsSeparatedByString:@","];
        [dataSeries appendX:SCIGeneric(i) Y: SCIGeneric([subItems[1] floatValue])];
    }
}

+ (void)putDefaultDataMultiPaneIntoDataSeries:(id<SCIXyDataSeriesProtocol>)dataSeries dataCount:(int)dataCount {

    SCIGenericType yData;
    yData.floatData = arc4random_uniform(100);
    yData.type = SCIDataType_Float;
    int32_t prevoius = 1;
    for (int i = 0; i < dataCount; i++) {
        prevoius = randi(prevoius, prevoius+10);
        NSDate *date = [NSDate dateWithTimeIntervalSinceNow:60*60*24*prevoius];
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

    NSArray* items = [data componentsSeparatedByString:@"\n"];
    NSArray* subItems;

    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:count];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];

    //    if(!reversed)
    for (int i = 0; i<count; i++) {
        subItems = [items[i] componentsSeparatedByString:@","];

        SCDMultiPaneItem *item = [SCDMultiPaneItem new];
        item.dateTime = [dateFormatter dateFromString: subItems[0]];
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

    NSArray* items = [data componentsSeparatedByString:@"\n"];
    NSArray* subItems;

    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:count];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];

    //    if(!reversed)
    for (int i = 0; i<count; i++) {
        subItems = [items[i] componentsSeparatedByString:@","];

        SCDMultiPaneItem *item = [SCDMultiPaneItem new];
        item.dateTime = [dateFormatter dateFromString: subItems[0]];
        item.open = [subItems[1] doubleValue];
        item.high = [subItems[2] doubleValue];
        item.low = [subItems[3] doubleValue];
        item.close = [subItems[4] doubleValue];
        item.volume = [subItems[5] doubleValue];

        [array addObject:item];

    }

    return array;
}

+(void)getStraightLines:(SCIXyDataSeries*)series :(double)gradient :(double)yIntercept :(int)pointCount {
    for (int i = 0; i < pointCount; i++) {
        double x = i + 1;
        [series appendX:SCIGeneric(x) Y:SCIGeneric(gradient*x+yIntercept)];
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

+ (DoubleSeries *)getSinewaveWithAmplitude:(double)amplitude Phase:(double)phase PointCount:(int)pointCount{
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
        _oneOverLength = 1.0/(double)length;
        _circularBuffer = [[NSMutableArray alloc] initWithCapacity:_lenght];
        _circIndex = -1;
        _current = NAN;
    }
    return self;
}

- (void)update:(double)value {

    double lostValue =  _circularBuffer[_circIndex].doubleValue;
    _circularBuffer[_circIndex] = @(value);

    // Maintain totals for Push function
    _total += value;
    _total -= lostValue;

    // If not yet filled, just return. Current value should be double.NaN
    if (!_filled)
    {
        _current = NAN;
        return;
    }

    // Compute the average
    double average = 0.0;
    for (int i = 0; i < _circularBuffer.count; i++)
    {
        average += _circularBuffer[i].doubleValue;
    }

    _current = average * _oneOverLength;

}

- (SCDMovingAverage*)push:(double)value {

    if (++_circIndex == _lenght) {
        _circIndex = 0;
    }


    double lostValue = _circIndex < _circularBuffer.count ? _circularBuffer[_circIndex].doubleValue : 0.0;
    _circularBuffer[_circIndex] = @(value);

    _total += value;
    _total -= lostValue;

    if (!_filled && _circIndex != _lenght-1) {
        _current = NAN;
        return self;
    }
    else {
        _filled = true;
    }

    _current = _total * _oneOverLength;

    return self;

}

@end

@implementation SCDMcadPointItem

@end

@implementation MarketDataService{
    NSDate *_startDate;
    int _timeFrameMinutes;
    int _tickTimerIntervals;
    RandomPriceDataSource *_generator;
}

-(instancetype) initWithStartDate:(NSDate *)startDate
                 TimeFrameMinutes:(int) timeFrameMinutes
               TickTimerIntervals:(int) tickTimerIntervals{
    self = [super init];
    if(self){
        _startDate = startDate;
        _timeFrameMinutes = timeFrameMinutes;
        _tickTimerIntervals = tickTimerIntervals;

        _generator = [[RandomPriceDataSource alloc]initWithCandleIntervalMinutes:_timeFrameMinutes SimulateDateGap:true TimeInterval:_tickTimerIntervals UpdatesPerPrice:25 RandomSeed:100 StartingPrice:30 StartDate:_startDate];
    }
    return self;
}

-(void) subscribePriceUpdate: (OnNewData) callback{
    _generator.updateData = callback;
    _generator.newData = callback;

    [_generator startGeneratePriceBars];
}

-(void) clearSubscriptions{
    if(_generator.IsRunning){
        [_generator stopGeneratePriceBars];
        [_generator clearEventHandlers];
    }
}

-(NSMutableArray *) getHistoricalData:(int) numberBars{
    NSMutableArray *prices = [[NSMutableArray alloc]initWithCapacity: numberBars];

    for (int i = 0; i < numberBars; i++){
        [prices addObject:[_generator getNextData]];
    }

    return prices;
}

-(SCDMultiPaneItem *) getNextBar{
    return [_generator tick];
}

@end

@implementation RandomPriceDataSource{
    NSTimer * _timer;
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

-(instancetype) initWithCandleIntervalMinutes:(int) candleIntervalMinutes
                              SimulateDateGap:(BOOL) simulateDateGap
                                 TimeInterval:(double) timeInterval
                              UpdatesPerPrice:(int) updatesPerPrice
                                   RandomSeed:(int) randomSeed
                                StartingPrice:(double) startingPrice
                                    StartDate:(NSDate *) startDate{
    self = [super init];
    if(self){
        Frequency = 1.1574074074074073E-05;
        _openMarketTime = 360;
        _closeMarketTime = 720;

        _candleIntervalMinutes = candleIntervalMinutes;
        _simulateDateGap = simulateDateGap;
        _updatesPerPrice = updatesPerPrice;

        _timeInerval = timeInterval;

        _initialPriceBar = [[SCDMultiPaneItem alloc]init];
        _initialPriceBar.close = startingPrice;
        _initialPriceBar.dateTime = startDate;

        _lastPriceBar = [[SCDMultiPaneItem alloc]init];
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

-(BOOL) IsRunning{
    return _timer.isValid;
}

-(void) startGeneratePriceBars{
    _timer = [NSTimer scheduledTimerWithTimeInterval: _timeInerval
                                              target:self
                                            selector:@selector(onTimerElapsed)
                                            userInfo:nil
                                             repeats:YES];
}
-(void) stopGeneratePriceBars{
    if(_timer.isValid)
        [_timer invalidate];
}
-(SCDMultiPaneItem *) getNextData{

    return [self getNextRandomPriceBar];
}
-(SCDMultiPaneItem *) getUpdateData{
    double num = _lastPriceBar.close + ([self randf:0 max:_randomSeed] - 48)*(_lastPriceBar.close/1000.0);
    double high = num>_lastPriceBar.high ? num : _lastPriceBar.high;
    double low = num<_lastPriceBar.low ? num : _lastPriceBar.low;
    long volumeInc = ([self randf:0 max:_randomSeed]*3 + 2)*0.5;

    _lastPriceBar.high = high;
    _lastPriceBar.low = low;
    _lastPriceBar.close = num;
    _lastPriceBar.volume += volumeInc;

    return _lastPriceBar;
}

-(double) randf:(double) min max:(double) max {
    return [RandomUtil nextDouble] * (max - min) + min;
}

-(SCDMultiPaneItem *) getNextRandomPriceBar{
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
    long volume = (long) (randf(0.0, 1.0)*30000 + 20000);
    NSDate *openTime = _simulateDateGap ? [self emulateDateGap:_lastPriceBar.dateTime] : _lastPriceBar.dateTime;
    NSDate *closeTime = [openTime dateByAddingTimeInterval:_candleIntervalMinutes];

    SCDMultiPaneItem *candle = [[SCDMultiPaneItem alloc]init];
    candle.close = num3;
    candle.dateTime = closeTime;
    candle.high = high;
    candle.low = low;
    candle.volume = volume;
    candle.open = close;

    _lastPriceBar = [[SCDMultiPaneItem alloc]init];
    _lastPriceBar.close = candle.close;
    _lastPriceBar.dateTime = candle.dateTime;
    _lastPriceBar.high = candle.high;
    _lastPriceBar.low = candle.low;
    _lastPriceBar.open = candle.open;
    _lastPriceBar.volume = candle.volume;

    _currentTime += _candleIntervalMinutes ;
    return candle;
}

-(NSDate *) emulateDateGap: (NSDate *) candleOpenTime{
    NSDate *result = candleOpenTime;

    if ([candleOpenTime timeIntervalSince1970] > _closeMarketTime)
    {
        NSDate *dateTime = candleOpenTime;
        dateTime = [dateTime dateByAddingTimeInterval: 500];
        result = [dateTime dateByAddingTimeInterval:_openMarketTime];
    }
    while ([result timeIntervalSince1970] < 500)
    {
        result = [result dateByAddingTimeInterval: 500];
    }
    return result;
}

-(void) onTimerElapsed{
    if (_currentUpdateCount < _updatesPerPrice)
    {
        _currentUpdateCount++;
        SCDMultiPaneItem *updatedData = [self getUpdateData];
        if (updatedData != nil)
        {
            _updateData(updatedData);
        }
    }
    else
    {
        _currentUpdateCount = 0;
        SCDMultiPaneItem *nextData = [self getNextData];
        if (nextData != nil)
        {
            _newData(nextData);
        }
    }
}

-(void) clearEventHandlers{

}

-(SCDMultiPaneItem *) tick{
    if (_currentUpdateCount < _updatesPerPrice)
    {
        _currentUpdateCount++;
        return [self getUpdateData];
    }
    else
    {
        _currentUpdateCount = 0;
        return [self getNextData];
    }
}


@end
