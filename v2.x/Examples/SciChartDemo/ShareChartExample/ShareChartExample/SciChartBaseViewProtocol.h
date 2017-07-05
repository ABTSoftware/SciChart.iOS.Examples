//
//  SciChartBaseViewProtocol.h
//  SciChartDemo
//
//  Created by Yaroslav Pelyukh on 04.05.16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SCIChartSurface;

@protocol SciChartBaseViewProtocol <NSObject>

@property (nonatomic, strong) SCIChartSurface * surface;

@end
