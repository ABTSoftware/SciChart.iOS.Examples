//
//  InteractionWithAnnotations.m
//  SciChartDemo
//
//  Created by Yaroslav Pelyukh on 5/2/17.
//  Copyright © 2017 ABT. All rights reserved.
//

#import "InteractionWithAnnotations.h"
#import "DataManager.h"

@implementation InteractionWithAnnotations

@synthesize sciChartSurfaceView;
@synthesize surface;

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        SCIChartSurfaceView * view = [[SCIChartSurfaceView alloc]init];
        sciChartSurfaceView = view;
        
        [sciChartSurfaceView setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [self addSubview:sciChartSurfaceView];
        NSDictionary *layout = @{@"SciChart":sciChartSurfaceView};
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[SciChart]-(0)-|" options:0 metrics:0 views:layout]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[SciChart]-(0)-|" options:0 metrics:0 views:layout]];
        
        [self initializeSurfaceData];
    }
    
    return self;
}

-(void) initializeSurfaceData{
    [surface free];
    surface = [[SCIChartSurface alloc] initWithView: sciChartSurfaceView];
    
    SCINumericAxis *yAxis = [SCINumericAxis new];
    [yAxis setGrowBy: [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)]];
    [yAxis setVisibleRange: [[SCIDoubleRange alloc]initWithMin:SCIGeneric(30.0) Max:SCIGeneric(37.0)]];
    [surface.yAxes add:yAxis];
    
    SCICategoryDateTimeAxis *xAxis = [SCICategoryDateTimeAxis new];
    [surface.xAxes add:xAxis];
    
    SCIPinchZoomModifier *pzm = [SCIPinchZoomModifier new];
    SCIZoomExtentsModifier *zem = [SCIZoomExtentsModifier new];
    SCIZoomPanModifier *zpm = [SCIZoomPanModifier new];
    zpm.clipModeX = SCIZoomPanClipMode_None;
    
    SCIModifierGroup *gm = [[SCIModifierGroup alloc] initWithChildModifiers:@[pzm, zem, zpm]];
    [surface setChartModifier: gm];
    
    [self addRenderSeries];
    [self setupAnnotations];
}

-(void) addRenderSeries{
    SCIOhlcDataSeries * dataSeries = [[SCIOhlcDataSeries alloc]initWithXType:SCIDataType_DateTime YType:SCIDataType_Float SeriesType:SCITypeOfDataSeries_XCategory];
    
    MarketDataService * marketDataService = [[MarketDataService alloc]initWithStartDate:[NSDate date] TimeFrameMinutes:5 TickTimerIntervals:5];
    NSMutableArray * data = [marketDataService getHistoricalData:200];
    
    for (SCDMultiPaneItem * item in data) {
        [dataSeries appendX: SCIGeneric([item dateTime]) Open:SCIGeneric([item open]) High:SCIGeneric([item high]) Low:SCIGeneric([item low]) Close:SCIGeneric([item close])];
    }
    
    SCIFastCandlestickRenderableSeries * candleRenderSeries = [SCIFastCandlestickRenderableSeries new];
    candleRenderSeries.dataSeries = dataSeries;
    
    [surface.renderableSeries add:candleRenderSeries];
}

