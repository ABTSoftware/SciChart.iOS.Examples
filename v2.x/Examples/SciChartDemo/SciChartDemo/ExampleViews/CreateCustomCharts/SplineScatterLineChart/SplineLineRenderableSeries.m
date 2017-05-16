//
//  SplineLineRenderableSeries.m
//  SciChartDemo
//
//  Created by Admin on 03/05/2017.
//  Copyright © 2017 ABT. All rights reserved.
//

#import "SplineLineRenderableSeries.h"

@implementation SplineLineRenderableSeries

@synthesize upSampleFactor = _upSampleFactor;
@synthesize isSplineEnabled = _isSplineEnabled;
@synthesize strokeStyle = _strokeStyle;

-(instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(void)internalDrawWithContext:(id<SCIRenderContext2DProtocol>)renderContext WithData:(id<SCIRenderPassDataProtocol>)renderPassData{
    if (_strokeStyle == nil) {
        return;
    }
    
}

@end
