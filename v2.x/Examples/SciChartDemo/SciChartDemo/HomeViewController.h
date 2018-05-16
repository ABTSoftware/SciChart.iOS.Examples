//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// HomeViewController.h is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

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
