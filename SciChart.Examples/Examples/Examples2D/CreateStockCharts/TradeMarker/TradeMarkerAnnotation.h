//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2025. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// TrandAnnotation.h is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************


#import <SciChart/SciChart.h>

@class TradeMarkerAnnotation;

@protocol TradeAnnotationDelegate <NSObject>
- (void)didTradeAnnotationTapped:(nonnull TradeMarkerAnnotation *)annotation
                         atPoint:(CGPoint)point;
@end

@interface TradeMarkerAnnotation : SCICustomAnnotation

@property (nonatomic, weak, nullable) id<TradeAnnotationDelegate> delegate;
@property (nonatomic, nullable) NSMutableArray *userInfo;
@property (nonatomic) BOOL hasLabel;


- (nonnull instancetype)initWithIndex:(NSDate *_Nonnull)index
                                isBuy:(BOOL)isBuy
                                yPoint:(double)yPoint
                                price:(double)price;

@end
