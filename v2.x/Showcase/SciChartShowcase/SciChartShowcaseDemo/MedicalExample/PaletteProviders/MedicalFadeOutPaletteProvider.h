//
//  MedicalFadeOutPaletteProvider.h
//  SciChartShowcaseDemo
//
//  Created by Admin on 03/03/17.
//  Copyright © 2017 SciChart Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SciChart/SciChart.h>

@interface MedicalFadeOutPaletteProvider : SCIPaletteProvider

-(instancetype)initWithSeriesColor:(UIColor*)color Stroke:(float)stroke;

@end