-(void) setupAnnotations {
    
    SCIAnnotationCollection *annotationCollection = [SCIAnnotationCollection new];
    
    SCITextFormattingStyle *textStyle = [SCITextFormattingStyle new];
    [textStyle setFontSize:20];
    [self buildTextAnnotation:annotationCollection
                             :10 :30.5
                             :SCIHorizontalAnchorPoint_Left
                             :SCIVerticalAnchorPoint_Bottom
                             :textStyle
                             :SCIAnnotationCoordinate_Absolute
                             :@"Buy!" :0xFFFFFFFF];
    
    [self buildTextAnnotation:annotationCollection
                             :50 :34
                             :SCIHorizontalAnchorPoint_Left
                             :SCIVerticalAnchorPoint_Top
                             :textStyle
                             :SCIAnnotationCoordinate_Absolute
                             :@"Sell!" :0xFFFFFFFF];
    
    [self buildTextAnnotation:annotationCollection
                             :80 :37
                             :SCIHorizontalAnchorPoint_Left
                             :SCIVerticalAnchorPoint_Top
                             :textStyle
                             :SCIAnnotationCoordinate_Absolute
                             :@"Rotated Text" :0xFFFFFFFF];
    
    [self buildBoxAnnotation:annotationCollection
                            :50 :35.5 :120 :32
                            :[[SCISolidBrushStyle alloc]initWithColor:[UIColor fromARGBColorCode:0x33FF6600]]
                            :[[SCISolidPenStyle alloc]initWithColorCode:0x77FF6600 withThickness:1.0] ];
    
    [self buildLineAnnotation:annotationCollection
                             :40 :30.5
                             :60 :33.5
                             :0xAAFF6600 :2.0];
    
    [self buildLineAnnotation:annotationCollection
                             :120 :30.5
                             :175 :36
                             :0xAAFF6600 :2.0];
    
    [self buildLineAnnotation:annotationCollection
                             :50 :35
                             :80 :31.4
                             :0xAAFF6600 :2.0];
    
    [self buildAxisMarkerAnnotation:annotationCollection :[surface.yAxes itemAt:0].axisId :NO :32.7];
    
    [self buildAxisMarkerAnnotation:annotationCollection :[surface.xAxes itemAt:0].axisId :YES :100];
    
    SCIHorizontalLineAnnotation * horizontalLine = [[SCIHorizontalLineAnnotation alloc] init];
    horizontalLine.coordinateMode = SCIAnnotationCoordinate_Absolute;
    horizontalLine.x1 = SCIGeneric(150);
    horizontalLine.y1 = SCIGeneric(32.2);
    horizontalLine.style.horizontalAlignment = SCIHorizontalLineAnnotationAlignment_Right;
    horizontalLine.style.linePen = [[SCISolidPenStyle alloc] initWithColor: [UIColor redColor] withThickness:2];
    [annotationCollection addItem:horizontalLine];
    
    SCIHorizontalLineAnnotation * horizontalLine1 = [[SCIHorizontalLineAnnotation alloc] init];
    horizontalLine1.coordinateMode = SCIAnnotationCoordinate_Absolute;
    horizontalLine1.x1 = SCIGeneric(130);
    horizontalLine1.y1 = SCIGeneric(32.2);
    horizontalLine1.style.horizontalAlignment = SCIHorizontalLineAnnotationAlignment_Right;
    horizontalLine1.style.linePen = [[SCISolidPenStyle alloc] initWithColor: [UIColor blueColor] withThickness:2];
    [annotationCollection addItem:horizontalLine1];
    
    SCIVerticalLineAnnotation * veticalLine = [[SCIVerticalLineAnnotation alloc] init];
    veticalLine.coordinateMode = SCIAnnotationCoordinate_Absolute;
    veticalLine.x1 = SCIGeneric(20);
    veticalLine.y1 = SCIGeneric(35);
    veticalLine.style.linePen = [[SCISolidPenStyle alloc] initWithColorCode: 0xFF006400 withThickness:2];
    [annotationCollection addItem:veticalLine];
    
    SCIVerticalLineAnnotation * veticalLine1 = [[SCIVerticalLineAnnotation alloc] init];
    veticalLine1.coordinateMode = SCIAnnotationCoordinate_Absolute;
    veticalLine1.x1 = SCIGeneric(40);
    veticalLine1.y1 = SCIGeneric(34);
    veticalLine1.style.verticalAlignment = SCIVerticalAnchorPoint_Top;
    veticalLine1.style.linePen = [[SCISolidPenStyle alloc] initWithColor: [UIColor greenColor] withThickness:2];
    [annotationCollection addItem:veticalLine1];
    
    textStyle = [SCITextFormattingStyle new];
    [textStyle setFontSize:72];
    [self buildTextAnnotation:annotationCollection
                             :0.5 :0.5
                             :SCIHorizontalAnchorPoint_Left
                             :SCIVerticalAnchorPoint_Top
                             :textStyle
                             :SCIAnnotationCoordinate_Relative
                             :@"EUR/USD" :0x77FFFFFF];
    
    [surface setAnnotation: annotationCollection];
}

