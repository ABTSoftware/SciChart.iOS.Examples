//
//  RealTimeGhostedTracesPanel.h
//  SciChartDemo
//
//  Created by Yaroslav Pelyukh on 4/30/17.
//  Copyright © 2017 ABT. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^Callback)(UISlider *sender);

@interface RealTimeGhostedTracesPanel : UIView

@property (nonatomic, copy) Callback speedChanged;

@property (weak, nonatomic) IBOutlet UILabel *msTextLabel;
- (IBAction)sliderChangedValue:(UISlider *)sender;

@end
