//
//  HeatmapChartViewController.m
//  SciChartDemo
//
//  Created by Admin on 16.02.16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

#import <SciChart/SciChart.h>
#import "HeatmapChartView.h"
#import "DataManager.h"

const int HEIGHT = 200;
const int WIDTH = 300;

@implementation HeatmapChartView {
    SCIUniformHeatmapDataSeries * heatmapDataSeries;
    int increment;
    NSTimer *timer;
    BOOL _running;
    SCIGenericType *data;
    SCITextureOpenGL *_colorMap;
    SCIChartHeatmapColourMap *_colorMapView;
    
}


@synthesize surface;

-(SCIFastUniformHeatmapRenderableSeries*) getHeatmapRenderableSeries{
    increment = 0;

    SCIArrayController2D* values = [[SCIArrayController2D alloc]initWithType:SCIDataType_Double SizeX:WIDTH  Y:HEIGHT];
    
    for (int i=0; i<WIDTH; i++) {
        for (int j=0; j<HEIGHT; j++) {
            [values setValue:SCIGeneric((double)i*j/10) AtX:i Y:j];
        }
    }
    
    heatmapDataSeries = [[SCIUniformHeatmapDataSeries alloc]initWithZValues:values
                                                                     StartX:SCIGeneric(0.0)
                                                                      StepX:SCIGeneric(1.0)
                                                                     StartY:SCIGeneric(0.0)
                                                                      StepY:SCIGeneric(1.0)];
    
    [heatmapDataSeries setSeriesName:@"Heatmap Series"];
    
    SCIFastUniformHeatmapRenderableSeries * heatmapRenderableSeries = [[SCIFastUniformHeatmapRenderableSeries alloc] init];
    [heatmapRenderableSeries setMinimum:0];
    [heatmapRenderableSeries setMaximum:200];
    
    float *gradientCoord = malloc(sizeof(float)*6);
    gradientCoord[0] = 0.f;
    gradientCoord[1] = 0.2f;
    gradientCoord[2] = 0.4f;
    gradientCoord[3] = 0.6f;
    gradientCoord[4] = 0.8f;
    gradientCoord[5] = 1.f;
    
    uint *gradientColor = malloc(sizeof(uint)*6);
    gradientColor[0] = 0xFF00008B;
    gradientColor[1] = 0xFF6495ED;
    gradientColor[2] = 0xFF006400;
    gradientColor[3] = 0xFF7FFF00;
    gradientColor[4] = 0xFFFFFF00;
    gradientColor[5] = 0xFFFF0000;
    
    _colorMap = [[SCITextureOpenGL alloc] initWithGradientCoords:gradientCoord Colors:gradientColor Count:6];
    
    [heatmapRenderableSeries setColorMap:_colorMap];
    heatmapRenderableSeries.xAxisId = @"xAxis";
    heatmapRenderableSeries.yAxisId = @"yAxis";
    
    [heatmapRenderableSeries setDataSeries:heatmapDataSeries];
    return heatmapRenderableSeries;
}

-(void)createData {
    
    data = malloc(sizeof(SCIGenericType)*60);
    
    double seriesPerPeriod = 30.0;
    
    for (int i = 0; i < seriesPerPeriod ; i++) {
    
        double angle = M_PI*2.0*i/seriesPerPeriod;
        
        double *zValues = malloc(sizeof(double)*WIDTH*HEIGHT);
        
        double cx = 150, cy = 100;
        
        for (int x = 0; x < WIDTH; x++) {
            for (int y = 0; y < HEIGHT; y++) {
                double v = (1 + sin(x * 0.04 + angle)) * 50 + (1 + sin(y * 0.1 + angle)) * 50 * (1 + sin(angle * 2));
                double r = sqrt((x-cx)*(x-cx) + (y-cy)*(y-cy));
                double exp = MAX(0, 1 - r * 0.008);
                double d = (v * exp + arc4random_uniform(50));
                
                zValues[x*HEIGHT + y] = d;
                
            }
        }
        
        data[i] = SCIGeneric(zValues);
    }

    [heatmapDataSeries updateZValues:data[0] Size:WIDTH*HEIGHT];
        
}

