//
//  SCDExamplesDataSource.m
//  SciChartDemo
//
//  Created by Mykola Hrybeniuk on 7/4/16.
//  Copyright © 2016 ABT. All rights reserved.
//

#import "SCDExamplesDataSource.h"
#import "SCDExampleItem.h"

static NSString *plistFileName = @"ExampleListDataSource";
static NSString *keyCategories = @"Categories";
static NSString *keyExampleName = @"exampleName";
static NSString *keyExampleIcon = @"exampleIcon";
static NSString *keyExampleDescription = @"exampleDescription";
static NSString *keyExampleFile = @"exampleFile";

@implementation SCDExamplesDataSource

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        
        NSDictionary *plistDataSource = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:plistFileName ofType:@"plist"]];
        
        NSDictionary *categories = [plistDataSource valueForKey:keyCategories];
        
        NSArray *categoriesName = [[categories allKeys] sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
            
            NSRange range1 = [obj1 rangeOfString:@"\\[([0-9]*?)\\]" options:NSRegularExpressionSearch];
            NSRange range2 = [obj2 rangeOfString:@"\\[([0-9]*?)\\]" options:NSRegularExpressionSearch];
            
            
            
            if ([[obj1 substringWithRange:NSMakeRange(range1.location+1, range1.length-2)] intValue] == [[obj2 substringWithRange:NSMakeRange(range2.location+1, range2.length-2)] intValue]) {

                return NSOrderedSame;
            }
            
            else if ([[obj1 substringWithRange:NSMakeRange(range1.location+1, range1.length-2)] intValue] < [[obj2 substringWithRange:NSMakeRange(range2.location+1, range2.length-2)] intValue]) {
                [obj1 stringByReplacingCharactersInRange:range1 withString:@""];
                [obj2 stringByReplacingCharactersInRange:range2 withString:@""];
                return NSOrderedAscending;
            }
            else {
                [obj1 stringByReplacingCharactersInRange:range1 withString:@""];
                [obj2 stringByReplacingCharactersInRange:range2 withString:@""];
                return NSOrderedDescending;
            }
            
        }];
        
        NSMutableArray *categoryNamesWithoutNumber = [[NSMutableArray alloc] initWithCapacity:categoriesName.count];
        
        for (NSString *categoryName in categoriesName) {
            NSRange range1 = [categoryName rangeOfString:@"\\[([0-9]*?)\\]" options:NSRegularExpressionSearch];
            [categoryNamesWithoutNumber addObject:[categoryName stringByReplacingCharactersInRange:range1 withString:@""]];
        }
        
        NSMutableDictionary *dataSource = [[NSMutableDictionary alloc] init];
        
        for (NSString *categoryName in categoriesName) {
            
            
            NSArray *categoryItems = categories[categoryName];
            
            NSMutableArray *categoryPreparedItems = [[NSMutableArray alloc] initWithCapacity:categoryItems.count];
            
            for (NSDictionary *itemExample in categoryItems) {
                if (itemExample[keyExampleFile] && [itemExample[keyExampleFile] length] > 0) {
                    [categoryPreparedItems addObject:[[SCDExampleItem alloc] initWithExampleName:itemExample[keyExampleName]
                                                                              exampleDescription:itemExample[keyExampleDescription]
                                                                                     exampleIcon:itemExample[keyExampleIcon]
                                                                                     exampleFile:itemExample[keyExampleFile]]];
                }
            }
            
            [dataSource setValue:categoryPreparedItems forKey:categoryNamesWithoutNumber[[categoriesName indexOfObject:categoryName]]];
            
        }
        
        self.chartCategories = [NSArray arrayWithArray:categoryNamesWithoutNumber];
        
        self.examples2D = [[NSDictionary alloc] initWithDictionary:dataSource];

    }
    
    return self;
}

@end
