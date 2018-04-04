//
//  SideMenuViewController.h
//  SciChartDemo
//
//  Created by Yaroslav Pelyukh on 3/3/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SCIChartSurface;

@interface SideMenuViewController : UITableViewController <UISearchDisplayDelegate>

@property SCIChartSurface *scichartSurface;
@property (nonatomic, strong) NSArray *menuItems;

@end
