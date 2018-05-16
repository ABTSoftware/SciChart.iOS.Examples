//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SpeedTest.h is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import <Foundation/Foundation.h>
#import "CommonData.h"

//@protocol DrawingProtocolDelegate <NSObject>
//@optional
//- (void) processCompleted:(NSMutableArray*)testCaseData;
//- (void) processCompleted;
//- (void) chartExampleStarted;
//@end

@protocol SpeedTest <NSObject>
//@property (nonatomic, weak) id<DrawingProtocolDelegate> delegate;
-(void)runTest:(TestParameters) testParameters;
-(void)updateChart;
-(void)stopTest;
@property NSString* chartProviderName;
- (void) processCompleted:(NSMutableArray*)testCaseData;
@end
