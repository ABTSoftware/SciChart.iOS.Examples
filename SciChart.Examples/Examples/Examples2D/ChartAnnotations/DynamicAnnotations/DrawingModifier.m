//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2025. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// DrawingModifier.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

/*
 NOTE:
 -----
 This example demonstrates how different gestures (tap, long-press, pan, etc.)
 can be mapped to different functionalities such as:

    • Adding markers using tap
    • Drawing lines/boxes using drag
    • Removing markers using long-press → delete mode (iOS)
    • Removing markers using right-click (macOS)

These are *only sample implementations*.
You can implement delete, edit, or annotation manipulation in many other ways.
Feel free to customize the gestures to fit your app.
*/

#import "DrawingModifier.h"

@interface DrawingModifier () {
    double _startX;
    double _startY;
    
    SCITapGestureRecognizer  *deleteTap;
}

@property (strong, nonatomic) SCILineAnnotation *line;
@property (strong, nonatomic) SCIBoxAnnotation *box;

@property (nonatomic) BOOL isDeleteMode;
@property (strong, nonatomic) NSMutableArray *arrDeleteButtons;


@end


@implementation DrawingModifier

- (instancetype)initWithSurface:(SCIChartSurface *)surface
                       drawMode:(DrawMode)drawMode
                 ohlcDataSeries:(SCIOhlcDataSeries *)ohlcDataSeries {
    
    if (self) {
        _surface = surface;
        _drawMode = drawMode;
        _ohlcDataSeries = ohlcDataSeries;
#if TARGET_OS_OSX
        _isEditMode = NO;
#endif
        _arrDeleteButtons = [[NSMutableArray alloc] init];
    }
    
    self = [super init];
    
    // Tap → delete annotation
    deleteTap = [[SCITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDeleteTap:)];
    
#if TARGET_OS_IOS
    // Long press recognizer
    UILongPressGestureRecognizer *longPress =
        [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                      action:@selector(handleLongPress:)];
    [self.surface addGestureRecognizer:longPress];
    
    [deleteTap setEnabled:NO]; // enabled only in delete mode
#else
    [deleteTap setEnabled:YES];
    deleteTap.buttonMask = 2; // right-click on macOS
#endif
    [self.surface addGestureRecognizer:deleteTap];
    return self;
}

#pragma mark - Gesture Recognizers

- (SCIGestureRecognizer *)createGestureRecognizer {
    if (self.drawMode == DrawMode_Markers) {
        
        // Base recognizer
        SCITapGestureRecognizer *recognizer = [[SCITapGestureRecognizer alloc] init];//WithTarget:self action:@selector(handleTap:)];
#if TARGET_OS_IOS
        if (deleteTap != nil) {
            [recognizer requireGestureRecognizerToFail:deleteTap];
        }
#endif
        return recognizer;
    }
    else {
        SCIPanGestureRecognizer *recognizer = [[SCIPanGestureRecognizer alloc] init];
        return recognizer;
    }
}

#if TARGET_OS_OSX

- (BOOL)gestureRecognizer:(NSGestureRecognizer *)gestureRecognizer
shouldAttemptToRecognizeWithEvent:(NSEvent *)event
{
    if (self.isEditMode) {
        return NO;
    }
    return YES;
}

#endif

#pragma mark - Gesture Begin

