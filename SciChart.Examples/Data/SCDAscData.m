//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDAscData.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SCDAscData.h"

@implementation SCDAscData

- (instancetype)initWithRawData:(NSArray<NSString *> *)rawData {
    self = [super init];
    if (self) {
        int currentRow = 0;
        
        // Load the ASC file format
        _numberColumns = [self p_SCD_readIntWithPrefix:@"ncols" fromString:rawData[currentRow++]];
        _numberRows = [self p_SCD_readIntWithPrefix:@"nrows" fromString:rawData[currentRow++]];
        _xllCorner = [self p_SCD_readIntWithPrefix:@"xllcorner" fromString:rawData[currentRow++]];
        _yllCorner = [self p_SCD_readIntWithPrefix:@"yllcorner" fromString:rawData[currentRow++]];
        _cellSize = [self p_SCD_readIntWithPrefix:@"cellsize" fromString:rawData[currentRow++]];
        _noDataValue = [self p_SCD_readIntWithPrefix:@"NODATA_value" fromString:rawData[currentRow++]];
        
        _xValues = [[SCIIntegerValues alloc] initWithCapacity:_numberRows * _numberColumns];
        _yValues = [[SCIDoubleValues alloc] initWithCapacity:_numberRows * _numberColumns];
        _zValues = [[SCIIntegerValues alloc] initWithCapacity:_numberRows * _numberColumns];
        
        for (int i = 0; i < _numberRows; i++, currentRow++) {
            NSArray<NSString *> *heightValuesRow = [rawData[currentRow] componentsSeparatedByString:@" "];
            
            for (int j = 0; j < _numberColumns; j++) {
                double heightValue = [heightValuesRow[j] doubleValue];
                if (heightValue == _noDataValue) {
                    heightValue = NAN;
                }
                
                [_xValues add:j * _cellSize];
                [_yValues add:heightValue];
                [_zValues add:i * _cellSize];
            }
        }
    }
    return self;
}

- (int)p_SCD_readIntWithPrefix:(NSString *)prefix fromString:(NSString *)string {
    string = [string stringByReplacingOccurrencesOfString:prefix withString:@""];
    string = [string stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceCharacterSet];
    
    return string.intValue;
}

- (SCIXyzDataSeries3D *)createXyzDataSeries {
    SCIXyzDataSeries3D *dataSeries = [[SCIXyzDataSeries3D alloc] initWithXType:SCIDataType_Int yType:SCIDataType_Double zType:SCIDataType_Int];
    
    if (_colorValues == nil || _colorValues.count == 0) {
        [dataSeries appendXValues:_xValues yValues:_yValues zValues:_zValues];
    } else {
        //        xyzDataSeries3D.Append(lidarData.XValues, lidarData.YValues, lidarData.ZValues, lidarData.ColorValues.Select(x => new PointMetadata3D(x)));
    }
    
    return dataSeries;
}

- (SCIUniformGridDataSeries3D *)createUniformGridDataSeries {
    SCIUniformGridDataSeries3D *dataSeries = [[SCIUniformGridDataSeries3D alloc] initWithXType:SCIDataType_Int yType:SCIDataType_Double zType:SCIDataType_Int xSize:_numberColumns zSize:_numberRows];
    dataSeries.stepX = @(_cellSize);
    dataSeries.stepZ = @(_cellSize);
    
    int index = 0;
    for (int z = 0; z < _numberRows; z++) {
        for (int x = 0; x < _numberColumns; x++) {
            [dataSeries updateYValue:@([_yValues getValueAt:index++]) atXIndex:x zIndex:z];
        }
    }
    
    return dataSeries;
}

- (SCIPointMetadataProvider3D *)createMetadataProviderWithColorMap:(SCIColorMap *)colorMap withinMin:(float)min andMax:(float)max {
    SCIPointMetadataProvider3D *metadataProvider = [[SCIPointMetadataProvider3D alloc] init];
    
    float diff = max - min;
    for (NSInteger i = 0, count = _yValues.count; i < count; i++) {
        SCIColor *color = [colorMap lerpColorForValue:[_yValues getValueAt:i] / diff];
        [metadataProvider.metadata addObject:[[SCIPointMetadata3D alloc] initWithVertexColor:color.colorARGBCode andScale:1]];
    }
    
    return metadataProvider;
}

@end
