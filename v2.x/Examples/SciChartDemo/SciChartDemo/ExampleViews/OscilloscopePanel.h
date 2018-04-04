//
//  OscilloscopePanel.h
//  SciChartDemo
//
//  Created by Yaroslav Pelyukh on 4/18/17.
//  Copyright © 2017 ABT. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^Callback)(UIButton *sender);

@interface OscilloscopePanel : UIView

@property (nonatomic, copy) Callback seriesTypeTouched;
@property (nonatomic, copy) Callback rotateTouched;
@property (nonatomic, copy) Callback flippedVerticallyTouched;
@property (nonatomic, copy) Callback flippedHorizontallyTouched;

@end
