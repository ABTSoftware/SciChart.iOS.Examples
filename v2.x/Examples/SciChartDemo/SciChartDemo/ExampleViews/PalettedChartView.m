//
//  PalettedChartView.m
//  SciChartDemo
//
//  Created by Admin on 21.08.16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

#import "PalettedChartView.h"
#import <SciChart/SciChart.h>

@interface LineMinMaxPalette : SCIPaletteProvider

@end

@implementation LineMinMaxPalette {
    SCILineSeriesStyle * _styleMin;
    SCILineSeriesStyle * _styleMax;
    int _minIndex;
    int _maxIndex;
}

-(instancetype)init {
    self = [super init];
    if (self) {
        _styleMin = [SCILineSeriesStyle new];
        _styleMin.drawPointMarkers = YES;
        SCIEllipsePointMarker * minMarker = [[SCIEllipsePointMarker alloc] init];
        minMarker.fillBrush = [[SCISolidBrushStyle alloc] initWithColor:[UIColor cyanColor]];
        _styleMin.pointMarker = minMarker;
        _styleMin.linePen = [[SCISolidPenStyle alloc] initWithColorCode:0xFF99EE99 withThickness:0.7];
        
        _styleMax = [SCILineSeriesStyle new];
        _styleMax.drawPointMarkers = YES;
        SCIEllipsePointMarker * maxMarker = [[SCIEllipsePointMarker alloc] init];
        maxMarker.fillBrush = [[SCISolidBrushStyle alloc] initWithColor:[UIColor redColor]];
        _styleMax.pointMarker = maxMarker;
        _styleMax.linePen = [[SCISolidPenStyle alloc] initWithColorCode:0xFF99EE99 withThickness:0.7];
    }
    return self;
}

-(void)updateData:(id<SCIRenderPassDataProtocol>)data {
    int minIndex = 0;
    double minValue = DBL_MAX;
    int maxIndex = 0;
    double maxValue = -DBL_MAX;
    id<SCIPointSeriesProtocol> points = [data pointSeries];
    int count = [points count];
    for (int i = 0; i < count; i++) {
        double value = SCIGenericDouble([[points yValues] valueAt:i]);
        if (value < minValue) {
            minValue = value;
            minIndex = SCIGenericInt([[points indices] valueAt:i]);
        }
        if (value > maxValue) {
            maxValue = value;
            maxIndex = SCIGenericInt([[points indices] valueAt:i]);
        }
    }
    _minIndex = minIndex;
    _maxIndex = maxIndex;
}

-(id<SCIStyleProtocol>)styleForX:(double)x Y:(double)y Index:(int)index {
    if (index == _minIndex) {
        return _styleMin;
    } else if (index == _maxIndex) {
        return _styleMax;
    } else {
        return nil;
    }
}

@end

@interface ZeroLinePalette : SCIPaletteProvider

@end

@implementation ZeroLinePalette {
    SCILineSeriesStyle * _style;
    double _zeroLine;
    id<SCICoordinateCalculatorProtocol> _yCoordCalc;
}


-(instancetype)init {
    self = [super init];
    if (self) {
        _zeroLine = 10;
        
        _style = [SCILineSeriesStyle new];
        _style.drawPointMarkers = NO;
        _style.linePen = [[SCISolidPenStyle alloc] initWithColor:[UIColor blueColor] withThickness:0.7];
    }
    return self;
}

-(void)updateData:(id<SCIRenderPassDataProtocol>)data {
    _yCoordCalc = [data yCoordinateCalculator];
}

-(id<SCIStyleProtocol>)styleForX:(double)x Y:(double)y Index:(int)index {
    double value = [_yCoordCalc getDataValueFrom:y];
    if (value < _zeroLine) return _style;
    else return nil;
}

@end


@implementation PalettedChartView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        SCIChartSurfaceView * view = [[SCIChartSurfaceView alloc]init];
        _sciChartSurfaceView = view;
        
        [_sciChartSurfaceView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:_sciChartSurfaceView];
        
        NSDictionary *layout = @{@"SciChart":_sciChartSurfaceView};
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[SciChart]-(0)-|" options:0 metrics:0 views:layout]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[SciChart]-(0)-|" options:0 metrics:0 views:layout]];
        [self initializeSurfaceData];
    }
    
    return self;
}

