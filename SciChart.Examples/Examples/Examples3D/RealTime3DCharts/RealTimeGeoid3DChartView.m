//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// RealTimeGeoid3DChartView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "RealTimeGeoid3DChartView.h"

@interface RealTimeGeoid3DChartView ()

@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) SCIEllipsoidDataSeries3D *dataSeries;
@property (strong, nonatomic) SCIDoubleValues *globeHeightMap;
@property (strong, nonatomic) SCIDoubleValues *buffer;

@property (nonatomic) int frames;
@property (nonatomic) int size;
@property (nonatomic) double heightOffsetScale;

@end

@implementation RealTimeGeoid3DChartView

- (Class)associatedType { return SCIChartSurface3D.class; }

- (void)initExample {
    _buffer = [SCIDoubleValues new];
    _frames = 0;
    _size = 100;
    _heightOffsetScale = 0.5;
    
    SCINumericAxis3D *xAxis = [SCINumericAxis3D new];
    xAxis.visibleRange = [[SCIDoubleRange alloc] initWithMin:-8 max:8];
    xAxis.autoRange = SCIAutoRange_Never;
    
    SCINumericAxis3D *yAxis = [SCINumericAxis3D new];
    yAxis.visibleRange = [[SCIDoubleRange alloc] initWithMin:-8 max:8];
    yAxis.autoRange = SCIAutoRange_Never;
    
    SCINumericAxis3D *zAxis = [SCINumericAxis3D new];
    zAxis.visibleRange = [[SCIDoubleRange alloc] initWithMin:-8 max:8];
    zAxis.autoRange = SCIAutoRange_Never;
    
    _dataSeries = [[SCIEllipsoidDataSeries3D alloc] initWithDataType:SCIDataType_Double uSize:_size vSize:_size];
    _dataSeries.a = @(6);
    _dataSeries.b = @(6);
    _dataSeries.c = @(6);
    
    _globeHeightMap = [self createGlobeHeightMap];
    [_dataSeries copyFromValues:_globeHeightMap];
    
    unsigned int colors[7] = { 0xFF1D2C6B, 0xFF0000FF, 0xFF00FFFF, 0xFFADFF2F, 0xFFFFFF00, 0xFFFF0000, 0xFF8B0000 };
    float stops[7] = { 0.0, 0.1, 0.3, 0.5, 0.7, 0.9, 1.0 };
    SCIGradientColorPalette *palette = [[SCIGradientColorPalette alloc] initWithColors:colors stops:stops count:7];

    SCIFreeSurfaceRenderableSeries3D *rSeries = [SCIFreeSurfaceRenderableSeries3D new];
    rSeries.dataSeries = _dataSeries;
    rSeries.drawMeshAs = SCIDrawMeshAs_SolidMesh;
    rSeries.stroke = 0x77228B22;
    rSeries.contourStroke = 0x77228B22;
    rSeries.strokeThickness = 2.0;
    rSeries.meshColorPalette = palette;
    rSeries.paletteMinimum = [[SCIVector3 alloc] initWithX:0.0 y:6.0 z:0.0];
    rSeries.paletteMaximum = [[SCIVector3 alloc] initWithX:0.0 y:7.0 z:0.0];

    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        [self.surface.worldDimensions assignX:200 y:200 z:200];
        self.surface.xAxis = xAxis;
        self.surface.yAxis = yAxis;
        self.surface.zAxis = zAxis;
        [self.surface.renderableSeries add:rSeries];
        [self.surface.chartModifiers add:[SCDExampleBaseViewController createDefaultModifiers3D]];
    }];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.033 target:self selector:@selector(updateData) userInfo:nil repeats:YES];
}

- (SCIDoubleValues *)createGlobeHeightMap {
    SCIBitmap *bitmap = [SCIImage imageNamed:@"image.globe.heightmap"].sciBitmap;
    const double stepU = bitmap.width / _size;
    const double stepV = bitmap.height / _size;
    
    SCIDoubleValues *globeHeightMap = [SCIDoubleValues new];
    globeHeightMap.count = _size * _size;
    double *heightMapItems = globeHeightMap.itemsArray;
    
    for (int v = 0; v < _size; v++) {
        for (int u = 0; u < _size; u++) {
            const int index = v * _size + u;
            const int x = u * stepU;
            const int y = v * stepV;

            unsigned int pixelColor = [bitmap pixelAtX:x y:y];
            heightMapItems[index] = [SCIColor red:pixelColor]  / 255.0;
        }
    }
    
    return globeHeightMap;
}

- (void)updateData {
    __weak typeof(self) wSelf = self;
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        wSelf.frames++;
        
        const double freq = (sin(wSelf.frames * 0.1) + 1.0) / 2.0;
        const double exp = freq * 10.0;
        
        const int offset = wSelf.frames % wSelf.size;
        const NSInteger size = wSelf.globeHeightMap.count;
        
        wSelf.buffer.count = size;
        
        double *heightMapItems = wSelf.globeHeightMap.itemsArray;
        double *bufferItems = wSelf.buffer.itemsArray;
        
        for (int i = 0; i < size; i++) {
            int currentValueIndex = i + offset;
            if (currentValueIndex >= size) {
                currentValueIndex -= wSelf.size;
            }
            
            double currentValue = heightMapItems[currentValueIndex];
            bufferItems[i] = currentValue + pow(currentValue, exp) * wSelf.heightOffsetScale;
        }
        
        [wSelf.dataSeries copyFromValues:wSelf.buffer];
    }];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [_timer invalidate];
    _timer = nil;
}

@end
