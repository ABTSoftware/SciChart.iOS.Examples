//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// BaseTestSciChart.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "BaseTestSciChart.h"

@implementation BaseTestSciChart {
}

@synthesize chartProviderName;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
//        _drawingDelegate = [DrawingTestController new];
        _testCase = [[TestCase alloc] initWithVersion:@""
                                          chartUIView:self];
        
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
//    [_drawingDelegate createTestCaseWithView:self];
    [_testCase runTest];
}

- (void)removeFromSuperview {
    [super removeFromSuperview];
    [_testCase interaptTest];
    _testCase = nil;
//    [_drawingDelegate interaptTest];
//    _drawingDelegate = nil;
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

#pragma mark - DrawingTestProtocol

- (void)processCompleted:(NSMutableArray*)testCaseData {
    if (testCaseData.count) {
        NSArray *resultsOfCurrent = [testCaseData firstObject];
        NSNumber *fps = resultsOfCurrent[2];
        NSNumber *cpu = resultsOfCurrent[3];
        NSDate *date = resultsOfCurrent[4];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"s.SSS"];
        NSString *startTime = [formatter stringFromDate:date];
        UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Finished"
                                                         message:[NSString stringWithFormat:@"Average FPS: %.2f\nCPU Load: %.2f %%\nStart Time: %@", fps.doubleValue, cpu.doubleValue, startTime]
                                                        delegate:self
                                               cancelButtonTitle:@"Cancel"
                                               otherButtonTitles:nil];
        [alert addButtonWithTitle:@"Run test again"];
        [alert show];
        
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(int)buttonIndex {
    
    if(buttonIndex == 1){
        //Running test again
        [_testCase runTest];
    }
    else {
        [(UINavigationController*)[[[UIApplication sharedApplication] keyWindow] rootViewController] popViewControllerAnimated:YES];
    }
}

@end
