//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// FifoScrollingPanel.h is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import <UIKit/UIKit.h>

typedef void(^FifoPanelCallback)();

@interface FifoScrollingPanel : UIView

@property (nonatomic, copy) FifoPanelCallback playCallback;
@property (nonatomic, copy) FifoPanelCallback pauseCallback;
@property (nonatomic, copy) FifoPanelCallback stopCallback;

- (IBAction)playPressed:(UIButton *)sender;
- (IBAction)pausePressed:(UIButton *)sender;
- (IBAction)stopPressed:(UIButton *)sender;

@end
