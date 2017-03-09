//
//  ViewController.m
//  ShareChartExample
//
//  Created by Admin on 5/26/16.
//  Copyright © 2016 Admin. All rights reserved.
//

#import "ViewController.h"
#import "ChartView.h"
#import "SpeedTest.h"
#import "TestCase.h"

@interface ViewController () <DrawingProtocolDelegate, UIAlertViewDelegate>

@end

@implementation ViewController {
    TestCase *_caseTest;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    ChartView *chartView = [[ChartView alloc] initWithFrame:self.view.bounds];
    chartView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    chartView.translatesAutoresizingMaskIntoConstraints = YES;
    [self.view addSubview:chartView];
    
    if ([chartView conformsToProtocol:@protocol(SpeedTest)]) {
        _caseTest = [[TestCase alloc] initWithVersion:@""
                                          chartUIView:(UIView<SpeedTest>*)chartView];
        _caseTest.delegate = self;
        [_caseTest runTest:self];
    }
}

#pragma mark - DrawingTestProtocol

- (void)processCompleted:(NSMutableArray*)testCaseData {
    if ([[self.navigationController topViewController] isEqual:self] && testCaseData.count) {
        NSArray *resultsOfCurrent = [testCaseData firstObject];
        NSNumber *fps = resultsOfCurrent[2];
        NSNumber *cpu = resultsOfCurrent[3];
        NSDate *date = resultsOfCurrent[4];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"s.SSS"];
        NSString *startTime = [formatter stringFromDate:date];
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Finished"
                                                         message:[NSString stringWithFormat:@"Average FPS: %.2f\nCPU Load: %.2f %%\nStart Time: %@", fps.doubleValue, cpu.doubleValue, startTime]
                                                        delegate:self
                                               cancelButtonTitle:nil
                                               otherButtonTitles:nil];
        [alert addButtonWithTitle:@"Run test again"];
        [alert show];
        
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(int)buttonIndex {
    //Running test again
    [_caseTest runTest:self];
}

@end
