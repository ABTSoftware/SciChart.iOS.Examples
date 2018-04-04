//
//  CustomModifierLayout.h
//  SciChartDemo
//
//  Created by admin on 3/16/18.
//  Copyright © 2018 ABT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SciChart/SciChart.h>
#import "ExampleViewBase.h"

typedef void(^CustomModifierControlPanelCallback)(void);

@interface CustomModifierLayout : ExampleViewBase

@property (nonatomic, copy) CustomModifierControlPanelCallback onNextClicked;
@property (nonatomic, copy) CustomModifierControlPanelCallback onPrevClicked;
@property (nonatomic, copy) CustomModifierControlPanelCallback onClearClicked;

@property (weak, nonatomic) IBOutlet UILabel * infoLabel;
@property (weak, nonatomic) IBOutlet SCIChartSurface * surface;

@end
