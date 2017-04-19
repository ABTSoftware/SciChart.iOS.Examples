//
//  MedicalFadeOutPaletteProvider.m
//  SciChartShowcaseDemo
//
//  Created by Admin on 03/03/17.
//  Copyright © 2017 SciChart Ltd. All rights reserved.
//

#import "MedicalFadeOutPaletteProvider.h"

@implementation MedicalFadeOutPaletteProvider {
    NSMutableArray * _styles;
    SCILineSeriesStyle * _lastPointStyle;
    int _lastIndex;
}

-(instancetype)initWithSeriesColor:(UIColor*)color Stroke:(float)stroke {
    self = [super init];
    if (self) {
        _lastPointStyle = [[SCILineSeriesStyle alloc] init];
        _lastPointStyle.linePen = nil;
        _lastPointStyle.drawPointMarkers = YES;
        SCIEllipsePointMarker * lastPointMarker = [SCIEllipsePointMarker new];
        lastPointMarker.strokeStyle = nil;
        lastPointMarker.fillStyle = [[SCISolidBrushStyle alloc] initWithColor:[UIColor whiteColor]];
        _lastPointStyle.pointMarker = lastPointMarker;
        
        _styles = [NSMutableArray new];
        uint colorCode = [color colorABGRCode];
        uint red = colorCode & 0xFF;
        uint green = (colorCode >> 8) & 0xFF;
        uint blue = (colorCode >> 16) & 0xFF;
        for (int alpha = 0x00; alpha <= 0xFF; alpha++) {
            uint colorCode = (alpha << 24) | (blue << 16) | (green << 8) | red;
            UIColor * penColor = [UIColor fromABGRColorCode:colorCode];
            SCILineSeriesStyle * style = [SCILineSeriesStyle new];
            style.linePen = [[SCISolidPenStyle alloc] initWithColor:penColor withThickness:stroke];
            [_styles addObject:style];
        }
    }
    return self;
}

-(void)updateData:(id<SCIRenderPassDataProtocol>)data {
    _lastIndex = [[data dataSeries] count] -1;
}

-(id<SCIStyleProtocol>)styleForX:(double)x Y:(double)y Index:(int)index {
    if (index == _lastIndex) return _lastPointStyle;
    int brushIndex = ((float)index) * 0.1;
    if (brushIndex > 255) {
        return nil;
    } else if (brushIndex < 0) {
        brushIndex = 0;
    }
    return _styles[brushIndex];
}

@end
