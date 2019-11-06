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

@interface UIImage (SCIBitmap)
@property (nonatomic, readonly, nonnull) SCIBitmap *bitmap;
@end

@implementation UIImage (SCIBitmap)
- (SCIBitmap *)bitmap {
    CGRect rect = CGRectMake(0, 0, self.size.width * self.scale, self.size.height * self.scale);
    SCIBitmap *bitmap = [[SCIBitmap alloc] initWithSize:rect.size];
    CGContextSaveGState(bitmap.context);
    CGContextDrawImage(bitmap.context, rect, self.CGImage);
    CGContextRestoreGState(bitmap.context);
    return bitmap;
}
@end

@implementation RealTimeGeoid3DChartView {
    NSTimer *_timer;
    SCIEllipsoidDataSeries3D *_ds;
    SCIDoubleValues *_globeHeightMap;
    SCIDoubleValues *_buffer;
    
    int _frames;
    int _size;
    double _heightOffsetScale;
}

- (void)initExample {
    _buffer = [SCIDoubleValues new];
    _frames = 0;
    _size = 100;
    _heightOffsetScale = 0.5;
    
    SCINumericAxis3D *xAxis = [SCINumericAxis3D new];
    xAxis.visibleRange = [[SCIDoubleRange alloc] initWithMin:-8 max:8];;
    xAxis.autoRange = SCIAutoRange_Never;
    
    SCINumericAxis3D *yAxis = [SCINumericAxis3D new];
    yAxis.visibleRange = [[SCIDoubleRange alloc] initWithMin:-8 max:8];;
    yAxis.autoRange = SCIAutoRange_Never;
    
    SCINumericAxis3D *zAxis = [SCINumericAxis3D new];
    zAxis.visibleRange = [[SCIDoubleRange alloc] initWithMin:-8 max:8];;
    zAxis.autoRange = SCIAutoRange_Never;
    
    _ds = [[SCIEllipsoidDataSeries3D alloc] initWithDataType:SCIDataType_Double uSize:_size vSize:_size];
    _ds.a = @(6);
    _ds.b = @(6);
    _ds.c = @(6);
    
    _globeHeightMap = [self createGlobeHeightMap];
    [_ds copyFromValues:_globeHeightMap];
    
    unsigned int colors[7] = { 0xFF1D2C6B, 0xFF0000FF, 0xFF00FFFF, 0xFFADFF2F, 0xFFFFFF00, 0xFFFF0000, 0xFF8B0000 };
    float stops[7] = { 0.0, 0.1, 0.3, 0.5, 0.7, 0.9, 1.0 };
    SCIGradientColorPalette *palette = [[SCIGradientColorPalette alloc] initWithColors:colors stops:stops count:7];

    SCIFreeSurfaceRenderableSeries3D *rs0 = [SCIFreeSurfaceRenderableSeries3D new];
    rs0.dataSeries = _ds;
    rs0.drawMeshAs = SCIDrawMeshAs_SolidMesh;
    rs0.stroke = 0x77228B22;
    rs0.contourStroke = 0x77228B22;
    rs0.strokeThickness = 2.0;
    rs0.meshColorPalette = palette;
    rs0.paletteMinimum = [[SCIVector3 alloc] initWithX:0.0 y:6.0 z:0.0];
    rs0.paletteMaximum = [[SCIVector3 alloc] initWithX:0.0 y:7.0 z:0.0];

    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        [self.surface.worldDimensions assignX:200 y:200 z:200];
        self.surface.xAxis = xAxis;
        self.surface.yAxis = yAxis;
        self.surface.zAxis = zAxis;
        [self.surface.renderableSeries add:rs0];
        [self.surface.chartModifiers add:[SCIOrbitModifier3D new]];
        [self.surface.chartModifiers add:[SCIPinchZoomModifier3D new]];
    }];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.033 target:self selector:@selector(updateData) userInfo:nil repeats:YES];
}

- (SCIDoubleValues *)createGlobeHeightMap {
    SCIBitmap *bitmap = [UIImage imageNamed:@"image.globe.heightmap"].bitmap;
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
            heightMapItems[index] = [UIColor red:pixelColor]  / 255.0;
        }
    }
    
    return globeHeightMap;
}

- (void)updateData {
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        _frames += 1;
        
        const double freq = (sin(_frames * 0.1) + 1.0)  / 2.0;
        const double exp = freq * 10.0;
        
        const int offset = _frames % _size;
        const int size = _globeHeightMap.count;
        
        _buffer.count = size;
        
        double *heightMapItems = _globeHeightMap.itemsArray;
        double *bufferItems = _buffer.itemsArray;
        
        for (int i = 0; i < size; i++) {
            int currentValueIndex = i + offset;
            if(currentValueIndex >= size) {
                currentValueIndex -= _size;
            }
            
            double currentValue = heightMapItems[currentValueIndex];
            bufferItems[i] = currentValue + pow(currentValue, exp) * _heightOffsetScale;
        }
        
        [_ds copyFromValues:_buffer];
    }];
}

- (void)willMoveToWindow:(UIWindow *)newWindow {
    [super willMoveToWindow:newWindow];
    if (newWindow == nil) {
        [_timer invalidate];
        _timer = nil;
    }
}

@end
