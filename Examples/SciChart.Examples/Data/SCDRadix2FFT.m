//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDRadix2FFT.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SCDRadix2FFT.h"

static double logarithm(double value, double base) {
    return log(value) / log(base);
}

@interface Complex: NSObject

@property (nonatomic) double re;
@property (nonatomic) double im;

@end

@implementation Complex
@end

@implementation SCDRadix2FFT {
    int _n;
    int _m;
    int _mm1;
    
    NSMutableArray<Complex *> *_x;
    NSMutableArray<Complex *> *_dft;
    double _twoPi_N;
    Complex *_wn;
    Complex *_temp;
}

@synthesize fftSize = _fftSize;

- (instancetype)initWithSize:(int)n {
    self = [super init];
    if (self) {
        _wn = [Complex new];
        _temp = [Complex new];
        _x = [NSMutableArray<Complex *> new];
        _dft = [NSMutableArray<Complex *> new];
        
        _n = n;
        _m = logarithm(n, 2.0);
        
        if (pow(2, _m) != _n) {
            @throw [[NSException alloc] initWithName:NSInvalidArgumentException reason:@"n should be with power of 2" userInfo:nil];
        }
        
        _fftSize = n / 2;
        _twoPi_N = M_PI * 2 / n;
        _mm1 = _m - 1;
        
        for (int i = 0; i < n; ++i) {
            [_x addObject:[Complex new]];
            [_dft addObject:[Complex new]];
        }
        
    }
    return self;
}

- (void)runWithReals:(double *)re imaginaries:(double *)im {
    // init input values
    for (int i = 0; i < _n; i++) {
        Complex *complex = _x[i];
        complex.re = re[i];
        complex.im = im[i];
    }
    
    // perform fft
    [self rad2FFT:_x and:_dft];
    
    for (int i = 0; i < _n; i++) {
        Complex *complex = _dft[i];
        re[i] = complex.re;
        im[i] = complex.im;
    }
}

- (void)rad2FFT:(NSMutableArray<Complex *> *)x and:(NSMutableArray<Complex *> *)DFT {
    int BSep;                  //BSep is memory spacing between butterflies
    int BWidth;                //BWidth is memory spacing of opposite ends of the butterfly
    int P;                     // P is number of similar Wn's to be used in that stage
    int iaddr;                 // bitmask for bit reversal
    int ii;                    // Integer bitfield for bit reversal (Decimation in Time)
    
    int DFTindex = 0;          // Pointer to first elements in DFT array

    // Decimation In Time - x[n] sample sorting
    for (int i = 0; i < _n; i++, DFTindex++) {
        Complex *pX = _x[i];              // Calculate current x[n] from index i.
        ii = 0;                           // Reset new address for DFT[n]
        iaddr = i;                        // Copy i for manipulations
        
        for (int l = 0; l < _m; l++) {    // Bit reverse i and store in ii...
            if ((iaddr & 0x01) != 0) {    // Detemine least significant bit
                ii += (1 << (_mm1 - l));  // Increment ii by 2^(M-1-l) if lsb was 1
            }
            iaddr >>= 1;                  // right shift iaddr to test next bit. Use logical operations for speed increase
            if (iaddr == 0) {
                break;
            }
        }
        
        Complex *dft = DFT[ii];           // Calculate current DFT[n] from bit reversed index ii
        dft.re = pX.re;                   // Update the complex array with address sorted time domain signal x[n]
        dft.im = pX.im;                   // NB: Imaginary is always zero
    }
    
    // FFT Computation by butterfly calculation
    for (int stage = 1; stage <= _m; stage ++) {                   // Loop for M stages, where 2^M = N
        BSep = (int)pow(2.0, stage);                               // Separation between butterflies = 2^stage
        P = _n / BSep;                                             // Butterfly width (spacing between opposite points) = Separation / 2
        BWidth = BSep / 2;
        
        for (int j = 0; j < BWidth; j++) {                         // Loop for j calculations per butterfly
            if (j != 0) {                                          // Save on calculation if R = 0, as WN^0 = (1 + j0)
                _wn.re = cos(_twoPi_N * P * j);                    // Calculate Wn (Real and Imaginary)
                _wn.im = -sin(_twoPi_N * P * j);
            }
            
            // HiIndex is the index of the DFT array for the top value of each butterfly calc
            for (int HiIndex = j; HiIndex < _n; HiIndex += BSep) { // Loop for HiIndex Step BSep butterflies per stage
                Complex *pHi = DFT[HiIndex];                       // Point to higher value
                Complex *pLo = DFT[HiIndex + BWidth];              // Point to lower value
                
                if (j != 0) {                                      // If exponential power is not zero...
                    
                    // Perform complex multiplication of LoValue with Wn
                    _temp.re = (pLo.re * _wn.re) - (pLo.im * _wn.im);
                    _temp.im = (pLo.re * _wn.im) + (pLo.im * _wn.re);
                    
                    // Find new LoValue (complex subtraction)
                    pLo.re = pHi.re - _temp.re;
                    pLo.im = pHi.im - _temp.im;
                    
                    // Find new HiValue (complex addition)
                    pHi.re = pHi.re + _temp.re;
                    pHi.im = pHi.im + _temp.im;
                } else {
                    _temp.re = pLo.re;
                    _temp.im = pLo.im;
                    
                    // Find new LoValue (complex subtraction)
                    pLo.re = pHi.re - _temp.re;
                    pLo.im = pHi.im - _temp.im;
                   
                    // Find new HiValue (complex addition)
                    pHi.re = pHi.re + _temp.re;
                    pHi.im = pHi.im + _temp.im;
                }
            }
        }
    }
}


@end
