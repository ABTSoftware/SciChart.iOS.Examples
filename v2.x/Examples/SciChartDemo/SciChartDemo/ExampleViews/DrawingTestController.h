//
//  DrawingTestController.h
//  SciChartDemo
//
//  Created by Hrybenuik Mykola on 5/2/17.
//  Copyright © 2017 ABT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SpeedTest.h"
#import "TestCase.h"

@interface DrawingTestController : NSObject <DrawingProtocolDelegate>

- (void)createTestCaseWithView:(UIView<SpeedTest>*)view;

@end
