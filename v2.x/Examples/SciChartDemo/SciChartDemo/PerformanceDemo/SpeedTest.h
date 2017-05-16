//
//  SpeedTest.h
//  ComparisonApp
//
//  Created by Yaroslav Pelyukh on 4/13/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

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
