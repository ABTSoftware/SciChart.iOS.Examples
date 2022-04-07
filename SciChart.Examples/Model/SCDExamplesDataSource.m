//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDExamplesDataSource.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SCDExamplesDataSource.h"
#import "SCDExampleItem.h"
#import "SCDConstants.h"

static NSString *keyCategories = @"Categories";
static NSString *keyExampleName = @"Title";
static NSString *keyExampleIcon = @"IconName";
static NSString *keyExampleDescription = @"Description";
static NSString *keyExampleFile = @"FileName";
static NSString *keyIsSwiftOnly = @"IsSwiftOnly";

static BOOL isSwift = YES;

@implementation SCDExamplesDataSource {
    NSString *_examplesPlistFileName;
    NSArray *_categoriesName;
    NSDictionary *_categories;
}

- (BOOL)isSwift {
    return isSwift;
}

- (instancetype)initWithPlistFileName:(NSString *)examplesPlistFileName {
    self = [super init];
    if (self) {
        _examplesPlistFileName = examplesPlistFileName;
        
        NSBundle *examplesBundle = [NSBundle bundleWithIdentifier:ExamplesBundleId];
        NSDictionary *plistDataSource = [[NSDictionary alloc] initWithContentsOfFile:[examplesBundle pathForResource:_examplesPlistFileName ofType:@"plist"]];
        _categories = [plistDataSource valueForKey:keyCategories];
        
        _categoriesName = [[_categories allKeys] sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
            NSRange range1 = [obj1 rangeOfString:@"\\[([0-9]*?)\\]" options:NSRegularExpressionSearch];
            NSRange range2 = [obj2 rangeOfString:@"\\[([0-9]*?)\\]" options:NSRegularExpressionSearch];
            
            if ([obj1 substringWithRange:NSMakeRange(range1.location + 1, range1.length - 2)].intValue == [obj2 substringWithRange:NSMakeRange(range2.location + 1, range2.length - 2)].intValue) {
                return NSOrderedSame;
            } else if ([obj1 substringWithRange:NSMakeRange(range1.location + 1, range1.length - 2)].intValue < [obj2 substringWithRange:NSMakeRange(range2.location + 1, range2.length - 2)].intValue) {
                [obj1 stringByReplacingCharactersInRange:range1 withString:@""];
                [obj2 stringByReplacingCharactersInRange:range2 withString:@""];
                return NSOrderedAscending;
            } else {
                [obj1 stringByReplacingCharactersInRange:range1 withString:@""];
                [obj2 stringByReplacingCharactersInRange:range2 withString:@""];
                return NSOrderedDescending;
            }
        }];
        
        [self fillExamples];
    }
    
    return self;
}

- (void)toggleSwift {
    isSwift = !isSwift;
    [self fillExamples];
}

- (void)fillExamples {
    NSMutableArray *categoryNamesWithoutNumber = [[NSMutableArray alloc] initWithCapacity:_categoriesName.count];
    for (NSString *categoryName in _categoriesName) {
        NSRange range1 = [categoryName rangeOfString:@"\\[([0-9]*?)\\]" options:NSRegularExpressionSearch];
        [categoryNamesWithoutNumber addObject:[categoryName stringByReplacingCharactersInRange:range1 withString:@""]];
    }
    
    NSMutableArray *examples = [NSMutableArray new];
    NSMutableDictionary *dataSource = [NSMutableDictionary new];
    for (NSString *categoryName in _categoriesName) {
        NSArray *categoryItems = _categories[categoryName];
        
        NSMutableArray *categoryPreparedItems = [[NSMutableArray alloc] initWithCapacity:categoryItems.count];
        for (NSDictionary *itemExample in categoryItems) {
            NSString *file = itemExample[keyExampleFile];
            if (file != nil && file.length > 0) {
                NSString *name = itemExample[keyExampleName];
                NSString *desc = itemExample[keyExampleDescription];
                NSString *icon = itemExample[keyExampleIcon];
                BOOL isSwiftOnly = [itemExample[keyIsSwiftOnly] boolValue];
                
                SCDExampleItem *example = [[SCDExampleItem alloc] initWithName:name description:desc exampleIcon:icon fileName:file isSwiftOnly:isSwiftOnly];
                [categoryPreparedItems addObject:example];
                [examples addObject:example];
            }
        }
        
        if (!isSwift) {
            NSPredicate *hasBothExamplesPredicate = [NSPredicate predicateWithFormat:@"isSwiftOnly == NO"];
            categoryPreparedItems = (NSMutableArray *)[categoryPreparedItems filteredArrayUsingPredicate:hasBothExamplesPredicate];
        }
        
        [dataSource setValue:[categoryPreparedItems sortedArrayUsingComparator:^NSComparisonResult(SCDExampleItem *a, SCDExampleItem *b) {
            return [a.title compare:b.title];
        }] forKey:categoryNamesWithoutNumber[[_categoriesName indexOfObject:categoryName]]];
    }
    
    self.chartCategories = [NSArray arrayWithArray:categoryNamesWithoutNumber];
    self.examples = [[NSDictionary alloc] initWithDictionary:dataSource];
    self.allExamples = [NSArray arrayWithArray:examples];
}

- (SCDExampleBaseViewController *)createViewControllerForExample:(SCDExampleItem *)example {
    NSBundle *examplesBundle = [NSBundle bundleWithIdentifier:ExamplesBundleId];
    NSString *namespace = [examplesBundle.infoDictionary[@"CFBundleExecutable"] stringByReplacingOccurrencesOfString:@"." withString:@"_"];
    // If swift - create swift example view, otherwise - Obj-C
    NSString *className = isSwift ? [NSString stringWithFormat:@"%@.%@", namespace, example.fileName] : example.fileName;

    SCDExampleBaseViewController *exampleViewController = [NSClassFromString(className) new];
    exampleViewController.title = example.title;

    return exampleViewController;
}

@end
