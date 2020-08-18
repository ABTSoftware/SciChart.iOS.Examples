//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDSectionsModel.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SCDSectionsModel.h"

@implementation SCDSectionsModel

- (NSUInteger)countOfItems {
    NSUInteger totalCount = self.examplesArray.count;
    for (NSArray *array in self.examplesArray) {
        totalCount += array.count;
    }
    
    return totalCount;
}

- (id)itemAtIndex:(NSUInteger)index {
    NSUInteger indexInArray;
    NSMutableArray *currentArray;
    
    currentArray = [self p_SCD_arrayAtIndex:index indexInArray:&indexInArray];
    if (currentArray == nil) {
        return self.sectionTitles[indexInArray];
    }
    return currentArray[indexInArray];
}

- (NSUInteger)indexOfItem:(SCDExampleItem *)item {
    if (!item) return -1;

    NSUInteger itemIndex = 0;
    
    for (NSUInteger i = 0; i < self.examplesArray.count; i++) {
        itemIndex += 1;
        
        NSArray *sectionArray = self.examplesArray[i];
        for (NSUInteger j = 0; j < sectionArray.count; j++) {
            
            SCDExampleItem *itemInArray = sectionArray[j];
            if (itemInArray.fileName == item.fileName) {
                return itemIndex;
            }
            itemIndex += 1;
        }
    }
    
    return -1;
}

- (NSMutableArray *)p_SCD_arrayAtIndex:(NSUInteger)index indexInArray:(NSUInteger *)indexInArray {
    NSUInteger arrayIdx = 0;
    NSMutableArray *currentArray = self.examplesArray[arrayIdx];
    
    if (index == 0) {
        *indexInArray = 0;
        return nil;
    }
    
    index -= 1;
    
    while (index >= currentArray.count) {
        index -= (currentArray.count);
        arrayIdx += 1;
        if (index == 0) {
            *indexInArray = arrayIdx;
            return nil;
        }
        
        index -= 1;
        currentArray = self.examplesArray[arrayIdx];
        if (arrayIdx + 1 >= self.examplesArray.count) {
            break;
        }
    }
    *indexInArray = index;
    
    return currentArray;
}


@end
