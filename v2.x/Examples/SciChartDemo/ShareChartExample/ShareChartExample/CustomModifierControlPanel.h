//
//  CustomModifierControlPanel.h
//  SciChartDemo
//
//  Created by Admin on 29/08/16.
//  Copyright © 2016 ABT. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CustomModifierControlPanelCallback)(void);

@interface CustomModifierControlPanel : UIView

-(void) setText:(NSString*)text;

@property (nonatomic, copy) CustomModifierControlPanelCallback onNextClicked;
@property (nonatomic, copy) CustomModifierControlPanelCallback onPrevClicked;
@property (nonatomic, copy) CustomModifierControlPanelCallback onClearClicked;

@end
