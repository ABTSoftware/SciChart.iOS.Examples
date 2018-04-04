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
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Finished" message:[NSString stringWithFormat:@"Average FPS: %.2f\nCPU Load: %.2f %%\nStart Time: %@", fps.doubleValue, cpu.doubleValue, startTime] preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alert dismissViewControllerAnimated:YES completion:nil];
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"Run test again" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [_testCase runTest];
        }]];
        
        [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
        
    }
}

@end
