//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDMultiPaneStockChartViewController.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SCDMultiPaneStockChartViewController.h"

@implementation SCDMultiPaneStockChartViewController

- (void)loadView {
    [super loadView];
    
    self.view = [SCIView new];
    self.view.autoresizingMask = SCIAutoresizingFlexible;
    
    SCIChartSurface *priceSurface = [[SCIChartSurface alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    SCIChartSurface *macdSurface = [[SCIChartSurface alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    SCIChartSurface *rsiSurface = [[SCIChartSurface alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    SCIChartSurface *volumeSurface = [[SCIChartSurface alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    
    for (SCIView *surface in @[priceSurface, macdSurface, rsiSurface, volumeSurface]) {
        surface.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:surface];
    }
    
    [self.view addConstraints:@[
        [priceSurface.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [priceSurface.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [priceSurface.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [priceSurface.bottomAnchor constraintEqualToAnchor:macdSurface.topAnchor],
        
        [macdSurface.leadingAnchor constraintEqualToAnchor:priceSurface.leadingAnchor],
        [macdSurface.trailingAnchor constraintEqualToAnchor:priceSurface.trailingAnchor],
        [macdSurface.heightAnchor constraintEqualToAnchor:rsiSurface.heightAnchor],
        [macdSurface.heightAnchor constraintEqualToConstant:100],
        [macdSurface.bottomAnchor constraintEqualToAnchor:rsiSurface.topAnchor],
        
        [rsiSurface.leadingAnchor constraintEqualToAnchor:priceSurface.leadingAnchor],
        [rsiSurface.trailingAnchor constraintEqualToAnchor:priceSurface.trailingAnchor],
        [rsiSurface.heightAnchor constraintEqualToAnchor:volumeSurface.heightAnchor],
        [rsiSurface.bottomAnchor constraintEqualToAnchor:volumeSurface.topAnchor],
        
        [volumeSurface.leadingAnchor constraintEqualToAnchor:priceSurface.leadingAnchor],
        [volumeSurface.trailingAnchor constraintEqualToAnchor:priceSurface.trailingAnchor],
        [volumeSurface.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
    ]];
    
    _priceSurface = priceSurface;
    _macdSurface = macdSurface;
    _rsiSurface = rsiSurface;
    _volumeSurface = volumeSurface;
}

- (void)tryUpdateChartThemeWithKey:(NSString *)themeKey {
    [SCIThemeManager applyThemeToThemeable:self.priceSurface withThemeKey:themeKey];
    [SCIThemeManager applyThemeToThemeable:self.macdSurface withThemeKey:themeKey];
    [SCIThemeManager applyThemeToThemeable:self.rsiSurface withThemeKey:themeKey];
    [SCIThemeManager applyThemeToThemeable:self.volumeSurface withThemeKey:themeKey];
}

@end
