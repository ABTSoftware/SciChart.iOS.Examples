//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDFreehandAnnotationChartViewController.h is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SCDExampleBaseViewController.h"

@interface SCDFreehandAnnotationChartViewController<TSurface: SCIView<ISCIChartSurfaceBase> *> : SCDExampleBaseViewController

@property (nonatomic, readonly) TSurface surface;

@property (nonatomic, readonly) Class associatedType;

@property (nonatomic, assign) float thickness;
@property (nonatomic, assign) unsigned int strokeColor;
@property (strong, nonatomic) NSMutableArray<SCIButton *> *colorButtons;


@property (nonatomic) SCIFreehandDrawingModifier *freeHandModifier;
@property (nonatomic) SCIZoomPanModifier *zoomPanModifier;

@end
