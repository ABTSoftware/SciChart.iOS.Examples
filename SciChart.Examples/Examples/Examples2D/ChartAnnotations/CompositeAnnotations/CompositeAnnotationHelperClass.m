//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2026. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// CompositeAnnotationHelperClass.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "CompositeAnnotationHelperClass.h"

@implementation MeasureXAnnotation

- (instancetype)init {
    self = [super init];

    if (self) {
        [self setup];
    }

    return self;
}

- (void)setup {

    self.isEditable = YES;

    self.fillBrush =
    [[SCISolidBrushStyle alloc] initWithColor:
     [[SCIColor redColor] colorWithAlphaComponent:0.2]];

    _line = [SCILineAnnotation new];
    _leftMarker = [SCILineAnnotation new];
    _rightMarker = [SCILineAnnotation new];
    _label = [SCITextAnnotation new];

    // =========================
    // Main horizontal line
    // =========================
    _line.stroke =
    [[SCISolidPenStyle alloc] initWithColor:SCIColor.yellowColor
                                  thickness:2];

    _line.coordinateMode = SCIAnnotationCoordinateMode_Relative;

    [_line setX1:@0.0];
    [_line setY1:@0.5];
    [_line setX2:@1.0];
    [_line setY2:@0.5];

    // =========================
    // Left vertical marker
    // =========================
    _leftMarker.stroke =
    [[SCISolidPenStyle alloc] initWithColor:SCIColor.yellowColor
                                  thickness:2];

    _leftMarker.coordinateMode = SCIAnnotationCoordinateMode_Relative;

    [_leftMarker setX1:@0.0];
    [_leftMarker setY1:@0.3];
    [_leftMarker setX2:@0.0];
    [_leftMarker setY2:@0.7];

    // =========================
    // Right vertical marker
    // =========================
    _rightMarker.stroke =
    [[SCISolidPenStyle alloc] initWithColor:SCIColor.yellowColor
                                  thickness:2];

    _rightMarker.coordinateMode = SCIAnnotationCoordinateMode_Relative;

    [_rightMarker setX1:@1.0];
    [_rightMarker setY1:@0.3];
    [_rightMarker setX2:@1.0];
    [_rightMarker setY2:@0.7];

    // =========================
    // Label
    // =========================
    [_label setX1:@0.5];
    [_label setY1:@0.6];

    _label.fontStyle =
    [[SCIFontStyle alloc] initWithFontSize:14
                              andTextColor:SCIColor.whiteColor];

    _label.coordinateMode = SCIAnnotationCoordinateMode_Relative;

    // =========================
    // Add child annotations
    // =========================
    self.annotations =
    [[SCIAnnotationCollection alloc] initWithCollection:@[
        _line,
        _leftMarker,
        _rightMarker,
        _label
    ]];
}

#pragma mark - Update Measure

- (void)updateMeasureWithXAxis:(id<ISCICoordinateCalculator>)xAxis
                isCategoryAxis:(BOOL)isCategoryAxis {

    double x1 = [self x1].toDouble;
    double x2 = [self x2].toDouble;
    double y1 = [self y1].toDouble;
    double y2 = [self y2].toDouble;

    if (y1 > y2) {

        self.label.verticalAnchorPoint = SCIVerticalAnchorPoint_Top;
        [self.label setY1:@0.55];

    } else {

        self.label.verticalAnchorPoint = SCIVerticalAnchorPoint_Bottom;
        [self.label setY1:@0.45];
    }

    // Range calculation
    double minX = MIN(x1, x2);
    double maxX = MAX(x1, x2);
    double diff = maxX - minX;

    // Label update
    if (isCategoryAxis) {

        self.label.text =
        [NSString stringWithFormat:@"%.0f days", diff];

    } else {

        self.label.text =
        [NSString stringWithFormat:@"ΔX = %.2f", diff];
    }
}

@end


@implementation MeasureDragListener

- (instancetype)initWithMeasure:(MeasureXAnnotation *)measure
                          xAxis:(id<ISCIAxis>)xAxis {
    self = [super init];
    if (self) {
        _measure = measure;
        _xAxis = xAxis;
    }
    return self;
}

- (void)onDragStarted:(id<ISCIAnnotation>)annotation {
    [self update];
}

- (void)onDragEnded:(id<ISCIAnnotation>)annotation {
    [self update];
}

- (void)onDragAnnotation:(nonnull id<ISCIAnnotation>)annotation byXDelta:(CGFloat)xDelta yDelta:(CGFloat)yDelta { 
    [self update];
}


