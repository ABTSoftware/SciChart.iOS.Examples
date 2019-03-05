//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SplineLineRenderableSeries.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SplineLineRenderableSeries.h"

@interface TriDiagonalMatrixF : NSObject {
@public
    double * A;
    double * B;
    double * C;
    int size;
    double * resolved;
}

-(instancetype)initWithSize:(int)n;
-(void)resolve:(double*)d size:(int)n;

@end

@implementation TriDiagonalMatrixF

-(instancetype)initWithSize:(int)n {
    self = [super init];
    if (self) {
        size = n;
        A = malloc(sizeof(double)*n);
        B = malloc(sizeof(double)*n);
        C = malloc(sizeof(double)*n);
        resolved = nil;
    }
    return self;
}

-(void)dealloc {
    free(A);
    free(B);
    free(C);
    if (resolved != nil) {
        free(resolved);
    }
}

-(void)resolve:(double*)d size:(int)n {
    if (n != size) {
        return;
    }
    
    // cPrime
    double * cPrime = malloc(sizeof(double)*n);
    cPrime[0] = C[0] / B[0];
    
    for (int i = 1; i < n; i++) {
        cPrime[i] = C[i] / (B[i] - cPrime[i - 1] * A[i]);
    }
    
    // dPrime
    double * dPrime = malloc(sizeof(double)*n);
    dPrime[0] = d[0] / B[0];
    
    for (int i = 1; i < n; i++) {
        dPrime[i] = (d[i] - dPrime[i - 1] * A[i]) / (B[i] - cPrime[i - 1] * A[i]);
    }
    
    // Back substitution
    double * x = malloc(sizeof(double)*n);
    x[n - 1] = dPrime[n - 1];
    
    for (int i = n-2; i >= 0; i--) {
        x[i] = dPrime[i] - cPrime[i] * x[i + 1];
    }
    
    free(cPrime);
    free(dPrime);
    resolved = x;
}

@end

@interface CubicSpline : NSObject
@end

@implementation CubicSpline {
    double * a;
    double * b;
    double * xOrig;
    double * yOrig;
    int origSize;
    int lastIndex;
}

-(instancetype)init {
    self = [super init];
    if (self) {
        a = nil;
        b = nil;
        xOrig = nil;
        yOrig = nil;
        origSize = 0;
        lastIndex = 0;
    }
    return self;
}

-(void)dealloc {
    if (a != nil) free(a);
    if (b != nil) free(b);
    if (xOrig != nil) free(xOrig);
    if (yOrig != nil) free(yOrig);
}

-(void) fitX:(double*)x Y:(double*)y size:(int)n startSlope:(double)startSlope endSlope:(double)endSlope {
    origSize = n;
    xOrig = malloc(sizeof(double)*n);
    memcpy(xOrig, x, n*sizeof(double));
    yOrig = malloc(sizeof(double)*n);
    memcpy(yOrig, y, n*sizeof(double));
    
    double* r = malloc(sizeof(double)*n);
    TriDiagonalMatrixF * m = [[TriDiagonalMatrixF alloc] initWithSize:n];
    double dx1, dx2, dy1, dy2;
    
    // First row is different (equation 16 from the article)
    if (isnan(startSlope)) {
        dx1 = x[1] - x[0];
        m->C[0] = 1.0 / dx1;
        m->B[0] = 2.0 * m->C[0];
        r[0] = 3 * (y[1] - y[0]) / (dx1 * dx1);
    } else {
        m->B[0] = 1;
        r[0] = startSlope;
    }
    
    // Body rows (equation 15 from the article)
    for (int i = 1; i < n-1; i++) {
        dx1 = x[i] - x[i - 1];
        dx2 = x[i + 1] - x[i];
        
        m->A[i] = 1.0 / dx1;
        m->C[i] = 1.0 / dx2;
        m->B[i] = 2.0 * (m->A[i] + m->C[i]);
        
        dy1 = y[i] - y[i - 1];
        dy2 = y[i + 1] - y[i];
        r[i] = 3 * (dy1 / (dx1 * dx1) + dy2 / (dx2 * dx2));
    }
    
    // Last row also different (equation 17 from the article)
    if (isnan(endSlope)) {
        dx1 = x[n - 1] - x[n - 2];
        dy1 = y[n - 1] - y[n - 2];
        m->A[n - 1] = 1.0 / dx1;
        m->B[n - 1] = 2.0 * m->A[n - 1];
        r[n - 1] = 3 * (dy1 / (dx1 * dx1));
    } else {
        m->B[n - 1] = 1;
        r[n - 1] = endSlope;
    }
    
    // k is the solution to the matrix
    [m resolve:r size:n];
    double * k  = m->resolved;
    
    // a and b are each spline's coefficients
    a = malloc(sizeof(double)*(n-1));
    b = malloc(sizeof(double)*(n-1));
    
    for (int i = 1; i < n; i++) {
        dx1 = x[i] - x[i - 1];
        dy1 = y[i] - y[i - 1];
        a[i - 1] = k[i - 1] * dx1 - dy1; // equation 10 from the article
        b[i - 1] = -k[i] * dx1 + dy1; // equation 11 from the article
    }
    free(r);
}

-(int) getNextIndexX:(double)x {
    while ((lastIndex < origSize - 2) && (x > xOrig[lastIndex + 1])) {
        lastIndex++;
    }
    return lastIndex;
}

