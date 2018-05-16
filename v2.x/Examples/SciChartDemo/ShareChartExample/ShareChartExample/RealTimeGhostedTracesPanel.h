//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// RealTimeGhostedTracesPanel.h is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import <UIKit/UIKit.h>

typedef void(^Callback)(UISlider *sender);

@interface RealTimeGhostedTracesPanel : UIView

@property (nonatomic, copy) Callback speedChanged;

@property (weak, nonatomic) IBOutlet UILabel *msTextLabel;
- (IBAction)sliderChangedValue:(UISlider *)sender;

@end
