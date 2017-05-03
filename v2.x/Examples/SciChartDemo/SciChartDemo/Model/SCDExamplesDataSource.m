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
        
        NSArray *categoriesName = [categories allKeys];
        
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
            
            [dataSource setValue:categoryPreparedItems forKey:categoryName];
            
        }
        
        self.chartCategories = [NSArray arrayWithArray:categoriesName];
        
        self.examples2D = [[NSDictionary alloc] initWithDictionary:dataSource];

    }
    
    return self;
}

@end
