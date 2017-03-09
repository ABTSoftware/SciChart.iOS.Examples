//
//  InterpolationTurnOnOff.h
//  SciChartDemo
//
//  Created by Yaroslav Pelyukh on 7/18/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^Callback)(void);

@interface InterpolationTurnOnOff : UIView

@property (nonatomic, copy) Callback onUseInterpolationClicked;

@end
