//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2024. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDDynamicAnnotationsViewController.h is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SCDExampleBaseViewController.h"
#import "SCDSingleChartViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, DrawMode) {
    DrawMode_Box,
    DrawMode_Line,
    DrawMode_Markers
};

@interface SCDDynamicAnnotationsViewController: SCDSingleChartViewController<SCIChartSurface *>

@property (nonatomic) DrawMode drawMode;
- (void)didDragModeChange:(DrawMode)drawMode;


@end

NS_ASSUME_NONNULL_END
