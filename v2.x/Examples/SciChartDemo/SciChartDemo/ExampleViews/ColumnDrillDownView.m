//
//  CollumnDrillDownView.m
//  SciChartDemo
//
//  Created by Admin on 9/30/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

#import "ColumnDrillDownView.h"
#import <SciChart/SciChart.h>

#pragma mark Custom modifier

@interface ColumnHitTest : SCIGestureModifier

@property (nonatomic, copy) SCIActionBlock_Pint tapedAtIndex;
@property (nonatomic, copy) SCIActionBlock doubleTaped;

@end

@implementation ColumnHitTest {
    CGPoint _location; // position of tap gesture
    int _index; // index of data column
}

-(instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

-(BOOL) onTapGesture:(UITapGestureRecognizer*)gesture At:(UIView*)view {
    CGPoint location = [gesture locationInView:view];
    id<SCIRenderSurfaceProtocol> rs = [self.parentSurface renderSurface];
    if (![rs isPointWithinBounds:location]) return NO;
    if (gesture.state == UIGestureRecognizerStateEnded) {
        // save location of touch
        _location = location;
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
                _index = hitTestResult.index;
                if (_tapedAtIndex != nil) _tapedAtIndex(_index);
                break;
            }
        }
    }
    return YES;
}

-(BOOL)onDoubleTapGesture:(UITapGestureRecognizer *)gesture At:(UIView *)view {
    CGPoint location = [gesture locationInView:view];
    id<SCIRenderSurfaceProtocol> rs = [self.parentSurface renderSurface];
    if (![rs isPointWithinBounds:location]) return NO;
    if (_doubleTaped != nil) _doubleTaped();
    return YES;
}

@end

#pragma mark Palette provider
@interface ColumnDrillDownPalette : SCIPaletteProvider

@end

@implementation ColumnDrillDownPalette {
    NSMutableArray * _styles;
}

-(instancetype)init {
    self = [super init];
    if (self) {
        _styles = [NSMutableArray new];
    }
    return self;
}

-(void) addStyle:(id<SCIStyleProtocol>)style {
    [_styles addObject:style];
}

-(id<SCIStyleProtocol>)styleForX:(double)x Y:(double)y Index:(int)index {
    if (index > [_styles count]) return nil;
    return _styles[index];
}

@end

#pragma mark Chart surface

@implementation ColumnDrillDownView {
    SCIXyDataSeries * _firstData;
    SCIXyDataSeries * _secondData;
    SCIXyDataSeries * _thirdData;
    SCIXyDataSeries * _totalData;
    
    SCIFastColumnRenderableSeries * _firstColumn;
    SCIFastColumnRenderableSeries * _secondColumn;
    SCIFastColumnRenderableSeries * _thirdColumn;
    SCIFastColumnRenderableSeries * _totalColumn;
    
    BOOL _isShowingTotal;
}

-(void) createData {
    _totalData = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Int32 YType:SCIDataType_Int32];
    {
        _firstData = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Int32 YType:SCIDataType_Int32];
        int total = 0;
        int count = arc4random_uniform(5)+3;
        for (int i = 0; i < count; i++) {
            int value = arc4random_uniform(5+i)+1;
            total += value;
            [_firstData appendX:SCIGeneric(i) Y:SCIGeneric(value)];
        }
        [_totalData appendX:SCIGeneric(1) Y:SCIGeneric(total)];
    }
    {
        _secondData = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Int32 YType:SCIDataType_Int32];
        int total = 0;
        int count = arc4random_uniform(5)+3;
        for (int i = 0; i < count; i++) {
            int value = arc4random_uniform(5+i)+1;
            total += value;
            [_secondData appendX:SCIGeneric(i) Y:SCIGeneric(value)];
        }
        [_totalData appendX:SCIGeneric(2) Y:SCIGeneric(total)];
    }
    {
        _thirdData = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Int32 YType:SCIDataType_Int32];
        int total = 0;
        int count = arc4random_uniform(5)+3;
        for (int i = 0; i < count; i++) {
            int value = arc4random_uniform(5+i)+1;
            total += value;
            [_thirdData appendX:SCIGeneric(i) Y:SCIGeneric(value)];
        }
        [_totalData appendX:SCIGeneric(3) Y:SCIGeneric(total)];
    }
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        _firstData = nil;
        _secondData = nil;
        _thirdData = nil;
        _totalData = nil;
        _isShowingTotal = NO;
        
        SCIChartSurface * view = [[SCIChartSurface alloc]initWithFrame:frame];
        self.surface = view;
        
        [self.surface setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [self addSubview:self.surface];
        
        NSDictionary *layout = @{@"SciChart":self.surface};
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[SciChart]-(0)-|"
                                                                     options:0 metrics:0 views:layout]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[SciChart]-(0)-|"
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
    [self createData];
    [self initializeSurfaceRenderableSeries];
    [self showTotal];
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
    [_surface.yAxes add:axis];
    
    axis = [[SCICategoryNumericAxis alloc] init];
    axis.axisId = @"xAxis";
    [axis setStyle: axisStyle];
    [axis setGrowBy: [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)]];
    [_surface.xAxes add:axis];
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
    
    ColumnHitTest * drillDownModifier = [[ColumnHitTest alloc] init];
    __weak typeof(self) wSelf = self;
    drillDownModifier.doubleTaped = ^() {
        [wSelf showTotal];
    };
    drillDownModifier.tapedAtIndex = ^(int index) {
        [wSelf showDetailedChartAt:index];
    };
    
    SCIChartModifierCollection * gm = [[SCIChartModifierCollection alloc] initWithChildModifiers:@[xDragModifier, yDragModifier, pzm, drillDownModifier]];
    _surface.chartModifiers = gm;
}

