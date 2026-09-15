//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDTradingAnnotationsChartViewController.h is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SCDSingleChartViewController.h"

@interface SCDTradingAnnotationsChartViewController : SCDSingleChartViewController<SCIChartSurface *>

typedef NS_ENUM(NSInteger, SCICreationModifier) {
    SCICreationModifier_Pitchfork = 0,
    SCICreationModifier_Xabcd,
    SCICreationModifier_FibonacciRetracement,
    SCICreationModifier_Measure,
    SCICreationModifier_StopLoss,
};

@property (nonatomic) SCIXabcdCreationModifier *xabcdCreationModifier;
@property (nonatomic) SCIPitchforkCreationModifier *pitchforkCreationModifier;
@property (nonatomic) SCIAnnotationCreationModifierBase *selectedCreationModifier;

@property (nonatomic, strong) SCIFibonacciRetracementCreationModifier *fibonacciModifier;
@property (nonatomic, strong) SCIMeasureCreationModifier *measureModifier;
@property (nonatomic, strong) SCIStopLossTakeProfitCreationModifier *stopLossTakeProfitModifier;
//@property (nonatomic, strong) NSArray<SCIMultiPointAnnotationPlacementModifier *> *placementModifiers;

@property (strong, nonatomic) SCITextAnnotation *instructionAnnotation;

@end
