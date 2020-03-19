//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDProgressBarStyle.h is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SCDProgressBarStyle : NSObject

@property (nonatomic) BOOL isVertical;
@property (nonatomic) NSInteger max;
@property (nonatomic) NSInteger spacing;
@property (nonatomic) NSInteger barSize;
@property (strong, nonatomic) UIColor *progressBackgroundColor;
@property (strong, nonatomic) UIColor *progressColor;

- (instancetype)initWithIsVertical:(BOOL)isVertical max:(NSInteger)max spacing:(NSInteger)spacing progressBackgroundColor:(UIColor *)progressBackgroundColor progressColor:(UIColor *)progressColor barSize:(NSInteger)barSize;

@end

NS_ASSUME_NONNULL_END
