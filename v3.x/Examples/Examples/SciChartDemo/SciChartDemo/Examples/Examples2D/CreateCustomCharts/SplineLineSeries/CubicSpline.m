//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// CubicSpline.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "CubicSpline.h"
#import "TriDiagonalMatrixF.h"

@implementation CubicSpline {
    float *a;
    float *b;
    float *xOrig;
    float *yOrig;
    int origSize;
    int lastIndex;
}

- (instancetype)init {
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

- (void)dealloc {
    if (a != nil) free(a);
    if (b != nil) free(b);
    if (xOrig != nil) free(xOrig);
    if (yOrig != nil) free(yOrig);
}

- (SCIFloatValues *)fitAndEvalX:(SCIFloatValues *)x y:(SCIFloatValues *)y xS:(SCIFloatValues *)xs startSlope:(float)startSlope endSlope:(float)endSlope {
    [self fitX:x.itemsArray y:y.itemsArray size:x.count startSlope:startSlope endSlope:endSlope];
    return [self evalX:xs];
}

- (void)fitX:(float *)x y:(float *)y size:(int)n startSlope:(float)startSlope endSlope:(float)endSlope {
    origSize = n;
    xOrig = malloc(sizeof(float) * n);
    memcpy(xOrig, x, sizeof(float) * n);
    yOrig = malloc(sizeof(float) * n);
    memcpy(yOrig, y, sizeof(float) * n);
    
    float *r = malloc(sizeof(float) * n);
    TriDiagonalMatrixF *m = [[TriDiagonalMatrixF alloc] initWithSize:n];
    float dx1, dx2, dy1, dy2;
    
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
    for (int i = 1; i < n - 1; i++) {
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
    float *k  = m->resolved;
    
    // a and b are each spline's coefficients
    a = malloc(sizeof(float) * (n - 1));
    b = malloc(sizeof(float) * (n - 1));
    
    for (int i = 1; i < n; i++) {
        dx1 = x[i] - x[i - 1];
        dy1 = y[i] - y[i - 1];
        a[i - 1] = k[i - 1] * dx1 - dy1; // equation 10 from the article
        b[i - 1] = -k[i] * dx1 + dy1; // equation 11 from the article
    }
    free(r);
}

- (SCIFloatValues *)evalX:(SCIFloatValues *)x {
    int n = x.count;
    SCIFloatValues *y = [[SCIFloatValues alloc] initWithCapacity:n];
    
    lastIndex = 0; // Reset simultaneous traversal in case there are multiple calls
    
    for (int i = 0; i < n; i++) {
        // Find which spline can be used to compute this x (by simultaneous traverse)
        int j = [self getNextIndexX:[x getValueAt:i]];
        // Evaluate using j'th spline
        float yValue = [self evalSplineWithX:[x getValueAt:i] atJ:j];
        [y add:yValue];
    }
    return y;
}

- (int)getNextIndexX:(float)x {
    while ((lastIndex < origSize - 2) && (x > xOrig[lastIndex + 1])) {
        lastIndex++;
    }
    return lastIndex;
}

- (float)evalSplineWithX:(float)x atJ:(int)j {
    float dx = xOrig[j + 1] - xOrig[j];
    float t = (x - xOrig[j]) / dx;
    float y = (1 - t) * yOrig[j] + t * yOrig[j + 1] + t * (1 - t) * (a[j] * (1 - t) + b[j] * t); // equation 9
    
    return y;
}

@end
