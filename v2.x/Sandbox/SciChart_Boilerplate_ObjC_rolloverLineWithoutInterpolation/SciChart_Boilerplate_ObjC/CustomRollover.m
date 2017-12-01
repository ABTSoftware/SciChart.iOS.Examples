//
//  CustomRollover.m
//  SciChart_Boilerplate_ObjC
//
//  Created by Admin on 28/08/2017.
//  Copyright © 2017 SciChart. All rights reserved.
//

#import "CustomRollover.h"

@interface SCIRolloverModifier()

-(void) p_SCI_addTooltipForHorizontalAxis:(id<SCIAxis2DProtocol>)axis ToView:(UIView*)canvas LocationInRenderSurface:(CGPoint)actualLocation;

@end

@implementation CustomRollover {
    double _rolloverPosition;
    id<SCIPen2DProtocol> _rolloverPen;
    BOOL _isHit;
}

-(instancetype)init {
    self = [super init];
    if (self) {
        self.style.rolloverPen = nil; // if you replace modifier style make sure rolloverPen is nil;
        _rolloverPen = [[SCIPenSolid alloc] initWithColor:self.style.axisTooltipColor Width:1.0f];
    }
    return self;
}

-(SCIHitTestInfo)hitTestWithProvider:(__unsafe_unretained id<SCIHitTestProviderProtocol>)provider Location:(CGPoint)location Radius:(double)radius onData:(id<SCIRenderPassDataProtocol>)data hitTestMode:(SCIHitTestMode)hitTestMode
{
    SCIHitTestInfo info = [super hitTestWithProvider:provider Location:location Radius:radius onData:data hitTestMode:hitTestMode];
    
    id<SCICoordinateCalculatorProtocol> xCalc = data.xCoordinateCalculator;
    _rolloverPosition = [xCalc getCoordinateFrom:SCIGenericDouble(info.xValue)];
    _isHit |= info.match;
    
    return info;
}

-(void)draw {
    _isHit = NO;
    [super draw];
    if (_isHit) {
        id<SCIChartSurfaceProtocol> parent = self.parentSurface;
        id<SCIRenderSurfaceProtocol> surface = [parent renderSurface];
        id<SCIRenderContext2DProtocol> context = [surface modifierContext];
        CGRect area = surface.chartFrame;
        [context setDrawingArea:area];
        [context drawLineWithBrush:_rolloverPen fromX:_rolloverPosition Y:0 toX:_rolloverPosition Y:area.size.height];
    }
}

-(void) p_SCI_addTooltipForHorizontalAxis:(id<SCIAxis2DProtocol>)axis ToView:(UIView*)canvas LocationInRenderSurface:(CGPoint)actualLocation {
    CGPoint location = actualLocation;
    location.x = _rolloverPosition;
    [super p_SCI_addTooltipForHorizontalAxis:axis ToView:canvas LocationInRenderSurface:actualLocation];
}

@end
