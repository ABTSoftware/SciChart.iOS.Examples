//
//  DrawingTestController.m
//  SciChartDemo
//
//  Created by Hrybenuik Mykola on 5/2/17.
//  Copyright © 2017 ABT. All rights reserved.
//

#import "DrawingTestController.h"


@implementation DrawingTestController {
    TestCase *_caseTest;
}

- (void)createTestCaseWithView:(UIView<SpeedTest>*)view {
    _caseTest = [[TestCase alloc] initWithVersion:@""
                                      chartUIView:view];
    _caseTest.delegate = self;
    [_caseTest runTest];
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
        [_caseTest runTest];
    }
    else {
        [(UINavigationController*)[[[UIApplication sharedApplication] keyWindow] rootViewController] popViewControllerAnimated:YES];
    }
}

@end
