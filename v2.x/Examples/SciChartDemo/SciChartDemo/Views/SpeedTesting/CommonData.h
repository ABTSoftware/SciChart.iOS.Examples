//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// CommonData.h is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

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
