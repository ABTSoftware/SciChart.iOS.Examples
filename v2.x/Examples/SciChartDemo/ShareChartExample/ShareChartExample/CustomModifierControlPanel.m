//
//  CustomModifierControlPanel.m
//  SciChartDemo
//
//  Created by Admin on 29/08/16.
//  Copyright © 2016 ABT. All rights reserved.
//

#import "CustomModifierControlPanel.h"

@interface CustomModifierControlPanel()

@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@end

@implementation CustomModifierControlPanel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)setText:(NSString *)text {
    _infoLabel.text = [text copy];
}

- (IBAction)prevButtonClick:(id)sender {
    if (_onPrevClicked) _onPrevClicked();
}

- (IBAction)nextButtonClick:(id)sender {
    if (_onNextClicked) _onNextClicked();
}

- (IBAction)clearButtonClick:(id)sender {
    if (_onClearClicked) _onClearClicked();
}

@end
