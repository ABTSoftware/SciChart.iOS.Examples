//
//  SideBarViewController.h
//  SciChartDemo
//
//  Created by Yaroslav Pelyukh on 04.05.16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SciChartBaseViewProtocol.h"

typedef void(^SettingsClickHandler)(void);

@interface SideBarView : UIView

@property (nonatomic) UIView<SciChartBaseViewProtocol>* ExampleUIView;

- (void)showSettingsExampleOption:(BOOL)isShow;

@property (nonatomic, copy) SettingsClickHandler settingsClickHandler;

@end
