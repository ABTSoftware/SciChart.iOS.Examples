//
//  BaseTestSciChart.m
//  SciChartDemo
//
//  Created by Hrybenuik Mykola on 5/3/17.
//  Copyright © 2017 ABT. All rights reserved.
//

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
