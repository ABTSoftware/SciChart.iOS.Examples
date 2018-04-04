//
//  ModifierTableViewController.h
//  SciChartDemo
//
//  Created by Yaroslav Pelyukh on 5/19/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SciChart/SciChart.h>


@interface ModifierTableViewController : UITableViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *modifiers;
@property (nonatomic, strong) SCIChartSurface * sciSurface;

@end
