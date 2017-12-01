//
//  DrawOnAxisModifier.h
//  SciChart_Boilerplate_ObjC
//
//  Created by Admin on 09/06/2017.
//  Copyright © 2017 SciChart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SciChart/SciChart.h>

@interface DrawOnAxisModifier : SCIChartModifierBase

@property (nonatomic) NSArray * axesId;

@property (nonatomic) id<SCIPenStyleProtocol> lineStyle;

@end
