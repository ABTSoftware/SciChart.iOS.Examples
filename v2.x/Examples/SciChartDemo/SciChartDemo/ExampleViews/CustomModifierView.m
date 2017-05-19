//
//  CustomModifierView.m
//  SciChartDemo
//
//  Created by Admin on 8/29/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

#import "CustomModifierView.h"
#import <SciChart/SciChart.h>
#import "CustomModifierControlPanel.h"

@interface CustomModifier : SCIGestureModifier

@end

@implementation CustomModifier {
    SCIEllipsePointMarker * _marker; // marker to be displayed
    CGPoint _location; // position of tap gesture
    BOOL _visible; // if marker should be visible
    double _xValue; // x data value at point marker
    double _yValue; // y data value at point marker
    int _index; // index of data point at point marker position
    id<SCIRenderableSeriesProtocol> _rSeries; // renderable series to whicj point marker is bound
    __weak CustomModifierControlPanel * _controlPanel; // control panel for additional actions with modifier
}

-(instancetype)initWithControlPanel:(CustomModifierControlPanel*)panel {
    self = [super init];
    if (self) {
        // setup control panel
        _controlPanel = panel;
        __weak CustomModifier * wSelf = self;
        _controlPanel.onNextClicked = ^(){ [wSelf moveMarker:+1]; };
        _controlPanel.onPrevClicked = ^(){ [wSelf moveMarker:-1]; };
        _controlPanel.onClearClicked = ^(){ [wSelf hideMarker]; };
        
        // create marker
        _marker = [[SCIEllipsePointMarker alloc] init];
        _marker.fillStyle = [[SCISolidBrushStyle alloc] initWithColor:[UIColor redColor]];
        _marker.strokeStyle = nil;
    }
    return self;
}

-(void) hideMarker {
    _visible = NO;
    // modifier context should be invalidated to trigger modifier redraw
    id<SCIChartSurfaceProtocol> parent = self.parentSurface;
    id<SCIRenderContext2DProtocol> context = [[parent renderSurface] modifierContext];
    [context invalidate];
}

-(void) moveMarker:(int)mod {
    if (!_visible) return;
    id<SCIChartSurfaceProtocol> parent = self.parentSurface;
    id<SCIRenderContext2DProtocol> context = [[parent renderSurface] modifierContext];
    _index += mod;
    id<SCIRenderPassDataProtocol> data = [_rSeries currentRenderPassData];
    id<SCIDataSeriesProtocol> dataSeries = [data dataSeries];
    // check if index is out of data series range
    BOOL indexOutOfRange = _index < 0 || _index >= [dataSeries count];
    if (indexOutOfRange) {
        _visible = NO;
        [context invalidate];
        return;
    }
    // get data values from data series for new index
    _xValue = SCIGenericDouble([[dataSeries xValues] valueAt:_index]);
    _yValue = SCIGenericDouble([[dataSeries yValues] valueAt:_index]);
    if (isnan(_xValue) || isnan(_yValue)) {
        _visible = NO;
        [context invalidate];
        return;
    }
    // trigger redraw
    [context invalidate];
}

-(void) preapareDataForDrawing {
    _visible = NO;
    id<SCIChartSurfaceProtocol> parent = self.parentSurface;
    SCIRenderableSeriesCollection * series = [parent renderableSeries];
    id<SCIRenderSurfaceProtocol> surface = [parent renderSurface];
    CGPoint actualLocation = [surface pointInChartFrame:_location];
    
    int count = (int)[series count];
    // check every renderable series for hit
    for (int i = 0; i < count; i++) {
        id<SCIRenderableSeriesProtocol> rSeries = [series itemAt:i];
        id<SCIRenderPassDataProtocol> data = [rSeries currentRenderPassData];
        id<SCIHitTestProviderProtocol> hitTest = [rSeries hitTestProvider]; // get hit test tools
        if (hitTest == nil) continue;
        // hit test verticaly: check if vertical projection through touch location crosses chart
        SCIHitTestInfo hitTestResult = [hitTest hitTestVerticalAtX:actualLocation.x Y:actualLocation.y Radius:5 onData:data];
        if (hitTestResult.match) { // if hit is registered on series
            // get values at closest point to hit test position
            _xValue = SCIGenericDouble(hitTestResult.xValue);
            _yValue = SCIGenericDouble(hitTestResult.yValue);
            _index = hitTestResult.index;
            if (isnan(_xValue) || isnan(_yValue)) continue;
            _visible = YES;
            _rSeries = rSeries;
            break;
        }
    }
}