-(void)updateHeatmapData:(NSTimer *)timer{
    
    
    if (increment > 29) {
        increment = 0;
    }
    
    [heatmapDataSeries updateZValues:data[increment] Size:WIDTH*HEIGHT];
    
    [surface invalidateElement];
    increment++;
    
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        SCIChartSurface * view = [[SCIChartSurface alloc]init];
        surface = view;
        
        _colorMapView = [[SCIChartHeatmapColourMap alloc] init];
        _colorMapView.minimum = 0.0f;
        _colorMapView.maximum = 200.0f;
        
        [surface setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [self addSubview:surface];
        [surface addSubview:_colorMapView];
        
        NSDictionary *layout = @{@"SciChart"    :   surface,
                                 @"colorMapView":   _colorMapView};
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[SciChart]-(0)-|" options:0 metrics:0 views:layout]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[SciChart]-(0)-|" options:0 metrics:0 views:layout]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(8)-[colorMapView]-(>=8)-|" options:0 metrics:0 views:layout]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(8)-[colorMapView]-(40)-|" options:0 metrics:0 views:layout]];
        
        [self initializeSurfaceData];
        
    }
    
    return self;
}

-(void) initializeSurfaceData {
    
    
    surface.leftAxisAreaSize = 0.0;
    surface.topAxisAreaSize = 0.0;
    
    self.surface.backgroundColor = [UIColor fromARGBColorCode:0xFF1c1c1e];
    self.surface.renderableSeriesAreaFill = [[SCISolidBrushStyle alloc] initWithColorCode:0xFF1c1c1e];
    
    SCISolidPenStyle  *majorPen = [[SCISolidPenStyle alloc] initWithColorCode:0xFF323539 withThickness:0.6];
    SCISolidBrushStyle  *gridBandPen = [[SCISolidBrushStyle alloc] initWithColorCode:0xE1202123];
    SCISolidPenStyle  *minorPen = [[SCISolidPenStyle alloc] initWithColorCode:0xFF232426 withThickness:0.5];
    
    SCITextFormattingStyle *  textFormatting= [[SCITextFormattingStyle alloc] init];
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
    [axis setGrowBy: [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.0) Max:SCIGeneric(0.0)]];
    [surface.yAxes add:axis];
    
    axis = [[SCINumericAxis alloc] init];
    axis.axisId = @"xAxis";
    [axis setStyle: axisStyle];
    [axis setGrowBy: [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.0) Max:SCIGeneric(0.0)]];
    [surface.xAxes add:axis];
    
    SCIXAxisDragModifier * xDragModifier = [SCIXAxisDragModifier new];
    xDragModifier.axisId = @"xAxis";
    xDragModifier.dragMode = SCIAxisDragMode_Scale;
    xDragModifier.clipModeX = SCIClipMode_None;
    
    SCIYAxisDragModifier * yDragModifier = [SCIYAxisDragModifier new];
    yDragModifier.axisId = @"yAxis";
    yDragModifier.dragMode = SCIAxisDragMode_Pan;
    
    SCIPinchZoomModifier * pzm = [[SCIPinchZoomModifier alloc] init];
    SCIZoomExtentsModifier * zem = [[SCIZoomExtentsModifier alloc] init];
    SCITooltipModifier * tooltip = [[SCITooltipModifier alloc] init];
    
    [tooltip setModifierName:@"ToolTip Modifier"];
    [zem setModifierName:@"ZoomExtents Modifier"];
    [pzm setModifierName:@"PinchZoom Modifier"];
    [yDragModifier setModifierName:@"YAxis Drag Modifier"];
    [xDragModifier setModifierName:@"XAxis Drag Modifier"];
    
    SCIChartModifierCollection * gm = [[SCIChartModifierCollection alloc] initWithChildModifiers:@[xDragModifier, yDragModifier, pzm, zem, tooltip]];
    surface.chartModifiers = gm;
    
    [surface.renderableSeries add:[self getHeatmapRenderableSeries]];
    
    [surface invalidateElement];
    
    [self createData];
    
    [_colorMapView setColourMap:_colorMap];
}

- (void)willMoveToWindow:(UIWindow *)newWindow{
    [super willMoveToWindow: newWindow];
    if(timer == nil) {
        timer = [NSTimer scheduledTimerWithTimeInterval:0.04
                                                 target:self
                                               selector:@selector(updateHeatmapData:)
                                               userInfo:nil
                                                repeats:YES];
    } else {
        [timer invalidate];
        timer = nil;
    }
}

@end
