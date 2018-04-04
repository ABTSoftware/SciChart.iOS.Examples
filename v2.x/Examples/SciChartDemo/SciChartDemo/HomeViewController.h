//
//  SciChartTableViewController.h
//  SciChartDemo
//
//  Created by Yaroslav Pelyukh on 2/3/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCDExamplesDataSource.h"
#import "SCDSegmentSearchView.h"

@class SCDExampleItem;

@interface HomeViewController : UITableViewController<UISearchBarDelegate, UISearchResultsUpdating, SCDSegmentSearchViewDelegate>

@property (nonatomic, strong) NSArray * searchResults;
@property (nonatomic) SCDExamplesDataSource * dataSource;
@property (nonatomic) NSDictionary<NSString *, NSString *> * cachedSourceCode;
@property (nonatomic) NSUInteger searchScopeIndex;
@property (nonatomic) UISearchController * searchController;

@end