-(void) showTotal {
    _isShowingTotal = YES;
    [_surface.renderableSeries clear];
    [_surface.renderableSeries add:_totalColumn];
    [_surface.viewportManager zoomExtents];
    [_surface invalidateElement];
}

-(void) showDetailedChartAt:(int)index {
    if (!_isShowingTotal) return;
    if (index == 0) {
        [self showFirst];
    } else if (index == 1) {
        [self showSecond];
    } else if (index == 2) {
        [self showThird];
    }
}

-(void) showFirst {
    _isShowingTotal = NO;
    [_surface.renderableSeries clear];
    [_surface.renderableSeries add:_firstColumn];
    [_surface.viewportManager zoomExtents];
    [_surface invalidateElement];
}

-(void) showSecond {
    _isShowingTotal = NO;
    [_surface.renderableSeries clear];
    [_surface.renderableSeries add:_secondColumn];
    [_surface.viewportManager zoomExtents];
    [_surface invalidateElement];
}

-(void) showThird {
    _isShowingTotal = NO;
    [_surface.renderableSeries clear];
    [_surface.renderableSeries add:_thirdColumn];
    [_surface.viewportManager zoomExtents];
    [_surface invalidateElement];
}

-(void) initializeSurfaceRenderableSeries {
    _firstColumn = [[SCIFastColumnRenderableSeries alloc] init];
    _firstColumn.fillBrushStyle = [[SCILinearGradientBrushStyle alloc] initWithColorCodeStart:0xFF00FFFF finish:0xA000FFFF direction:SCILinearGradientDirection_Vertical];
    _firstColumn.strokeStyle = nil;
    _firstColumn.xAxisId = @"xAxis";
    _firstColumn.yAxisId = @"yAxis";
    _firstColumn.dataSeries = _firstData;
    
    _secondColumn = [[SCIFastColumnRenderableSeries alloc] init];
    _secondColumn.fillBrushStyle = [[SCILinearGradientBrushStyle alloc] initWithColorCodeStart:0xFF00FF00 finish:0xA000FF00 direction:SCILinearGradientDirection_Vertical];
    _secondColumn.strokeStyle = nil;
    _secondColumn.xAxisId = @"xAxis";
    _secondColumn.yAxisId = @"yAxis";
    _secondColumn.dataSeries = _secondData;
    
    _thirdColumn = [[SCIFastColumnRenderableSeries alloc] init];
    _thirdColumn.fillBrushStyle = [[SCILinearGradientBrushStyle alloc] initWithColorCodeStart:0xFFFF0000 finish:0xA0FF0000 direction:SCILinearGradientDirection_Vertical];
    _thirdColumn.strokeStyle = nil;
    _thirdColumn.xAxisId = @"xAxis";
    _thirdColumn.yAxisId = @"yAxis";
    _thirdColumn.dataSeries = _thirdData;
    
    _totalColumn = [[SCIFastColumnRenderableSeries alloc] init];
    _totalColumn.fillBrushStyle = [[SCILinearGradientBrushStyle alloc] initWithColorCodeStart:0xFF505050 finish:0xA550005 direction:SCILinearGradientDirection_Vertical];
    _totalColumn.strokeStyle = nil;
    _totalColumn.xAxisId = @"xAxis";
    _totalColumn.yAxisId = @"yAxis";
    _totalColumn.dataSeries = _totalData;
    
    ColumnDrillDownPalette * palette = [[ColumnDrillDownPalette alloc] init];
    [palette addStyle:[_firstColumn.style copy]];
    [palette addStyle:[_secondColumn.style copy]];
    [palette addStyle:[_thirdColumn.style copy]];
    _totalColumn.paletteProvider = palette;
}

@end
