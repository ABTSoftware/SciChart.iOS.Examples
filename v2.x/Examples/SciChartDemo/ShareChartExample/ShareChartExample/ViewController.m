//
//  ViewController.m
//  ShareChartExample
//
//  Created by Admin on 5/26/16.
//  Copyright © 2016 Admin. All rights reserved.
//

#import "ViewController.h"
#import "ChartView.h"

@interface ViewController () <UIAlertViewDelegate>

@end

@implementation ViewController {

}

- (void)viewDidLoad {
    [super viewDidLoad];
    ChartView *chartView = [[ChartView alloc] initWithFrame:self.view.bounds];
    chartView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    chartView.translatesAutoresizingMaskIntoConstraints = YES;
    [self.view addSubview:chartView];
}

@end