-(void)buildTextAnnotation:(SCIAnnotationCollection*)annotationCollection
                          :(double)x :(double)y
                          :(SCIHorizontalAnchorPoint)horizontalAnchorPoint
                          :(SCIVerticalAnchorPoint)verticalAnchorPoint
                          :(SCITextFormattingStyle*)textStyle
                          :(SCIAnnotationCoordinateMode)coordMode
                          :(NSString*)text :(uint)color{
    
    SCITextAnnotation * textAnnotation = [[SCITextAnnotation alloc] init];
    textAnnotation.coordinateMode = coordMode;
    textAnnotation.x1 = SCIGeneric(x);
    textAnnotation.y1 = SCIGeneric(y);
    textAnnotation.horizontalAnchorPoint = horizontalAnchorPoint;
    textAnnotation.verticalAnchorPoint = verticalAnchorPoint;
    textAnnotation.text = text;
    textAnnotation.style.textStyle = textStyle;
    textAnnotation.style.textColor = [UIColor fromARGBColorCode:color];
    textAnnotation.style.backgroundColor = [UIColor clearColor];
    
    [annotationCollection addItem:textAnnotation];
}

-(void)buildLineAnnotation:(SCIAnnotationCollection*)annotationCollection
                          :(double)x1 :(double)y1
                          :(double)x2 :(double)y2
                          :(uint)color :(double)strokeThickness{
    
    SCILineAnnotation * lineAnnotationRelative = [SCILineAnnotation new];
    lineAnnotationRelative.coordinateMode = SCIAnnotationCoordinate_Absolute;
    lineAnnotationRelative.x1 = SCIGeneric(x1);
    lineAnnotationRelative.y1 = SCIGeneric(y1);
    lineAnnotationRelative.x2 = SCIGeneric(x2);
    lineAnnotationRelative.y2 = SCIGeneric(y2);
    lineAnnotationRelative.style.linePen = [[SCISolidPenStyle alloc] initWithColorCode:color withThickness:strokeThickness];
    
    [annotationCollection addItem:lineAnnotationRelative];
}

-(void)buildBoxAnnotation:(SCIAnnotationCollection*)annotationCollection
                         :(double)x1 :(double)y1
                         :(double)x2 :(double)y2
                         :(SCIBrushStyle*)brush
                         :(SCISolidPenStyle*)pen{
    
    SCIBoxAnnotation * boxAnnotation = [[SCIBoxAnnotation alloc] init];
    boxAnnotation.coordinateMode = SCIAnnotationCoordinate_Absolute;
    boxAnnotation.x1 = SCIGeneric(x1);
    boxAnnotation.y1 = SCIGeneric(y1);
    boxAnnotation.x2 = SCIGeneric(x2);
    boxAnnotation.y2 = SCIGeneric(y2);
    boxAnnotation.style.fillBrush = brush;
    boxAnnotation.style.borderPen = pen;
    
    [annotationCollection addItem:boxAnnotation];
}

-(void)buildAxisMarkerAnnotation:(SCIAnnotationCollection*)annotationCollection
                                :(NSString*)id :(BOOL)isXAxis :(double)axisValue{
    SCIAxisMarkerAnnotation * axisMarker = [SCIAxisMarkerAnnotation new];
    axisMarker.coordinateMode = SCIAnnotationCoordinate_Absolute;
    axisMarker.position = SCIGeneric(axisValue);
    
    if(isXAxis){
        axisMarker.xAxisId = id;
    }else{
        axisMarker.yAxisId = id;
    }
    
    [annotationCollection addItem:axisMarker];
}

@end

