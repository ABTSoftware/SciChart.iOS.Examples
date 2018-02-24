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
const int SERIES_PER_PERIOD = 30;
const float TIME_INTERVAL = 0.04;

@implementation HeatmapChartView {
    SCIUniformHeatmapDataSeries * _dataSeries;
    int _timerIndex;
    NSTimer *timer;
    BOOL _running;
    SCIGenericType * data;
    SCIChartHeatmapColourMap * _colorMapView;
}

@synthesize surface;

- (void)willMoveToWindow:(UIWindow *)newWindow {
    [super willMoveToWindow: newWindow];
    if(timer == nil) {
        timer = [NSTimer scheduledTimerWithTimeInterval:TIME_INTERVAL target:self selector:@selector(updateHeatmapData:) userInfo:nil repeats:YES];
    } else {
        [timer invalidate];
        timer = nil;
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        surface = [[SCIChartSurface alloc]initWithFrame:frame];
        surface.translatesAutoresizingMaskIntoConstraints = NO;
        surface.leftAxisAreaForcedSize = 0.0;
        surface.topAxisAreaForcedSize = 0.0;
        
        _colorMapView = [SCIChartHeatmapColourMap new];

        [self addSubview:surface];
        [surface addSubview:_colorMapView];
        NSDictionary * layout = @{@"SciChart": surface, @"colorMapView": _colorMapView};
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[SciChart]-(0)-|" options:0 metrics:0 views:layout]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[SciChart]-(0)-|" options:0 metrics:0 views:layout]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(8)-[colorMapView]-(>=8)-|" options:0 metrics:0 views:layout]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(8)-[colorMapView]-(40)-|" options:0 metrics:0 views:layout]];
        
        [self initializeSurfaceData];
    }
    
    return self;
}

- (void) initializeSurfaceData {
    id<SCIAxis2DProtocol> xAxis = [SCINumericAxis new];
    id<SCIAxis2DProtocol> yAxis = [SCINumericAxis new];
    
    _dataSeries = [[SCIUniformHeatmapDataSeries alloc] initWithTypeX:SCIDataType_Int32 Y:SCIDataType_Int32 Z:SCIDataType_Double SizeX:WIDTH Y:HEIGHT StartX:SCIGeneric(0.0) StepX:SCIGeneric(1.0) StartY:SCIGeneric(0.0) StepY:SCIGeneric(1.0)];
    
    float gradientCoord[] = {0.f, 0.2f, 0.4f, 0.6f, 0.8f, 1.f};
    uint gradientColor[] = {0xFF00008B, 0xFF6495ED, 0xFF006400, 0xFF7FFF00, 0xFFFFFF00, 0xFFFF0000};
    
    SCIFastUniformHeatmapRenderableSeries * heatmapRenderableSeries = [SCIFastUniformHeatmapRenderableSeries new];
    heatmapRenderableSeries.minimum = 0;
    heatmapRenderableSeries.maximum = 200;
    heatmapRenderableSeries.colorMap = [[SCITextureOpenGL alloc] initWithGradientCoords:gradientCoord Colors:gradientColor Count:6];
    heatmapRenderableSeries.dataSeries = _dataSeries;
    
    [self createData];
    
    _colorMapView.minimum = heatmapRenderableSeries.minimum;
    _colorMapView.maximum = heatmapRenderableSeries.maximum;
    _colorMapView.colourMap = heatmapRenderableSeries.colorMap;
    
    [surface.xAxes add:xAxis];
    [surface.yAxes add:yAxis];
    [surface.renderableSeries add:heatmapRenderableSeries];
    surface.chartModifiers = [[SCIChartModifierCollection alloc] initWithChildModifiers:@[[SCIPinchZoomModifier new], [SCIZoomExtentsModifier new], [SCICursorModifier new]]];
}

- (void)createData {
    data = malloc(sizeof(SCIGenericType)*60);
    
    for (int i = 0; i < SERIES_PER_PERIOD ; i++) {
        double angle = M_PI * 2.0 * i / SERIES_PER_PERIOD;
        double * zValues = malloc(sizeof(double) * WIDTH * HEIGHT);
        double cx = 150, cy = 100;
        
        for (int x = 0; x < WIDTH; x++) {
            for (int y = 0; y < HEIGHT; y++) {
                double v = (1 + sin(x * 0.04 + angle)) * 50 + (1 + sin(y * 0.1 + angle)) * 50 * (1 + sin(angle * 2));
                double r = sqrt((x - cx) * (x - cx) + (y - cy) * (y - cy));
                double exp = MAX(0, 1 - r * 0.008);
                
                zValues[x * HEIGHT + y] = v * exp + arc4random_uniform(50);
            }
        }
        data[i] = SCIGeneric(zValues);
    }
    [_dataSeries updateZValues:data[0] Size:WIDTH*HEIGHT];
}

- (void)updateHeatmapData:(NSTimer *)timer {
    [SCIUpdateSuspender usingWithSuspendable:surface withBlock:^{
        [_dataSeries updateZValues:data[_timerIndex % SERIES_PER_PERIOD] Size:WIDTH * HEIGHT];
        
        [surface invalidateElement];
        _timerIndex++;
    }];
}

@end