-(BOOL) onTapGesture:(UITapGestureRecognizer*)gesture At:(UIView*)view {
    CGPoint location = [gesture locationInView:view];
    id<SCIRenderSurfaceProtocol> rs = [self.parentSurface renderSurface];
    if (![rs isPointWithinBounds:location]) return NO;
    if (gesture.state == UIGestureRecognizerStateEnded) {
        // save location of touch
        _location = location;
        [self preapareDataForDrawing];
        // invalidate modifier context to trigger redrawing of modifier
        id<SCIChartSurfaceProtocol> parent = self.parentSurface;
        id<SCIRenderContext2DProtocol> context = [[parent renderSurface] modifierContext];
        [context invalidate];
    }
    return YES;
}

-(void)draw {
    if (!_visible) return;
    id<SCIChartSurfaceProtocol> parent = self.parentSurface;
    id<SCIRenderSurfaceProtocol> surface = [parent renderSurface];
    id<SCIRenderContext2DProtocol> context = [surface modifierContext];
    
    CGRect area = surface.chartFrame;
    [context setDrawingArea:area]; // context needs proper area (in that case it is chart area)
    
    // get coordinate calculators and calculate coordinates on screen for data point
    id<SCIRenderPassDataProtocol> data = [_rSeries currentRenderPassData];
    id<SCICoordinateCalculatorProtocol> xCalc = [data xCoordinateCalculator];
    id<SCICoordinateCalculatorProtocol> yCalc = [data yCoordinateCalculator];
    double xCoord = [xCalc getCoordinateFrom:_xValue];
    double yCoord = [yCalc getCoordinateFrom:_yValue];
    
    // draw point marker
    [_marker drawToContext:context AtX:xCoord Y:yCoord];
    
    // update control panel text
    NSString * panelText = [NSString stringWithFormat:@"Index: %d X:%g Y:%g", _index, _xValue, _yValue];
    [_controlPanel setText: panelText];
}

@end

@implementation CustomModifierView {
    CustomModifierControlPanel * _controlPanel;
}


@synthesize surface;

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        SCIChartSurface * view = [[SCIChartSurface alloc]initWithFrame:frame];
        surface = view;
        
        [surface setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        _controlPanel = (CustomModifierControlPanel*)[[[NSBundle mainBundle] loadNibNamed:@"CustomModifierControlPanel" owner:self options:nil] firstObject];
        
        [self addSubview:_controlPanel];
        [self addSubview:surface];
        
        [surface setTranslatesAutoresizingMaskIntoConstraints:NO];
        _controlPanel.translatesAutoresizingMaskIntoConstraints = NO;
        NSDictionary *layout = @{@"SciChart":surface, @"Panel":_controlPanel};
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[Panel(43)]-(0)-[SciChart]-(0)-|"
                                                                     options:0 metrics:0 views:layout]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[SciChart]-(0)-|"
                                                                     options:0 metrics:0 views:layout]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[Panel]-(0)-|"
                                                                     options:0 metrics:0 views:layout]];
        
        [self initializeSurfaceData];
    }
    
    return self;
}

-(void) initializeSurfaceData {
    
    
    self.surface.backgroundColor = [UIColor fromARGBColorCode:0xFF1c1c1e];
    self.surface.renderableSeriesAreaFill = [[SCISolidBrushStyle alloc] initWithColorCode:0xFF1c1c1e];
    [self addAxes];
    [self addModifiers];
    [self initializeSurfaceRenderableSeries];
}

