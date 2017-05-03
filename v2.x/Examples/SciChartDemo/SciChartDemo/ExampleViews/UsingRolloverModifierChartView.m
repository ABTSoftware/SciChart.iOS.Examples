//
//  UsingRolloverModifierChartView.m
//  SciChartDemo
//
//  Created by Yaroslav Pelyukh on 7/23/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

#import "UsingRolloverModifierChartView.h"
#import "InterpolationTurnOnOff.h"

@implementation UsingRolloverModifierChartView

@synthesize sciChartSurfaceView;
@synthesize surface;

-(void) addRolloverModifierModifiers{
    
    SCIPinchZoomModifier * pzm = [[SCIPinchZoomModifier alloc] init];
    [pzm setModifierName:@"PinchZoom Modifier"];
    
    SCIZoomExtentsModifier * zem = [[SCIZoomExtentsModifier alloc] init];
    [zem setModifierName:@"ZoomExtents Modifier"];
    
    SCIRolloverModifier * rollover = [[SCIRolloverModifier alloc] init];
    rollover.style.tooltipSize = CGSizeMake(200, NAN);
    [rollover setModifierName:@"Rollover Modifier"];
    
    SCIModifierGroup * gm = [[SCIModifierGroup alloc] initWithChildModifiers:@[ pzm, zem, rollover]];
    surface.chartModifier = gm;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        SCIChartSurfaceView * view = [[SCIChartSurfaceView alloc]initWithFrame:frame];
        sciChartSurfaceView = view;
        
        [sciChartSurfaceView setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [self addSubview:sciChartSurfaceView];
        
        __weak typeof(self) wSelf = self;
        
        InterpolationTurnOnOff * panel = (InterpolationTurnOnOff*)[[[NSBundle mainBundle] loadNibNamed:@"InterpolationTurnOnOff" owner:self options:nil] firstObject];
        
        panel.onUseInterpolationClicked = ^() { [wSelf turnOnOffInterpolation]; };
        
        [self addSubview:panel];
        [self addSubview:sciChartSurfaceView];
        
        panel.translatesAutoresizingMaskIntoConstraints = NO;
        
        NSDictionary *layout = @{@"SciChart":sciChartSurfaceView, @"Panel":panel};
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[Panel(63)]-(0)-[SciChart]-(0)-|"
                                                                     options:0 metrics:0 views:layout]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[SciChart]-(0)-|"
                                                                     options:0 metrics:0 views:layout]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[Panel]-(0)-|"
                                                                     options:0 metrics:0 views:layout]];
        
        [self initializeSurfaceData];
    }
    
    return self;
}

-(void) turnOnOffInterpolation{
    for (int i = 0; i < [[surface renderableSeries] count]; i++) {
        id<SCIRenderableSeriesProtocol> series = [[surface renderableSeries] itemAt:i];
        [[series hitTestProvider] setHitTestMode:[[series hitTestProvider] hitTestMode] == SCIHitTest_Vertical ? SCIHitTest_VerticalInterpolate : SCIHitTest_Vertical];
    }
}

-(void) initializeSurfaceData {
    surface = [[SCIChartSurface alloc] initWithView: sciChartSurfaceView];
    
    [[surface style] setBackgroundBrush: [[SCISolidBrushStyle alloc] initWithColorCode:0xFF1c1c1e]];
    [[surface style] setSeriesBackgroundBrush:[[SCISolidBrushStyle alloc] initWithColorCode:0xFF1c1c1e]];
    [self addAxes];
    [self addRolloverModifierModifiers];
    [self initializeSurfaceRenderableSeries];
}

-(void) addAxes{
    SCISolidPenStyle * majorPen = [[SCISolidPenStyle alloc] initWithColorCode:0xFF323539 withThickness:0.5];
    SCISolidBrushStyle * gridBandPen = [[SCISolidBrushStyle alloc] initWithColorCode:0xE1202123];
    SCISolidPenStyle * minorPen = [[SCISolidPenStyle alloc] initWithColorCode:0xFF232426 withThickness:0.5];
    
    SCITextFormattingStyle *  textFormatting= [[SCITextFormattingStyle alloc] init];
    [textFormatting setFontSize:16];
    [textFormatting setFontName:@"Helvetica"];
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
    [axis setGrowBy: [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)]];
    [surface.yAxes add:axis];
    
    axis = [[SCINumericAxis alloc] init];
    axis.axisId = @"xAxis";
    [axis setStyle: axisStyle];
    [axis setGrowBy: [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)]];
    [surface.xAxes add:axis];
}

-(void) initializeSurfaceRenderableSeries{
   
    SCIEllipsePointMarker * ellipsePointMarker = [[SCIEllipsePointMarker alloc]init];
    [ellipsePointMarker setFillStyle:[[SCISolidBrushStyle alloc] initWithColorCode:0xFFd7ffd6]];
    [ellipsePointMarker setHeight:5];
    [ellipsePointMarker setWidth:5];
    
    [surface.renderableSeries add: [self getFastLineRenderableSeries: ellipsePointMarker :1.0 :0xFFa1b9d7]];
    [surface.renderableSeries add: [self getFastLineRenderableSeries: ellipsePointMarker :0.5 :0xFF0b5400]];
    [surface.renderableSeries add: [self getFastLineRenderableSeries: nil :0 :0xFF386ea6]];
    
    [surface invalidateElement];
}

-(SCIFastLineRenderableSeries *) getFastLineRenderableSeries: (SCIEllipsePointMarker *) pointMarker :(double) amplitude :(uint) colorCode{
    
    SCIXyDataSeries * fourierDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Float YType:SCIDataType_Float SeriesType:SCITypeOfDataSeries_DefaultType];
    
    double count = 100.0;
    double k = 2 * M_PI / 30.0;
    for (int i = 0; i < (int) count; i++) {
        double phi = k * i;
        [fourierDataSeries appendX:SCIGeneric(i) Y:SCIGeneric((amplitude + i / count) * sin(phi))];
    }
    
    fourierDataSeries.dataDistributionCalculator = [SCIUserDefinedDistributionCalculator new];
    
    SCIFastLineRenderableSeries * fourierRenderableSeries = [SCIFastLineRenderableSeries new];
    fourierRenderableSeries.style.linePen = [[SCISolidPenStyle alloc] initWithColorCode:colorCode withThickness:1.0];
    fourierRenderableSeries.xAxisId = @"xAxis";
    fourierRenderableSeries.yAxisId = @"yAxis";
    [fourierRenderableSeries setDataSeries:fourierDataSeries];
    
    [[fourierRenderableSeries hitTestProvider] setHitTestMode: SCIHitTest_VerticalInterpolate];
    
    if(pointMarker){
        [fourierRenderableSeries.style setDrawPointMarkers:true];
        [fourierRenderableSeries.style setPointMarker:pointMarker];
    }
    
    return fourierRenderableSeries;
}

@end
