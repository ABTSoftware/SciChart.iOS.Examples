//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// ImageAnnotation.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "ImageAnnotation.h"

#import <Foundation/Foundation.h>
#import <SciChart/SciChart.h>

@interface DistributionData : NSObject

@property (nonatomic, strong) NSArray<NSDictionary<NSString *, id> *> *arrCarsData;

+ (instancetype)sharedInstance;

@end

@implementation DistributionData

+ (instancetype)sharedInstance {
    static DistributionData *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _arrCarsData = @[
            @{@"country": @"China", @"cars_sold": @30094767, @"icon": @"cn"},
            @{@"country": @"United States", @"cars_sold": @15604278, @"icon": @"us"},
            @{@"country": @"Japan", @"cars_sold": @4779639, @"icon": @"jp"},
            @{@"country": @"India", @"cars_sold": @4108263, @"icon": @"in"},
            @{@"country": @"Germany", @"cars_sold": @2845764, @"icon": @"de"},
            @{@"country": @"Brazil", @"cars_sold": @2309243, @"icon": @"br"},
            @{@"country": @"United Kingdom", @"cars_sold": @1905522, @"icon": @"gb"},
            @{@"country": @"France", @"cars_sold": @1776921, @"icon": @"fr"},
            @{@"country": @"Canada", @"cars_sold": @1664327, @"icon": @"ca"},
            @{@"country": @"Italy", @"cars_sold": @1568623, @"icon": @"ir"}
        ];
    }
    return self;
}

@end

@implementation ImageAnnotation

- (Class)associatedType { return SCIChartSurface.class; }

- (BOOL)showDefaultModifiersInToolbar { return NO; }

- (void)initExample {
    
    id<ISCIAxis> xAxis = [SCINumericAxis new];
    xAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.08 max:0.08];
    xAxis.axisAlignment = SCIAxisAlignment_Left;
#if TARGET_OS_OSX
    xAxis.axisTickLabelStyle = [[SCIAxisTickLabelStyle alloc] initWithAlignment:SCIAlignment_Right andMargins:NSEdgeInsetsZero];
#elif TARGET_OS_IOS
    xAxis.axisTickLabelStyle = [[SCIAxisTickLabelStyle alloc] initWithAlignment:SCIAlignment_Right andMargins:UIEdgeInsetsZero];
#endif
    
    xAxis.isVisible = NO;
    xAxis.visibleRange = [[SCIDoubleRange alloc] initWithMin:-1.5 max:10];
    
    id<ISCIAxis> yAxis = [SCINumericAxis new];
    yAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0 max:0.2];
    yAxis.axisAlignment = SCIAxisAlignment_Bottom;
    yAxis.flipCoordinates = YES;
    
    SCIXyDataSeries *ds1 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Byte yType:SCIDataType_Double];
    NSMutableArray<id<ISCIAnnotation>> *arrAnno = [NSMutableArray new];
    
    DistributionData *distributionData = [DistributionData sharedInstance];
    for (NSUInteger i = 0; i < distributionData.arrCarsData.count; i++) {
        NSDictionary *carData = distributionData.arrCarsData[i];
        NSNumber *yValue = carData[@"cars_sold"];
        if (yValue != nil) {
            [ds1 appendX:@(i) y:yValue];
            
            // Adding image annotation for each bar
            SCIImageAnnotation *imageAnno = [SCIImageAnnotation new];
            NSString *imgName = carData[@"icon"];
            SCIImage *image = [SCIImage imageNamed:imgName];
            if (image) {
                imageAnno.image = image;
            }
            imageAnno.desiredSize = CGSizeMake(20, 20);
            imageAnno.contentMode = SCIContentMode_AspectFit;
            [imageAnno setX1:@(i)];
            [imageAnno setY1:yValue];
            imageAnno.annotationPosition = SCIAlignment_Left | SCIAlignment_CenterVertical;
            
            [arrAnno addObject:imageAnno];
        }
    }
    
    SCIFastColumnRenderableSeries *rSeries = [self getRenderableSeriesWithDataSeries:ds1 color:0xff1f6f6f];
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        [self.surface.xAxes add:xAxis];
        [self.surface.yAxes add:yAxis];
        [self.surface.renderableSeries add:rSeries];
        
        SCITextAnnotation *titleAnnotation = [SCITextAnnotation new];
        [titleAnnotation setX1:@-1];
        [titleAnnotation setY1:@8000000];
        titleAnnotation.text = @"Top 10 car markets";
        
        NSDictionary *fontAttributes = @{ SCIFontDescriptorNameAttribute: @"ArialRoundedMTBold", SCIFontDescriptorSizeAttribute: @22 };
        SCIFontDescriptor *fontDescriptor = [SCIFontDescriptor fontDescriptorWithFontAttributes:fontAttributes];
        titleAnnotation.fontStyle = [[SCIFontStyle alloc] initWithFontDescriptor:fontDescriptor andTextColor:SCIColor.whiteColor];
        
        SCITextAnnotation *descriptionAnnotation = [SCITextAnnotation new];
        [descriptionAnnotation setX1:@5.5];
        [descriptionAnnotation setY1:@9000000];
        descriptionAnnotation.text = @"The image annotation can be placed\nin front or behind the grid lines and\ncan either be fixed or\nmoved along with the chart.";
        NSDictionary *fontAttributes2 = @{ SCIFontDescriptorNameAttribute: @"ArialRoundedMTBold", SCIFontDescriptorSizeAttribute: @16 };
        SCIFontDescriptor *fontDescriptor2 = [SCIFontDescriptor fontDescriptorWithFontAttributes:fontAttributes2];
        descriptionAnnotation.fontStyle = [[SCIFontStyle alloc] initWithFontDescriptor:fontDescriptor2 andTextColor:SCIColor.whiteColor];
        
#if TARGET_OS_OSX
#elif TARGET_OS_IOS
#endif
        
        
        self.imageAnnotation = [SCIImageAnnotation new];
        
        SCIImage *image = [SCIImage imageNamed:@"image.background.moving"];
        if (image) {
            self.imageAnnotation.image = image;
        }
        
        self.imageAnnotation.annotationType = SCIAnnotationType_Background;
        self.imageAnnotation.alpha = 0.4;
        self.imageAnnotation.annotationSurface = SCIAnnotationSurface_AboveGrid;
        self.imageAnnotation.contentMode = self.imageAnnotationContentMode;
        
        [arrAnno addObject:titleAnnotation];
        [arrAnno addObject:descriptionAnnotation];
        [arrAnno addObject:self.imageAnnotation];
        
        self.surface.annotations = [[SCIAnnotationCollection alloc] initWithCollection:arrAnno];
        [self.surface.chartModifiers add:[SCDExampleBaseViewController createDefaultModifiers]];
    }];
}

- (SCIFastColumnRenderableSeries *)getRenderableSeriesWithDataSeries:(SCIXyDataSeries *)dataSeries color:(uint)color {
    SCIFastColumnRenderableSeries *rSeries = [SCIFastColumnRenderableSeries new];
    rSeries.dataSeries = dataSeries;
    rSeries.fillBrushStyle = [[SCISolidBrushStyle alloc] initWithColorCode:color];
    rSeries.strokeStyle = [[SCISolidPenStyle alloc] initWithColor:SCIColor.blackColor thickness:0.5];
    
    return rSeries;
}



@end
