//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SingleChartLayout.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SCDSingleChartViewController.h"
#import <SciChart/NSObject+ExceptionUtil.h>

@implementation SCDSingleChartViewController

- (SCIView<ISCIChartSurfaceBase> *)surface {
    return (SCIView<ISCIChartSurfaceBase> *)self.view;
}

- (Class)associatedType {
    @throw [self notImplementedExceptionFor:_cmd];
}

- (void)loadView {
    [super loadView];
    
    self.view = [[self.associatedType alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
#if TARGET_OS_IOS
    self.edgesForExtendedLayout = UIRectEdgeNone;
#endif
}

- (void)tryUpdateChartThemeWithKey:(NSString *)themeKey {
    [SCIThemeManager applyThemeToThemeable:self.surface withThemeKey:themeKey];
}

@end
