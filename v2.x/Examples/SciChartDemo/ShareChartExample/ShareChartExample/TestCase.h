//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// TestCase.h is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import <Foundation/Foundation.h>
#import "CommonData.h"
#import "SpeedTest.h"
#import <UIKit/UIKit.h>
#import <mach/mach.h>
#import <QuartzCore/QuartzCore.h>

@interface TestCase : NSObject

@property (nonatomic, strong) NSString * version;
@property (nonatomic) TestParameters testParameters;
@property (nonatomic, strong) NSString * chartTypeTest;
//fps data
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, strong) CADisplayLink *secondLink;
@property (nonatomic) CFTimeInterval startTime;
@property (nonatomic) int frameCount;
@property (nonatomic) BOOL completed;

- (instancetype)initWithVersion:(NSString*)version
                    chartUIView:(UIView<SpeedTest>*)chartUIView;

-(void)runTest;

-(void)interaptTest;

-(void)processCompleted;

-(void)chartExampleStarted;

@end
