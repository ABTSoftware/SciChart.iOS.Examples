//
//  UsingRolloverModifierChartView.m
//  SciChartDemo
//
//  Created by Yaroslav Pelyukh on 7/23/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

#import "UsingRolloverModifierChartView.h"
#import "InterpolationTurnOnOff.h"

@implementation UsingRolloverModifierChartView {
    SCIRolloverModifier * _rolloverModifier;
}

@synthesize surface;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        surface = [SCIChartSurface new];
        surface.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self addSubview:surface];
        
        InterpolationTurnOnOff * panel = (InterpolationTurnOnOff *)[[NSBundle mainBundle] loadNibNamed:@"InterpolationTurnOnOff" owner:self options:nil].firstObject;
        panel.translatesAutoresizingMaskIntoConstraints = NO;
        panel.onUseInterpolationClicked = ^(BOOL isOn) { _rolloverModifier.style.hitTestMode = isOn ? SCIHitTest_VerticalInterpolate : SCIHitTest_Vertical; };

        [self addSubview:panel];
        
        NSDictionary * layout = @{@"SciChart":surface, @"Panel":panel};
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[Panel(63)]-(0)-[SciChart]-(0)-|" options:0 metrics:0 views:layout]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[SciChart]-(0)-|" options:0 metrics:0 views:layout]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[Panel]-(0)-|" options:0 metrics:0 views:layout]];
        
        [self initializeSurfaceData];
    }
    
    return self;
}

-(void) initializeSurfaceData {
    id<SCIAxis2DProtocol> xAxis = [SCINumericAxis new];
    id<SCIAxis2DProtocol> yAxis = [SCINumericAxis new];
    yAxis.growBy = [[SCIDoubleRange alloc] initWithMin:SCIGeneric(0.2) Max:SCIGeneric(0.2)];
    
    SCIXyDataSeries * ds1 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Int32 YType:SCIDataType_Double];
    ds1.seriesName = @"Sinewave A";
    SCIXyDataSeries * ds2 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Int32 YType:SCIDataType_Double];
    ds2.seriesName = @"Sinewave B";
    SCIXyDataSeries * ds3 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Int32 YType:SCIDataType_Double];
    ds3.seriesName = @"Sinewave C";
    
    double count = 100;
    double k = 2 * M_PI / 30.0;
    for (int i = 0; i < count; i++) {
        double phi = k * i;
        [ds1 appendX:SCIGeneric(i) Y:SCIGeneric((1.0 + i / count) * sin(phi))];
        [ds2 appendX:SCIGeneric(i) Y:SCIGeneric((0.5 + i / count) * sin(phi))];
        [ds3 appendX:SCIGeneric(i) Y:SCIGeneric((i / count) * sin(phi))];
    }
    
    SCIEllipsePointMarker * ellipsePointMarker = [SCIEllipsePointMarker new];
    ellipsePointMarker.fillStyle = [[SCISolidBrushStyle alloc] initWithColorCode:0xFFd7ffd6];
    ellipsePointMarker.width = 7;
    ellipsePointMarker.height = 7;
 
    SCIFastLineRenderableSeries * rs1 = [SCIFastLineRenderableSeries new];
    rs1.dataSeries = ds1;
    rs1.pointMarker = ellipsePointMarker;
    rs1.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFFa1b9d7 withThickness:1];
    
    SCIFastLineRenderableSeries * rs2 = [SCIFastLineRenderableSeries new];
    rs2.dataSeries = ds2;
    rs2.pointMarker = ellipsePointMarker;
    rs2.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFF0b5400 withThickness:1];
    
    SCIFastLineRenderableSeries * rs3 = [SCIFastLineRenderableSeries new];
    rs3.dataSeries = ds3;
    rs3.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFF386ea6 withThickness:1];
    
    _rolloverModifier = [SCIRolloverModifier new];
    
    [SCIUpdateSuspender usingWithSuspendable:surface withBlock:^{
        [surface.xAxes add:xAxis];
        [surface.yAxes add:yAxis];
        [surface.renderableSeries add:rs1];
        [surface.renderableSeries add:rs2];
        [surface.renderableSeries add:rs3];
        [surface.chartModifiers add:_rolloverModifier];
        
        [rs1 addAnimation:[[SCISweepRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOut]];
        [rs2 addAnimation:[[SCISweepRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOut]];
        [rs3 addAnimation:[[SCISweepRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOut]];
    }];
}

@end
