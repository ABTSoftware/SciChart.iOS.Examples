//
//  BaseTestSciChart.m
//  SciChartDemo
//
//  Created by Hrybenuik Mykola on 5/3/17.
//  Copyright © 2017 ABT. All rights reserved.
//

#import "BaseTestSciChart.h"
#import "DrawingTestController.h"

@implementation BaseTestSciChart {
    DrawingTestController *_drawingDelegate;
}

@synthesize chartProviderName;
@synthesize delegate;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _drawingDelegate = [DrawingTestController new];
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    [_drawingDelegate createTestCaseWithView:self];
    
}

- (void)removeFromSuperview {
    [super removeFromSuperview];
    _drawingDelegate = nil;
}

#pragma SpeedTest implementation
-(void)runTest:(TestParameters)testParameters{
    // Should be implemented in inhertied class
}

-(void)updateChart{
    // Should be implemented in inhertied class
}

-(void)stopTest{
    // Should be implemented in inhertied class
}

@end
