//
//  CustomRollover.m
//  SciChart_Boilerplate_ObjC
//
//  Created by Admin on 26/06/2017.
//  Copyright © 2017 SciChart. All rights reserved.
//

#import "CustomRollover.h"
#import "CustomRolloverTooltipView.h"

@implementation CustomRollover {
    BOOL _gestureLocked;
    CustomRolloverTooltipView * _view;
    CGPoint _location;
    SCISpritePointMarker * _pointMarker1;
    SCISpritePointMarker * _pointMarker2;
    id<SCIPenStyleProtocol> _cursorPen;
    
    NSDateFormatter * _dateFormatter;
    NSNumberFormatter * _numberFormatter;
}

-(instancetype)init {
    self = [super init];
    if (self) {
        _pointMarker1 = [[SCISpritePointMarker alloc] init];
        _pointMarker1.textureBrush = [[SCITextureBrushStyle alloc] initWithTexture: [[SCITextureOpenGL alloc] initWithImage: [UIImage imageNamed:@"RedMarker"] ] ];
        _pointMarker1.width = 20;
        _pointMarker1.height = 20;
        _pointMarker2 = [[SCISpritePointMarker alloc] init];
        _pointMarker2.textureBrush = [[SCITextureBrushStyle alloc] initWithTexture: [[SCITextureOpenGL alloc] initWithImage: [UIImage imageNamed:@"GreenMarker"] ] ];
        _pointMarker2.width = 20;
        _pointMarker2.height = 20;
        _cursorPen = [[SCISolidPenStyle alloc] initWithColor:[UIColor greenColor] withThickness:1];
        _view = (CustomRolloverTooltipView*)[NSBundle.mainBundle loadNibNamed:@"CustomRolloverTooltipView" owner:self options:nil].firstObject;
        
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"EEEE, MMM dd, HH:mm:ss";
        
        _numberFormatter = [[NSNumberFormatter alloc] init];
        _numberFormatter.maximumFractionDigits = 2;
    }
    return self;
}

-(BOOL) pointWithinBounds:(CGPoint)point {
    if (self.autoPassAreaCheck) return YES;
    id<SCIRenderSurfaceProtocol> rs = [self.parentSurface renderSurface];
    if (rs == nil) return NO;
    return [rs isPointWithinBounds:point];
}

-(BOOL)onPanGesture:(UIPanGestureRecognizer *)gesture At:(UIView *)view {
    if ([self xAxes] == nil) return NO;
    
    CGPoint location = [gesture locationInView:view];
    // gesture started
    if (gesture.state == UIGestureRecognizerStateBegan) {
        _gestureLocked = [self pointWithinBounds:location];
        if (!_gestureLocked) return NO;
        _location = location;
    }
    if(!_gestureLocked) return NO;
    // scrolling
    if (location.x != _location.x || location.y != _location.y) {
        _location = location;
        id<SCIChartSurfaceProtocol> parent = self.parentSurface;
        id<SCIRenderContext2DProtocol> context = [[parent renderSurface] modifierContext];
        [context invalidate];
    }
    // gesture ended
    if (gesture.state == UIGestureRecognizerStateEnded) {
        _gestureLocked = NO;
        id<SCIChartSurfaceProtocol> parent = self.parentSurface;
        id<SCIRenderContext2DProtocol> context = [[parent renderSurface] modifierContext];
        [self p_SCI_clearToolTips];
        [context invalidate];
    }
    return YES;
}

-(void) p_SCI_clearToolTips {
    [_view removeFromSuperview];
}

const double hitTestRadius = 10;
const SCIHitTestMode hitTestMode = SCIHitTest_VerticalInterpolate;

