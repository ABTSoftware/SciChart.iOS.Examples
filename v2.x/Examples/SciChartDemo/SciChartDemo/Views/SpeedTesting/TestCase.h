//
//  TestCase.h
//  ComparisonApp
//
//  Created by Yaroslav Pelyukh on 4/13/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

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