- (void)update {
    if (self.measure == nil || self.xAxis.currentCoordinateCalculator == nil) {
        return;
    }
    NSLog(@"cat %d",self.xAxis.currentCoordinateCalculator.isCategoryAxisCalculator);
    [self.measure updateMeasureWithXAxis:self.xAxis.currentCoordinateCalculator isCategoryAxis:self.xAxis.currentCoordinateCalculator.isCategoryAxisCalculator];
}

@end


@implementation TradeInfoView

- (instancetype)initWithText:(NSString *)text {
    self = [super initWithFrame:CGRectMake(0, 0, 140, 50)];

    if (self) {
        
        SCILabel *label = [[SCILabel alloc] initWithFrame:CGRectInset(self.bounds, 8, 6)];
        label.text = text;
        label.textColor = SCIColor.whiteColor;
        label.numberOfLines = 2;
        
#if TARGET_OS_OSX
        self.wantsLayer = YES;
        self.layer.backgroundColor = [[SCIColor blackColor] colorWithAlphaComponent:0.85].CGColor;
        label.font = [SCIFont systemFontOfSize:11 weight:NSFontWeightMedium];
#else
        self.backgroundColor = [[SCIColor blackColor] colorWithAlphaComponent:0.85];
        label.font = [SCIFont systemFontOfSize:11 weight:UIFontWeightMedium];
#endif
        
        self.layer.cornerRadius = 8.0;
        [self addSubview:label];
    }

    return self;
}

@end


@implementation TradeSetupAnnotation

- (instancetype)initWithEntry:(double)entry
                     stopLoss:(double)stopLoss
                   takeProfit:(double)takeProfit
                       xIndex:(double)xIndex
                        isBuy:(BOOL)isBuy {

    self = [super init];

    if (self) {

        _entryIcon = [SCIImageAnnotation new];
        _infoView = [SCICustomAnnotation new];
        _slLine = [SCILineAnnotation new];
        _tpLine = [SCILineAnnotation new];

    
        [self setX1:@(xIndex - 1)];
        [self setX2:@(xIndex + 1)];

        double minY = MIN(MIN(stopLoss, takeProfit), entry) - 10;
        double maxY = MAX(MAX(stopLoss, takeProfit), entry) + 10;

        [self setY1:@(minY)];
        [self setY2:@(maxY)];

        self.isEditable = YES;
        self.fillBrush =
        [[SCISolidBrushStyle alloc] initWithColor:[[SCIColor grayColor] colorWithAlphaComponent:0.4]];

        double y1Point = [self y1].toDouble;
        double y2Point = [self y2].toDouble;

        [_entryIcon setX1:@0.5];
        _entryIcon.coordinateMode = SCIAnnotationCoordinateMode_Relative;

        double entryNorm = (entry - y1Point) / (y2Point - y1Point);

        [_entryIcon setY1:@(entryNorm)];

        NSString *imageName = isBuy ? @"image.arrow.green" : @"image.arrow.red";

        _entryIcon.image = [SCIImage imageNamed:imageName];
        _entryIcon.desiredSize = CGSizeMake(26, 26);

        _slLine.coordinateMode = SCIAnnotationCoordinateMode_Relative;

        [_slLine setX1:@0.0];
        [_slLine setX2:@1.0];

        double slNorm = (stopLoss - y1Point) / (y2Point - y1Point);

        [_slLine setY1:@(slNorm)];
        [_slLine setY2:@(slNorm)];

        _slLine.stroke =
        [[SCISolidPenStyle alloc] initWithColor:SCIColor.redColor
                                      thickness:2];

        _tpLine.coordinateMode = SCIAnnotationCoordinateMode_Relative;

        [_tpLine setX1:@0.0];
        [_tpLine setX2:@1.0];

        double tpNorm = (takeProfit - y1Point) / (y2Point - y1Point);

        [_tpLine setY1:@(tpNorm)];
        [_tpLine setY2:@(tpNorm)];

        _tpLine.stroke =
        [[SCISolidPenStyle alloc] initWithColor:SCIColor.greenColor
                                      thickness:2];

        double pnl = fabs(takeProfit - entry);
        double risk = fabs(entry - stopLoss);
        double rr = risk == 0 ? 0 : pnl / risk;

        NSString *text =
        isBuy
        ? [NSString stringWithFormat:@"LONG\nR:R %.2f", rr]
        : [NSString stringWithFormat:@"SHORT\nR:R %.2f", rr];

        TradeInfoView *view = [[TradeInfoView alloc] initWithText:text];

        _infoView.coordinateMode = SCIAnnotationCoordinateMode_Relative;
        _infoView.customView = view;

        [_infoView setX1:@0.5];
        [_infoView setY1:@1.0];

        self.annotations =
        [[SCIAnnotationCollection alloc] initWithCollection:@[
            _slLine,
            _tpLine,
            _entryIcon,
            _infoView
        ]];
    }

    return self;
}

@end
