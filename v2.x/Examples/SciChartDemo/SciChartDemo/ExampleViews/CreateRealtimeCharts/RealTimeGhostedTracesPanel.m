//
//  RealTimeGhostedTracesPanel.m
//  SciChartDemo
//
//  Created by Yaroslav Pelyukh on 4/30/17.
//  Copyright © 2017 ABT. All rights reserved.
//

#import "RealTimeGhostedTracesPanel.h"

@implementation RealTimeGhostedTracesPanel

- (IBAction)sliderChangedValue:(UISlider *)sender {
    self.msTextLabel.text = [NSString stringWithFormat:@"%.0f ms", sender.value];
    
    if (self.speedChanged) {
        self.speedChanged(sender);
    }
}

@end