-(void) addAxes{
    SCISolidPenStyle * majorPen = [[SCISolidPenStyle alloc] initWithColorCode:0xFF323539 withThickness:0.5];
    SCISolidBrushStyle * gridBandPen = [[SCISolidBrushStyle alloc] initWithColorCode:0xE1202123];
    SCISolidPenStyle * minorPen = [[SCISolidPenStyle alloc] initWithColorCode:0xFF232426 withThickness:0.5];
    
    SCITextFormattingStyle *  textFormatting= [[SCITextFormattingStyle alloc] init];
    [textFormatting setFontSize:16];
    [textFormatting setFontName:@"Helvetica"];
    [textFormatting setColorCode:0xFFb6b3af];
    
    SCIAxisStyle * axisStyle = [[SCIAxisStyle alloc]init];
    [axisStyle setMajorTickBrush:majorPen];
    [axisStyle setGridBandBrush: gridBandPen];
    [axisStyle setMajorGridLineBrush:majorPen];
    [axisStyle setMinorTickBrush:minorPen];
    [axisStyle setMinorGridLineBrush:minorPen];
    [axisStyle setLabelStyle:textFormatting ];
    [axisStyle setDrawMinorGridLines:YES];
    [axisStyle setDrawMajorBands:YES];
    
    id<SCIAxis2DProtocol> axis = [[SCINumericAxis alloc] init];
    [axis setStyle: axisStyle];
    axis.axisId = @"yAxis";
    [axis setGrowBy: [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)]];
    [surface.yAxes add:axis];
    
    axis = [[SCINumericAxis alloc] init];
    axis.axisId = @"xAxis";
    [axis setStyle: axisStyle];
    [axis setGrowBy: [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)]];
    [surface.xAxes add:axis];
}

-(void) addModifiers{
    SCIXAxisDragModifier * xDragModifier = [SCIXAxisDragModifier new];
    xDragModifier.axisId = @"xAxis";
    xDragModifier.dragMode = SCIAxisDragMode_Scale;
    xDragModifier.clipModeX = SCIClipMode_None;
    [xDragModifier setModifierName:@"XAxis DragModifier"];
    
    SCIYAxisDragModifier * yDragModifier = [SCIYAxisDragModifier new];
    yDragModifier.axisId = @"yAxis";
    yDragModifier.dragMode = SCIAxisDragMode_Pan;
    [yDragModifier setModifierName:@"YAxis DragModifier"];
    
    SCIPinchZoomModifier * pzm = [[SCIPinchZoomModifier alloc] init];
    [pzm setModifierName:@"PinchZoom Modifier"];
    
    SCIZoomExtentsModifier * zem = [[SCIZoomExtentsModifier alloc] init];
    [zem setModifierName:@"ZoomExtents Modifier"];
    
    CustomModifier * marker = [[CustomModifier alloc] initWithControlPanel:_controlPanel];
    
    SCIChartModifierCollection * gm = [[SCIChartModifierCollection alloc] initWithChildModifiers:@[xDragModifier, yDragModifier, pzm, zem, marker]];
    surface.chartModifiers = gm;
}

-(void) initializeSurfaceRenderableSeries {
    int dataCount = 200;
    SCIXyDataSeries * priceDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Float YType:SCIDataType_Float SeriesType:SCITypeOfDataSeries_DefaultType];
    //Getting Fourier dataSeries
    for (int i = 0; i < dataCount; i++) {
        double time = 10 * i / (double)dataCount;
        double x = time;
        double y = arc4random_uniform(20);
        [priceDataSeries appendX:SCIGeneric(x) Y:SCIGeneric(y)];
    }
    
    priceDataSeries.dataDistributionCalculator = [SCIUserDefinedDistributionCalculator new];
    
    SCIFastLineRenderableSeries * priceRenderableSeries = [SCIFastLineRenderableSeries new];
    [priceRenderableSeries setStrokeStyle: [[SCISolidPenStyle alloc] initWithColorCode:0xFF99EE99 withThickness:0.7]];
    [priceRenderableSeries setXAxisId: @"xAxis"];
    [priceRenderableSeries setYAxisId: @"yAxis"];
    [priceRenderableSeries setDataSeries:priceDataSeries];
    [surface.renderableSeries add:priceRenderableSeries];
    
    [surface invalidateElement];
}

@end
