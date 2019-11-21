//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SurfaceMeshMetaDataProvider3D.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SurfaceMeshMetaDataProvider3D.h"
#import "SCDDataManager.h"

@implementation SurfaceMeshMetaDataProvider3D

- (instancetype)init {
    return [super initWithRenderableSeriesType:SCISurfaceMeshRenderableSeries3D.class];
}

- (void)updateMeshColors:(SCIUnsignedIntegerValues *)cellColors {
    SCISurfaceMeshRenderPassData3D *currentRenderPassData = (SCISurfaceMeshRenderPassData3D *)self.renderableSeries.currentRenderPassData;
    
    NSInteger countX = currentRenderPassData.countX - 1;
    NSInteger countZ = currentRenderPassData.countZ - 1;
    
    cellColors.count = currentRenderPassData.pointsCount;
    
    unsigned int *items = cellColors.itemsArray;
    for (int x = 0; x < countX; ++x) {
        for (int z = 0; z < countZ; ++z) {
            NSInteger index = x * countZ + z;
            unsigned int color;
            if  ((x >= 20 && x <= 26 && z > 0 && z < 47) || (z >= 20 && z <= 26 && x > 0 && x < 47)) {
                color = 0x00FFFFFF;
            } else {
                color = SCDDataManager.randomColor;
            }
            items[index] = color;
        }
    }
}

@end