- (void)onGestureBeganWithArgs:(SCIGestureModifierEventArgs *)args {
    SCIGestureRecognizer *gesture = args.gestureRecognizer;
    if (!gesture) return;

    CGPoint pt = [gesture locationInView:self.surface];

    double dataX = [self dataXFromPoint:pt];
    double dataY = [self dataYFromPoint:pt];

    _startX = dataX;
    _startY = dataY;

    switch (self.drawMode) {

        case DrawMode_Line: {
            SCILineAnnotation *lineAnnotation = [SCILineAnnotation new];
            lineAnnotation.isEditable = YES;
            [lineAnnotation setX1:@(dataX)];
            [lineAnnotation setY1:@(dataY)];
            [lineAnnotation setX2:@(dataX)];
            [lineAnnotation setY2:@(dataY)];
            lineAnnotation.stroke = [[SCISolidPenStyle alloc] initWithColorCode:0xFFF7F736 thickness:2];
            
#if TARGET_OS_OSX
            lineAnnotation.annotationSelectionChangedListener = ^(id<ISCIAnnotation> annotation, BOOL isSelected) {
                if (isSelected) {
                    self.isEditMode = YES;
                } else {
                    self.isEditMode = NO;
                }
            };
#endif
            
            [self.surface.annotations add:lineAnnotation];
            self.line = lineAnnotation;
        } break;

        case DrawMode_Box: {
            SCIBoxAnnotation *boxAnnotation = [SCIBoxAnnotation new];
            boxAnnotation.isEditable = YES;
            [boxAnnotation setX1:@(dataX)];
            [boxAnnotation setY1:@(dataY)];
            [boxAnnotation setX2:@(dataX)];
            [boxAnnotation setY2:@(dataY)];
            boxAnnotation.fillBrush = [[SCISolidBrushStyle alloc] initWithColorCode:0x88F7F736];
#if TARGET_OS_OSX
            boxAnnotation.annotationSelectionChangedListener = ^(id<ISCIAnnotation> annotation, BOOL isSelected) {
                if (isSelected) {
                    self.isEditMode = YES;
                } else {
                    self.isEditMode = NO;
                }
            };
#endif
            [self.surface.annotations add:boxAnnotation];
            self.box = boxAnnotation;
        } break;

        case DrawMode_Markers:
            // handled via tap and double-tap, nothing here
            break;

        default:
            break;
    }
}

#pragma mark - Gesture Change

- (void)onGestureChangedWithArgs:(SCIGestureModifierEventArgs *)args {
    SCIGestureRecognizer *gesture = args.gestureRecognizer;
    if (!gesture) return;

    CGPoint pt = [gesture locationInView:self.surface];

    double dataX = [self dataXFromPoint:pt];
    double dataY = [self dataYFromPoint:pt];

    switch (self.drawMode) {
        case DrawMode_Line:
            [self.line setX2:@(dataX)];
            [self.line setY2:@(dataY)];
            break;

        case DrawMode_Box:
            [self.box setX2:@(dataX)];
            [self.box setY2:@(dataY)];
            break;

        default:
            break;
    }
}

#pragma mark - Gesture End

- (void)onGestureEndedWithArgs:(SCIGestureModifierEventArgs *)args {
    SCIGestureRecognizer *geture = args.gestureRecognizer;
    if (!geture) return;

    switch (self.drawMode) {

        case DrawMode_Line:
            self.line.isEditable = YES;
            self.line = nil;
            break;

        case DrawMode_Box:
            self.box.isEditable = YES;
            self.box = nil;
            break;

        case DrawMode_Markers: {
            if ([geture isKindOfClass:SCITapGestureRecognizer.class]) {
                SCITapGestureRecognizer *tap = (SCITapGestureRecognizer *)geture;
                [self handleTap:tap];
            }
        }
            break;

        default:
            break;
    }
}

#pragma mark - Tap handling

- (void)handleTap:(SCITapGestureRecognizer *)gesture {
    if (_drawMode != DrawMode_Markers || _isDeleteMode) return;
    CGPoint point = [gesture locationInView:_surface];
    [self createTradeMarker:point];
}

- (void)handleDeleteTap:(SCITapGestureRecognizer *)gesture {
    NSLog(@"Delete tap");
    CGPoint point = [gesture locationInView:self.surface];

#if TARGET_OS_OSX
    // macOS: right-click removes marker directly
    [self deleteMarkerAtPoint:point];
    return;
#else
    // If delete mode ON
    if (self.isDeleteMode) {

        // 1. Tap delete button
        NSMutableArray *arrDelete = [[NSMutableArray alloc] initWithArray:_arrDeleteButtons];
        for (NSDictionary *deleteButtons in arrDelete) {
            SCIImageAnnotation *btn = [deleteButtons valueForKey:@"button"];
            SCIImageAnnotation *marker = [deleteButtons valueForKey:@"marker"];
            if ([btn isHitAt:point]) {

                [self.surface.annotations remove:marker];
                [self.surface.annotations remove:btn];
                [arrDelete removeObject:deleteButtons];
                [_surface invalidateElement];

                if (arrDelete.count == 0) {
                    [self exitDeleteMode];
                }
                return;
            }
        }
        _arrDeleteButtons = arrDelete;
        // Tap anywhere else → exit delete mode
        [self exitDeleteMode];
        return;
    }
#endif
}

