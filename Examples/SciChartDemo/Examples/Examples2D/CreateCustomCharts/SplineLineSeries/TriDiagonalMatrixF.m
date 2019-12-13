//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// TriDiagonalMatrixF.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "TriDiagonalMatrixF.h"

@implementation TriDiagonalMatrixF

- (instancetype)initWithSize:(NSInteger)n {
    self = [super init];
    if (self) {
        size = n;
        A = malloc(sizeof(float) * n);
        B = malloc(sizeof(float) * n);
        C = malloc(sizeof(float) * n);
        resolved = nil;
    }
    return self;
}

- (void)dealloc {
    free(A);
    free(B);
    free(C);
    if (resolved != nil) {
        free(resolved);
    }
}

- (void)resolve:(float *)d size:(NSInteger)n {
    if (n != size) {
        return;
    }
    
    // cPrime
    float *cPrime = malloc(sizeof(float) * n);
    cPrime[0] = C[0] / B[0];
    
    for (int i = 1; i < n; i++) {
        cPrime[i] = C[i] / (B[i] - cPrime[i - 1] * A[i]);
    }
    
    // dPrime
    float *dPrime = malloc(sizeof(float) * n);
    dPrime[0] = d[0] / B[0];
    
    for (int i = 1; i < n; i++) {
        dPrime[i] = (d[i] - dPrime[i - 1] * A[i]) / (B[i] - cPrime[i - 1] * A[i]);
    }
    
    // Back substitution
    float *x = malloc(sizeof(float) * n);
    x[n - 1] = dPrime[n - 1];
    
    for (NSInteger i = n-2; i >= 0; i--) {
        x[i] = dPrime[i] - cPrime[i] * x[i + 1];
    }
    
    free(cPrime);
    free(dPrime);
    resolved = x;
}

@end