-(void) initializeSurfaceData {
    _surface = [[SCIChartSurface alloc] initWithView: _sciChartSurfaceView];
    
    [[_surface style] setBackgroundBrush: [[SCISolidBrushStyle alloc] initWithColorCode:0xFF1c1c1e]];
    [[_surface style] setSeriesBackgroundBrush:[[SCISolidBrushStyle alloc] initWithColorCode:0xFF1c1c1e]];
    
    SCISolidPenStyle  *majorPen = [[SCISolidPenStyle alloc] initWithColorCode:0xFF323539 withThickness:0.6];
    SCISolidBrushStyle  *gridBandPen = [[SCISolidBrushStyle alloc] initWithColorCode:0xE1202123];
    SCISolidPenStyle  *minorPen = [[SCISolidPenStyle alloc] initWithColorCode:0xFF232426 withThickness:0.5];
    
    SCITextFormattingStyle *  textFormatting= [[SCITextFormattingStyle alloc] init];
    [textFormatting setFontSize:16];
    [textFormatting setFontName:@"Arial"];
    [textFormatting setColorCode:0xFFb6b3af];
    
    SCIAxisStyle * axisStyle = [[SCIAxisStyle alloc]init];
    [axisStyle setMajorTickBrush:majorPen];
    [axisStyle setGridBandBrush: gridBandPen];
    [axisStyle setMajorGridLineBrush:majorPen];
    [axisStyle setMinorTickBrush:minorPen];
    [axisStyle setMinorGridLineBrush:minorPen];
    [axisStyle setLabelStyle:textFormatting ];
    [axisStyle setDrawMinorGridLines:YES];
    [axisStyle setDrawMajorBands:YES];
    
    id<SCIAxis2DProtocol> axis = [[SCINumericAxis alloc] init];
    [axis setStyle: axisStyle];
    axis.axisId = @"yAxis";
    [axis setGrowBy: [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.05) Max:SCIGeneric(0.05)]];
    [_surface.yAxes add:axis];
    
    axis = [[SCINumericAxis alloc] init];
    axis.axisId = @"xAxis";
    [axis setStyle: axisStyle];
    [axis setGrowBy: [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.05) Max:SCIGeneric(0.05)]];
    [_surface.xAxes add:axis];
    
    SCIXAxisDragModifier * xDragModifier = [SCIXAxisDragModifier new];
    xDragModifier.axisId = @"xAxis";
    xDragModifier.dragMode = SCIAxisDragMode_Scale;
    xDragModifier.clipModeX = SCIZoomPanClipMode_None;
    
    SCIYAxisDragModifier * yDragModifier = [SCIYAxisDragModifier new];
    yDragModifier.axisId = @"yAxis";
    yDragModifier.dragMode = SCIAxisDragMode_Pan;
    
    SCIPinchZoomModifier * pzm = [[SCIPinchZoomModifier alloc] init];
    SCIZoomExtentsModifier * zem = [[SCIZoomExtentsModifier alloc] init];
    
    SCIZoomPanModifier * zpm = [[SCIZoomPanModifier alloc] init];
    
    [zpm setModifierName:@"ZoomPan Modifier"];
    [zem setModifierName:@"ZoomExtents Modifier"];
    [pzm setModifierName:@"PinchZoom Modifier"];
    [yDragModifier setModifierName:@"YAxis Drag Modifier"];
    [xDragModifier setModifierName:@"XAxis Drag Modifier"];
    
    SCIModifierGroup * gm = [[SCIModifierGroup alloc] initWithChildModifiers:@[xDragModifier, yDragModifier, pzm, zem, zpm]];
    _surface.chartModifier = gm;
    
    [self initializeSurfaceRenderableSeries];
    
    [_surface invalidateElement];
}

-(void) initializeSurfaceRenderableSeries {
    int dataCount = 20;
    SCIXyDataSeries * priceDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Float YType:SCIDataType_Float SeriesType:SCITypeOfDataSeries_DefaultType];
    //Getting Fourier dataSeries
    for (int i = 0; i < dataCount; i++) {
        double time = 10 * i / (double)dataCount;
        double x = time;
        double y = arc4random_uniform(20);
        [priceDataSeries appendX:SCIGeneric(x) Y:SCIGeneric(y)];
    }
    
    dataCount = 1000;
    SCIXyDataSeries * fourierDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Float YType:SCIDataType_Float SeriesType:SCITypeOfDataSeries_DefaultType];
    
    //Getting Fourier dataSeries
    for (int i = 0; i < dataCount; i++) {
        double time = 10 * i / (double)dataCount;
        double x = time;
        double y = 2 * sin(x)+10;
        [fourierDataSeries appendX:SCIGeneric(x) Y:SCIGeneric(y)];
    };
    
    priceDataSeries.dataDistributionCalculator = [SCIUserDefinedDistributionCalculator new];
    fourierDataSeries.dataDistributionCalculator = [SCIUserDefinedDistributionCalculator new];
    
    SCIEllipsePointMarker * ellipsePointMarker = [[SCIEllipsePointMarker alloc]init];
    [ellipsePointMarker setDrawBorder:YES];
    [ellipsePointMarker setFillBrush:[[SCISolidBrushStyle alloc] initWithColorCode:0xFFd7ffd6]];
    [ellipsePointMarker setHeight:5];
    [ellipsePointMarker setWidth:5];
    
    SCIFastLineRenderableSeries * priceRenderableSeries = [SCIFastLineRenderableSeries new];
    [priceRenderableSeries.style setPointMarker: ellipsePointMarker];
    [priceRenderableSeries.style setDrawPointMarkers: YES];
    [priceRenderableSeries.style setLinePen: [[SCISolidPenStyle alloc] initWithColorCode:0xFF99EE99 withThickness:0.7]];
    [priceRenderableSeries setXAxisId: @"xAxis"];
    [priceRenderableSeries setYAxisId: @"yAxis"];
    [priceRenderableSeries setDataSeries:priceDataSeries];
    [_surface.renderableSeries add:priceRenderableSeries];
    
    SCIFastLineRenderableSeries * fourierRenderableSeries = [SCIFastLineRenderableSeries new];
    fourierRenderableSeries.style.linePen = [[SCISolidPenStyle alloc] initWithColorCode:0xFFff8a4c withThickness:0.7];
    fourierRenderableSeries.xAxisId = @"xAxis";
    fourierRenderableSeries.yAxisId = @"yAxis";
    [fourierRenderableSeries setDataSeries:fourierDataSeries];
    [_surface.renderableSeries add:fourierRenderableSeries];
    
    priceRenderableSeries.paletteProvider = [LineMinMaxPalette new];
    fourierRenderableSeries.paletteProvider = [ZeroLinePalette new];
    [_surface invalidateElement];
}

@end