-(SCIArrayController*)fitAndEvalX:(SCIArrayController*)x Y:(SCIArrayController*)y XS:(SCIArrayController*)xs startSlope:(double)startSlope endSlope:(double)endSlope {
    if (x.doubleData == nil || y.doubleData == nil) return nil;
    [self fitX:x.doubleData Y:y.doubleData size:x.count startSlope:startSlope endSlope:endSlope];;
    
    int n = xs.count;
    SCIArrayController * result = [[SCIArrayController alloc] initWithType:SCIDataType_Double Size:n];
    double * resultData  = result.doubleData;
    double * xsData = xs.doubleData;
    lastIndex = 0; // Reset simultaneous traversal in case there are multiple calls
    
    for (int i = 0; i < n; i++) {
        // Find which spline can be used to compute this x (by simultaneous traverse)
        int j = [self getNextIndexX:xsData[i]];
        // Evaluate using j'th spline
        double dx = xOrig[j + 1] - xOrig[j];
        double t = (xsData[i] - xOrig[j]) / dx;
        resultData[i] = (1 - t) * yOrig[j] + t * yOrig[j + 1] + t * (1 - t) * (a[j] * (1 - t) + b[j] * t); // equation 9
    }
    [result setCount:n];
    return result;
}

@end

@implementation SplineLineRenderableSeries

@synthesize upSampleFactor = _upSampleFactor;
@synthesize isSplineEnabled = _isSplineEnabled;
@synthesize strokeStyle = _strokeStyle;

-(instancetype)init{
    self = [super init];
    if (self) {
        _isSplineEnabled = true;
        _upSampleFactor = 0;
    }
    return self;
}

-(id<SCIPointSeriesProtocol>) computeSplineSeriesWithData:(id<SCIRenderPassDataProtocol>)renderPassData isSplineEnabled:(BOOL)isSplineEnabled upSampleFactor:(int)upSampleFactor {
    if (!isSplineEnabled) {
        return renderPassData.pointSeries;
    }
    
    // Spline enabled
    int n = self.currentRenderPassData.pointSeries.count * upSampleFactor;
    id<SCIArrayControllerProtocol> x = self.currentRenderPassData.pointSeries.xValues;
    id<SCIArrayControllerProtocol> y = self.currentRenderPassData.pointSeries.yValues;
    id<SCIArrayControllerProtocol> xs = [[SCIArrayController alloc] initWithType:SCIDataType_Double Size:n];
    double * xData = x.doubleData;
    double * xsData = xs.doubleData;
    double stepSize = (xData[x.count - 1] - xData[0]) / (n - 1.0);
    for (int i = 0; i < n; i++) {
        xsData[i] = xData[0] + i * stepSize;
    }
    [xs setCount:n];
    
    CubicSpline * cubicSpline = [CubicSpline new];
    id<SCIArrayControllerProtocol> ys = [cubicSpline fitAndEvalX:x Y:y XS:xs startSlope:NAN endSlope:NAN];
    
    SCIPointSeries * result = [[SCIPointSeries alloc] initWithCapacity:n];
    [result.xValues appendRange:SCIGeneric(xs.doubleData) Count:xs.count];
    [result.yValues appendRange:SCIGeneric(ys.doubleData) Count:ys.count];
    return result;
}

-(void)internalDrawWithContext:(id<SCIRenderContext2DProtocol>)renderContext WithData:(id<SCIRenderPassDataProtocol>)renderPassData {
    if (self.strokeStyle == nil) return;
    
    id<SCIPointSeriesProtocol> splinePoints = [self computeSplineSeriesWithData:renderPassData isSplineEnabled:self.isSplineEnabled upSampleFactor:self.upSampleFactor];
    id<SCIPointSeriesProtocol> points = renderPassData.pointSeries;

    id<SCIPen2DProtocol> pen = [renderContext createPenFromStyle:self.strokeStyle];
    
    id<SCICoordinateCalculatorProtocol> xCalc = renderPassData.xCoordinateCalculator;
    id<SCICoordinateCalculatorProtocol> yCalc = renderPassData.yCoordinateCalculator;
    {
        int pointCount = splinePoints.count;
        double * x = splinePoints.xValues.doubleData;
        double * y = splinePoints.yValues.doubleData;
        double xCoord = [xCalc getCoordinateFrom:x[0]];
        double yCoord = [yCalc getCoordinateFrom:y[0]];
        [renderContext beginPolylineWithBrush:pen withPointX:xCoord Y:yCoord];
        for (int i = 1; i < pointCount; i++) {
            xCoord = [xCalc getCoordinateFrom:x[i]];
            yCoord = [yCalc getCoordinateFrom:y[i]];
            [renderContext extendPolylineWithBrush:pen withPointX:xCoord Y:yCoord];
        }
    }
    
    if (self.pointMarker != nil) {
        int pointCount = points.count;
        double * x = points.xValues.doubleData;
        double * y = points.yValues.doubleData;
        for (int i = 0; i < pointCount; i++) {
            double xCoord = [xCalc getCoordinateFrom:x[i]];
            double yCoord = [yCalc getCoordinateFrom:y[i]];
            [self.pointMarker drawToContext:renderContext AtX:xCoord Y:yCoord];
        }
    }
}

@end
