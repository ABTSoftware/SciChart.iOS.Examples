//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// UsingPointMarkersChartView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "UsingPointMarkersChartView.h"
#import "SCDDataManager.h"

#pragma mark - Custom Point Marker

@interface SCICustomPointMarkerDrawer: NSObject<ISCISpritePointMarkerDrawer>
- (nonnull instancetype)initWithImage:(SCIImage *)image;
@end

@implementation SCICustomPointMarkerDrawer {
    SCIImage *_image;
}

- (instancetype)initWithImage:(SCIImage *)image {
    self = [super init];
    if (self) {
        _image = image;
    }
    return self;
}

- (void)onDrawBitmap:(SCIBitmap *)bitmap withPenStyle:(SCIPenStyle *)penStyle andBrushStyle:(SCIBrushStyle *)brushStyle {
    CGContextSaveGState(bitmap.context);
    CGRect rect = CGRectMake(0, 0, bitmap.width, bitmap.height);
    CGContextTranslateCTM(bitmap.context, 0.0, bitmap.height); // bitmap.context.height
    CGContextScaleCTM(bitmap.context, 1.0, -1.0);
    CGContextDrawImage(bitmap.context, rect, _image.CGImage);
    CGContextRestoreGState(bitmap.context);
}

@end

#pragma mark - Chart Initialization

@implementation UsingPointMarkersChartView

- (Class)associatedType { return SCIChartSurface.class; }

- (void)initExample {
    id<ISCIAxis> xAxis = [SCINumericAxis new];
    xAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.1 max:0.1];
    
    id<ISCIAxis> yAxis = [SCINumericAxis new];
    yAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.1 max:0.1];
    
    SCIXyDataSeries *ds1 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double];
    SCIXyDataSeries *ds2 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double];
    SCIXyDataSeries *ds3 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double];
    SCIXyDataSeries *ds4 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double];
    SCIXyDataSeries *ds5 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double];
    
    int dataSize = 15;
    for(int i=0; i < dataSize; i++){
        [ds1 appendX:@(i) y:@(randf(0.0, 1.0))];
        [ds2 appendX:@(i) y:@(1 + randf(0.0, 1.0))];
        [ds3 appendX:@(i) y:@(2.5 + randf(0.0, 1.0))];
        [ds4 appendX:@(i) y:@(4 + randf(0.0, 1.0))];
        [ds5 appendX:@(i) y:@(5.5 + randf(0.0, 1.0))];
    }
    
    [ds1 updateY:@(NAN) at:7];
    [ds2 updateY:@(NAN) at:7];
    [ds3 updateY:@(NAN) at:7];
    [ds4 updateY:@(NAN) at:7];
    [ds5 updateY:@(NAN) at:7];
    
    SCIEllipsePointMarker *pointMarker1 = [SCIEllipsePointMarker new];
    pointMarker1.size = CGSizeMake(15, 15);
    pointMarker1.fillStyle = [[SCISolidBrushStyle alloc] initWithColorCode:0x990077ff];
    pointMarker1.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFFADD8E6 thickness:2.0];
    
    SCISquarePointMarker *pointMarker2 = [SCISquarePointMarker new];
    pointMarker2.size = CGSizeMake(20, 20);
    pointMarker2.fillStyle = [[SCISolidBrushStyle alloc] initWithColorCode:0x99ff0000];
    pointMarker2.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFFFF0000 thickness:2.0];
    
    SCITrianglePointMarker *pointMarker3 = [SCITrianglePointMarker new];
    pointMarker3.size = CGSizeMake(20, 20);
    pointMarker3.fillStyle = [[SCISolidBrushStyle alloc] initWithColorCode:0xFFFFDD00];
    pointMarker3.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFFFF6600 thickness:2.0];
    
    SCICrossPointMarker *pointMarker4 = [SCICrossPointMarker new];
    pointMarker4.size = CGSizeMake(25, 25);
    pointMarker4.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFFFF00FF thickness:4.0];
    
    SCICustomPointMarkerDrawer *drawer = [[SCICustomPointMarkerDrawer alloc] initWithImage:[SCIImage imageNamed:@"image.weather.storm"]];
    SCISpritePointMarker *pointMarker5 = [[SCISpritePointMarker alloc] initWithDrawer:drawer];
    pointMarker5.size = CGSizeMake(40, 40);
    
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        [self.surface.xAxes add:xAxis];
        [self.surface.yAxes add:yAxis];
        [self.surface.renderableSeries add:[self getRenderableSeriesWithDataSeries:ds1 pointMarker:pointMarker1 color:0xFFADD8E6]];
        [self.surface.renderableSeries add:[self getRenderableSeriesWithDataSeries:ds2 pointMarker:pointMarker2 color:0xFFFF0000]];
        [self.surface.renderableSeries add:[self getRenderableSeriesWithDataSeries:ds3 pointMarker:pointMarker3 color:0xFFFFFF00]];
        [self.surface.renderableSeries add:[self getRenderableSeriesWithDataSeries:ds4 pointMarker:pointMarker4 color:0xFFFF00FF]];
        [self.surface.renderableSeries add:[self getRenderableSeriesWithDataSeries:ds5 pointMarker:pointMarker5 color:0xFFF5DEB3]];
        [self.surface.chartModifiers add:[SCDExampleBaseViewController createDefaultModifiers]];
    }];
}

- (SCIFastLineRenderableSeries *)getRenderableSeriesWithDataSeries:(SCIXyDataSeries *)dataSeries pointMarker:(id<ISCIPointMarker>)pointMarker color:(uint)color {
    SCIFastLineRenderableSeries *rSeries = [SCIFastLineRenderableSeries new];
    rSeries.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:color thickness:2.0];
    rSeries.pointMarker = pointMarker;
    rSeries.dataSeries = dataSeries;

    [SCIAnimations fadeSeries:rSeries duration:2.0 andEasingFunction:[SCICubicEase new]];
    
    return rSeries;
}

@end
