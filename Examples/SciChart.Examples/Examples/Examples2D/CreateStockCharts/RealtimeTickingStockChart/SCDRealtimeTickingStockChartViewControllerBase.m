//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDRealtimeTickingStockChartViewController.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SCDRealtimeTickingStockChartViewControllerBase.h"
#import <SciChart/NSObject+ExceptionUtil.h>
#import "SCDToolbarPopupItem.h"
#import "SCDToolbarButton.h"
#import "SCDToolbarButtonsGroup.h"
#import "SCIStackView.h"

@interface SCDRealtimeTickingStockChartViewControllerBase()
@property (nonatomic) NSArray<Class> *seriesTypes;
@end

@implementation SCDRealtimeTickingStockChartViewControllerBase {
    NSArray<NSString *> *_seriesNames;
    NSInteger _initialSeriesIndex;
    
    SCDToolbarPopupItem *_changeSeriesItem;
}

- (void)tryUpdateChartTheme:(SCIChartTheme)theme {
    [SCIThemeManager applyTheme:theme toThemeable:self.mainSurface];
    [SCIThemeManager applyTheme:theme toThemeable:self.overviewSurface];
}

- (void)commonInit {
    _seriesNames = @[@"CandlestickRenderableSeries", @"OhlcRenderableSeries", @"MountainRenderableSeries"];
    _seriesTypes = @[SCIFastCandlestickRenderableSeries.class, SCIFastOhlcRenderableSeries.class, SCIFastMountainRenderableSeries.class];
    _initialSeriesIndex = 1;
    
    _changeSeriesItem = [self p_SCD_createToolbarPopupItem];
}

- (SCDToolbarPopupItem *)p_SCD_createToolbarPopupItem {
    __weak typeof(self) wSelf = self;
    return [[SCDToolbarPopupItem alloc] initWithTitles:_seriesNames selectedIndex:_initialSeriesIndex andAction:^(NSUInteger selectedIndex) {
        [wSelf p_SCD_changeSeriesType:wSelf.seriesTypes[selectedIndex]];
    }];
}

- (void)loadView {
    [super loadView];
    
    self.view = [SCIView new];
    self.view.autoresizingMask = SCIAutoresizingFlexible;
    
    SCIStackView *stackView = [SCIStackView new];
    stackView.axis = SCILayoutConstraintAxisVertical;
    stackView.spacing = 0;
    
#if TARGET_OS_IOS
    [stackView addArrangedSubview:[self providePanel]];
#endif
    
    SCIChartSurface *mainSurface = [[SCIChartSurface alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    [stackView addArrangedSubview:mainSurface];
    
    SCIChartSurface *overviewSurface = [[SCIChartSurface alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    [stackView addArrangedSubview:overviewSurface];
    
    _mainSurface = mainSurface;
    _overviewSurface = overviewSurface;
    
    stackView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:stackView];
    
    [self.view addConstraints:@[
        [stackView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [stackView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [stackView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [stackView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
        [overviewSurface.heightAnchor constraintEqualToConstant:100]
    ]];
}
- (NSArray<id<ISCDToolbarItem>> *)provideExampleSpecificToolbarItems {
    __weak typeof(self) wSelf = self;
    
    return @[
#if TARGET_OS_OSX
        _changeSeriesItem,
#endif
        [[SCDToolbarButtonsGroup alloc] initWithToolbarItems:@[
            [[SCDToolbarButton alloc] initWithTitle:@"Start" image:[SCIImage imageNamed:@"chart.play"] andAction:^{
                [wSelf subscribePriceUpdate];
            }],
            [[SCDToolbarButton alloc] initWithTitle:@"Stop" image:[SCIImage imageNamed:@"chart.stop"] andAction:^{
                [wSelf clearSubscribtions];
            }]
        ]]
    ];
}

#if TARGET_OS_IOS
- (SCIView *)providePanel {
    return [_changeSeriesItem createView];
}
#endif

- (void)subscribePriceUpdate {
    @throw [self notImplementedExceptionFor:_cmd];
}

- (void)clearSubscribtions {
    @throw [self notImplementedExceptionFor:_cmd];
}

- (void)p_SCD_changeSeriesType:(Class)seriesType {
    __weak typeof(self) wSelf = self;
    [SCIUpdateSuspender usingWithSuspendable:wSelf.mainSurface withBlock:^{
        id<ISCIRenderableSeries> oldSeries = [wSelf.mainSurface.renderableSeries itemAt:1];
        [wSelf.mainSurface.renderableSeries removeAt:1];
        
        id<ISCIRenderableSeries> rSeries = [seriesType new];
        rSeries.dataSeries = oldSeries.dataSeries;
        [wSelf.mainSurface.renderableSeries add:rSeries];
    }];
}

@end
