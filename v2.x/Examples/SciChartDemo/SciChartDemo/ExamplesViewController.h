//
//  ExampleUIViewController.h
//  SciChartDemo
//
//  Created by Yaroslav Pelyukh on 08.03.16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SideBarView.h"
#import "SciChartBaseViewProtocol.h"
#import "SCDExampleItem.h"

@interface ExamplesViewController : UIViewController

@property(nonatomic) SCDExampleItem * example;
@property(nonatomic, retain) IBOutlet SideBarView * menubarViewFromNib;

@end