-(void)draw {
    if (!_gestureLocked) return;
    
    id<SCIChartSurfaceProtocol> parent = self.parentSurface;
    id<SCIRenderSurfaceProtocol> surface = [parent renderSurface];
    id<SCIRenderContext2DProtocol> context = [surface modifierContext];
    CGRect area = surface.chartFrame;
    [context setDrawingArea:area];
    CGPoint actualLocation = [surface pointInChartFrame:_location];
    id<SCIPen2DProtocol> pen = [context createPenFromStyle:_cursorPen];
    [context drawLineWithBrush:pen fromX:actualLocation.x Y:0 toX:actualLocation.x Y:area.size.height];
    
    SCIRenderableSeriesCollection * series = [parent renderableSeries];
    UIView * canvas = (UIView*) parent;
    [self p_SCI_clearToolTips];
    
    if (series.count >= 2) {
        id<SCIRenderableSeriesProtocol> rSeries1 = series[0];
        id<SCIRenderableSeriesProtocol> rSeries2 = series[1];
        
        SCIHitTestInfo hitTestResult1 =[[rSeries1 hitTestProvider] hitTestAtX:actualLocation.x Y:actualLocation.y Radius:hitTestRadius onData:[rSeries1 currentRenderPassData] Mode:hitTestMode];
        SCIHitTestInfo hitTestResult2 =[[rSeries2 hitTestProvider] hitTestAtX:actualLocation.x Y:actualLocation.y Radius:hitTestRadius onData:[rSeries2 currentRenderPassData] Mode:hitTestMode];
        
        if (hitTestResult1.match && hitTestResult2.match) {
            id<SCICoordinateCalculatorProtocol> xCalc = [[rSeries1 currentRenderPassData] xCoordinateCalculator];
            id<SCICoordinateCalculatorProtocol> yCalc1 = [[rSeries1 currentRenderPassData] yCoordinateCalculator];
            id<SCICoordinateCalculatorProtocol> yCalc2 = [[rSeries2 currentRenderPassData] yCoordinateCalculator];
            
            double xCoord = [xCalc getCoordinateFrom:SCIGenericDouble(hitTestResult1.xValueInterpolated)];
            
            double yCoord1 = [yCalc1 getCoordinateFrom:SCIGenericDouble(hitTestResult1.yValueInterpolated)];
            double yCoord2 = [yCalc2 getCoordinateFrom:SCIGenericDouble(hitTestResult2.yValueInterpolated)];
            
            [_pointMarker1 drawToContext:context AtX:xCoord Y:yCoord1];
            [_pointMarker2 drawToContext:context AtX:xCoord Y:yCoord2];
            
            NSString * date = [_dateFormatter stringFromDate: SCIGenericDate(hitTestResult1.xValueInterpolated) ];
            NSString * value1 = [NSString stringWithFormat:@"%.2f", SCIGenericDouble(hitTestResult1.yValueInterpolated)];
            NSString * value2 = [NSString stringWithFormat:@"%.2f", SCIGenericDouble(hitTestResult2.yValueInterpolated)];
            _view.dateField.text = date;
            _view.temperatureField.text = value1;
            _view.pressureField.text = value2;
            [canvas addSubview:_view];
            [self placeTooltipView:_view InArea:surface.chartFrame
                        WithTarget: CGPointMake(_location.x, _location.y + area.origin.y) ];
        }
    }
}

const float alignmentMargin = 20;

-(void) placeTooltipView:(UIView*)view InArea:(CGRect)area WithTarget:(CGPoint)target {
    CGRect frame = view.frame;
    float xOffset = 0;
    float yOffset = 0;
    
    float tooltipSpacing = alignmentMargin;
    
    
    if (target.x - (frame.size.width + tooltipSpacing) < area.origin.x) {
        double diff = (target.x - frame.size.width) - area.origin.x;
        if (diff > 0) {
            xOffset += diff;
        }
    }

    yOffset -= tooltipSpacing;
    yOffset -= frame.size.height;
    double diff = target.y + yOffset - (area.origin.y);
    if (diff < 0) yOffset -= diff;

    xOffset -= tooltipSpacing;
    xOffset -= frame.size.width;
    
    frame.origin.x = target.x + xOffset;
    frame.origin.y = target.y + yOffset;
    if (frame.origin.x < 0) frame.origin.x = 0;
    
    [view setFrame:frame];
}

@end
