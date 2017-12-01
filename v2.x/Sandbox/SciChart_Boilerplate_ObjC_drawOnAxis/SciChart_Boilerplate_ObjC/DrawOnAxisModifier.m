//
//  DrawOnAxisModifier.m
//  SciChart_Boilerplate_ObjC
//
//  Created by Admin on 09/06/2017.
//  Copyright © 2017 SciChart. All rights reserved.
//

#import "DrawOnAxisModifier.h"

@implementation DrawOnAxisModifier

-(instancetype)init {
    self = [super init];
    if (self) {
        _lineStyle = [[SCISolidPenStyle alloc] initWithColor:UIColor.blueColor withThickness:2];
    }
    return self;
}

-(void)draw {
    id<SCIRenderContext2DProtocol> renderContext = [self.parentSurface.renderSurface modifierContext];
    for (NSString *axisId in _axesId) {
        id<SCIAxis2DProtocol> axis = [self.parentSurface.xAxes getAxisById:axisId];
        if (axis == nil) {
            axis = [self.parentSurface.yAxes getAxisById:axisId];
        }
        if (axis == nil) continue;
        CGPoint start, end;
        [self getPointStart:&start End:&end ForAxis:axis];
        [renderContext setDrawingArea:[axis frame]];
        id<SCIPen2DProtocol> pen = [renderContext createPenFromStyle:_lineStyle];
        [renderContext drawLineWithBrush:pen fromX:start.x Y:start.y toX:end.x Y:end.y];
    }
}

-(void) getPointStart:(CGPoint*)start End:(CGPoint*)end ForAxis:(id<SCIAxis2DProtocol>)axis {
    CGRect frame = axis.frame;
    if (axis.axisAlignment == SCIAxisAlignment_Top) {
        start->x = 0;
        start->y = frame.size.height;
        end->x = frame.size.width;
        end->y = frame.size.height;
    } else if (axis.axisAlignment == SCIAxisAlignment_Bottom) {
        start->x = 0;
        start->y = 0;
        end->x = frame.size.width;
        end->y = 0;
    } else if (axis.axisAlignment == SCIAxisAlignment_Right) {
        start->x = 0;
        start->y = 0;
        end->x = 0;
        end->y = frame.size.height;
    } else if (axis.axisAlignment == SCIAxisAlignment_Left) {
        start->x = frame.size.width;
        start->y = 0;
        end->x = frame.size.width;
        end->y = frame.size.height;
    }
}

@end
