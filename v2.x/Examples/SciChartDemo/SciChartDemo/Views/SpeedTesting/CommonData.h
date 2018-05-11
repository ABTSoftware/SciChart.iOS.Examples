//
//  CommonData.h
//  ComparisonApp
//
//  Created by Yaroslav Pelyukh on 4/13/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(int, ResamplingMode){
    None,
    MinMax,
    Mid,
    Max,
    Min,
    Nyquist,
    Cluster2D,
    MinMaxWithUnevenSpacing,
    Auto
};

typedef struct {
    enum ResamplingMode ResamplingMode;
    int PointCount;
    int SeriesNumber;
    int StrokeThikness;
    int AppendPoints;
    double Duration;
    double TimeScale;
} TestParameters;