#if TARGET_OS_IOS
- (void)handleLongPress:(UILongPressGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        [self enterDeleteMode];
    }
}
#endif

#pragma mark - Marker Add

- (void)createTradeMarker:(CGPoint)pt {
    if (!_ohlcDataSeries) return;

    double dx, dy;
    dx = [self dataXFromPoint:pt];
    dy = [self dataYFromPoint:pt];

    int index = (int)MAX(0, MIN((int)dx, (int)_ohlcDataSeries.count - 1));

    double high = [_ohlcDataSeries.highValues getDoubleValueAt:index];
    double low  = [_ohlcDataSeries.lowValues getDoubleValueAt:index];

    double mid = (high + low) / 2.0;
    BOOL isUpper = dy > mid;

    BOOL isBuy = !isUpper;
    double finalY = isUpper ? high : low;

    [self addArrowAtPoint:CGPointMake(index, finalY) buy:isBuy];
}

- (void)addArrowAtPoint:(CGPoint)pt buy:(BOOL)isBuy {
    SCIImageAnnotation *arrowAnnotation = [SCIImageAnnotation new];
    [arrowAnnotation setX1:@(pt.x)];
    [arrowAnnotation setY1:@(pt.y)];
    arrowAnnotation.desiredSize = CGSizeMake(15, 15);
    arrowAnnotation.image = [SCIImage imageNamed:isBuy ? @"image.arrow.green"
                                         : @"image.arrow.red"];
    arrowAnnotation.annotationPosition = (isBuy ? (SCIAlignment_Center | SCIAlignment_Top)
                                          : (SCIAlignment_Center | SCIAlignment_Bottom));
    arrowAnnotation.isEditable = NO;

    [self.surface.annotations add:arrowAnnotation];
    [self.surface invalidateElement];
}

#pragma mark - Delete Mode (iOS)

#if TARGET_OS_IOS

- (void)enterDeleteMode {
    self.isDeleteMode = YES;
    [deleteTap setEnabled:YES];
    [self.arrDeleteButtons removeAllObjects];
    
    int count = 0;
    NSArray<id<ISCIAnnotation>> *arrAnnotation = self.surface.annotations.toArray;
    NSMutableArray<id<ISCIAnnotation>> *newButtons = [NSMutableArray array];
    
    for (id ann in arrAnnotation) {
        if ([ann isKindOfClass:[SCITextAnnotation class]]) {
            continue;
        }
        SCIAnnotationBase *marker = ann;
        
        SCIImageAnnotation *btn = [SCIImageAnnotation new];
        btn.desiredSize = CGSizeMake(15, 15);
        btn.image = [SCIImage imageNamed:@"image.delete"];
        btn.contentMode = SCIContentMode_AspectFit ;
        btn.isEditable = NO;
        btn.annotationPosition = SCIAlignment_Bottom;
        
        double x = marker.x1.toDouble;
        double y = marker.y1.toDouble;
        
        [btn setX1:@(x)];
        [btn setY1:@(y)];
        
        [newButtons addObject:btn];
        
        [_arrDeleteButtons addObject:@{@"button": btn, @"marker": marker}];
        count++;
    }
    
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        for (id ann in newButtons) {
            [self.surface.annotations add:ann];
        }
    }];

    [self.surface invalidateElement];
}

- (void)exitDeleteMode {
    self.isDeleteMode = NO;
    [deleteTap setEnabled:NO];
    
    for (NSDictionary *deleteButton in _arrDeleteButtons) {
        SCIImageAnnotation *btn = [deleteButton valueForKey:@"button"];
        [self.surface.annotations remove:btn];
    }

    [_arrDeleteButtons removeAllObjects];
    [self.surface invalidateElement];
}

#endif

#pragma mark - Delete Single Marker
- (BOOL)deleteMarkerAtPoint:(CGPoint)point {
    for (id annotation in self.surface.annotations.toArray) {
        if ([annotation isHitAt:point]) {
            [self.surface.annotations remove:annotation];
            [self.surface invalidateElement];
            return YES;
        }
    }
    return NO;
}

#pragma mark - Helpers

- (double)dataXFromPoint:(CGPoint)pt {
    return [self.xAxis.currentCoordinateCalculator getDataValueFrom:pt.x];
}

- (double)dataYFromPoint:(CGPoint)pt {
    return [self.yAxis.currentCoordinateCalculator getDataValueFrom:pt.y];
}

@end
