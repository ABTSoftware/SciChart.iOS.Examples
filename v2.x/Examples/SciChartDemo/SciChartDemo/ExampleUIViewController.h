//
//  ExampleUIViewController.h
//  SciChartDemo
//
//  Created by Yaroslav Pelyukh on 08.03.16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LineChartView.h"
#import "ColumnChartView.h"
#import "HeatmapChartView.h"
#import "BubbleChartView.h"
#import "CandlestickChartView.h"
#import "StackedMountainChartView.h"
#import "MountainChartView.h"
#import "ScatterSeriesChartView.h"
#import "BandChartView.h"
#import "ECGChartView.h"
#import "AnnotationsChartView.h"
#import "AddPointsPerformanceView.h"
#import "MultipleAxesChartView.h"
#import "DigitalBandChartView.h"
#import "SyncMultipleChartsView.h"
#import "SideBarView.h"
#import "SciChartBaseViewProtocol.h"
#import "ShowSourceCodeViewController.h"
#import "ModifierTableViewController.h"

@interface ExampleUIViewController : UIViewController

@property (nonatomic, strong) NSString* exampleName;
@property (nonatomic, strong) NSString* exampleUIViewName;
@property (nonatomic, strong) UIView<SciChartBaseViewProtocol>* exampleUIView;
@property (nonatomic, retain) IBOutlet SideBarView *menubarViewFromNib;

@end
