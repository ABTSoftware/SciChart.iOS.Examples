//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDSearchExampleUtil.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SCDSearchExampleUtil.h"
#import <SciChart.Examples/SCDExampleItem.h> 

@implementation SCDSearchExampleUtil

+ (NSArray *)getFilteredContentForSearchText:(NSString *)searchText scope:(NSString *)scope dataSource:(SCDExamplesDataSource *)dataSource {
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"title contains[c] %@", searchText];
    
    NSMutableArray *result = [NSMutableArray new];
    for (id key in dataSource.examples) {
        NSMutableArray<SCDExampleItem *> *item = [dataSource.examples valueForKey:key];
        NSArray *filteredCategory = [item filteredArrayUsingPredicate:resultPredicate];
        [result addObjectsFromArray:filteredCategory];
    }
    return result;
}

@end
