//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// ThemeManager3DChartView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "ThemeManager3DChartView.h"
#import "SingleButtonPanel.h"
#import "SCDDataManager.h"

@implementation ThemeManager3DChartView

- (void)commonInit {
    SingleButtonPanel *panel = [SingleButtonPanel new];
    [panel.button setTitle:@"Select Theme" forState:UIControlStateNormal];
    [panel.button addTarget:self action:@selector(p_changeTheme:) forControlEvents:UIControlEventTouchUpInside];
    
    self.panel = panel;
}

- (void)initExample {
    SCINumericAxis3D *xAxis = [SCINumericAxis3D new];
    xAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.1 max:0.1];
    SCINumericAxis3D *yAxis = [SCINumericAxis3D new];
    yAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.1 max:0.1];
    SCINumericAxis3D *zAxis = [SCINumericAxis3D new];
    zAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.1 max:0.1];
    
    SCIXyzDataSeries3D *ds = [[SCIXyzDataSeries3D alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double zType:SCIDataType_Double];
    SCIPointMetadataProvider3D *metadataProvider = [SCIPointMetadataProvider3D new];

    for (int i = 0; i < 250; ++i) {
        double x = [SCDDataManager getGaussianRandomNumber:15 stdDev:1.5];
        double y = [SCDDataManager getGaussianRandomNumber:15 stdDev:1.5];
        double z = [SCDDataManager getGaussianRandomNumber:15 stdDev:1.5];
        [ds appendX:@(x) y:@(y) z:@(z)];

        SCIPointMetadata3D *metaData = [[SCIPointMetadata3D alloc] initWithVertexColor:[SCDDataManager randomColor] andScale:[SCDDataManager randomScale]];
        [metadataProvider.metadata addObject:metaData];
    }
    
    SCIEllipsePointMarker3D *pointMarker = [SCIEllipsePointMarker3D new];
    pointMarker.fillColor = 0x77ADFF2F;
    pointMarker.size = 3.f;
    
    SCIScatterRenderableSeries3D *rs = [SCIScatterRenderableSeries3D new];
    rs.dataSeries = ds;
    rs.pointMarker = pointMarker;
    rs.metadataProvider = metadataProvider;
    
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        self.surface.xAxis = xAxis;
        self.surface.yAxis = yAxis;
        self.surface.zAxis = zAxis;
        [self.surface.renderableSeries add:rs];
        [self.surface.chartModifiers add:ExampleViewBase.createDefault3DModifiers];
    }];
}

- (void)p_changeTheme:(UIButton *)button {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Select Theme" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    NSArray *themeNames = @[@"Black Steel", @"Bright Spark", @"Chrome", @"Chart V4 Dark", @"Electric", @"Expression Dark", @"Expression Light", @"Oscilloscope"];
    NSArray *themeKeys = @[SCIChart_BlackSteelStyleKey, SCIChart_Bright_SparkStyleKey, SCIChart_ChromeStyleKey, SCIChart_SciChartv4DarkStyleKey, SCIChart_ElectricStyleKey, SCIChart_ExpressionDarkStyleKey, SCIChart_ExpressionLightStyleKey, SCIChart_OscilloscopeStyleKey];
    
    for (NSString *themeName in themeNames) {
        UIAlertAction *actionTheme = [UIAlertAction actionWithTitle:themeName style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
            NSString *themeKey = themeKeys[[themeNames indexOfObject:themeName]];
            [SCIThemeManager applyThemeToThemeable:self.surface withThemeKey:themeKey];
            [button setTitle:themeName forState:UIControlStateNormal];
        }];
        [alertController addAction:actionTheme];
    }
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    alertController.popoverPresentationController.sourceView = self;
    alertController.popoverPresentationController.sourceRect = button.frame;
    [[self.window rootViewController].presentedViewController presentViewController:alertController animated:YES completion:nil];
}

@end
