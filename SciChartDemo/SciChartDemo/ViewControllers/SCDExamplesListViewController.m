//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDExamplesListViewController.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SCDExamplesListViewController.h"
#import "SCDExampleViewController.h"
#import "SCDExampleListTableHeaderView.h"
#import "SCDExampleTableCell.h"
#import <SciChart.Examples/SCDConstants.h>
#import <SciChart.Examples/SCDExampleItem.h>
#import <SciChart.Examples/SCDSearchExampleUtil.h>

@interface SCDExamplesListViewController ()

@property (strong, nonatomic, readonly) UISearchController *searchController;

@end

@implementation SCDExamplesListViewController {
    NSArray *_filteredExamples;
}

@synthesize searchController = _searchController;

- (UISearchController *)searchController {
    if (_searchController == nil) {
        _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
        _searchController.searchResultsUpdater = self;
        _searchController.obscuresBackgroundDuringPresentation = NO;
        _searchController.searchBar.delegate = self;
        _searchController.searchBar.placeholder = @"Search example, source code and more";
        _searchController.searchBar.scopeButtonTitles = @[@"2D Charts", @"3D Charts", @"Featured Apps"];
    }
    return _searchController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
        
    self.tableView.separatorColor = UIColor.blackColor;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.backgroundColor = [UIColor colorNamed:@"color.tableview.background"];
    // Needed to eliminate separators between empty cells
    self.tableView.tableFooterView = [UIView new];
    
    [self.tableView registerClass:SCDExampleListTableHeaderView.class forHeaderFooterViewReuseIdentifier:SCDExampleListTableHeaderView.reuseId];
    [self.tableView registerClass:SCDExampleTableCell.class forCellReuseIdentifier:SCDExampleTableCell.reuseId];

    // The backBarButtonItem property of a navigation item reflects the back button you want displayed
    // when the current view controller is just below the topmost view controller.
    // In other words, the back button is not used when the current view controller is topmost.
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon.home"] style:UIBarButtonItemStylePlain target:self action:@selector(p_SCD_navigateHome)];
    self.navigationItem.rightBarButtonItem = [self p_SCD_getRightBarButtonWithTitle:[self p_SCD_getRightBarButtonTitle]];
    
    self.navigationItem.searchController = self.searchController;
}

- (void)p_SCD_navigateHome {
    CATransition *transition = [CATransition new];
    transition.duration = 0.25;
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [self.view.window.layer addAnimation:transition forKey:kCATransition];
    
    [self.navigationController dismissViewControllerAnimated:NO completion:nil];
}

- (void)p_SCD_toggleSwift {
    [self.dataSource toggleSwift];
    self.navigationItem.rightBarButtonItem.title = [self p_SCD_getRightBarButtonTitle];
    [self.tableView reloadData];
}

- (UIBarButtonItem *)p_SCD_getRightBarButtonWithTitle:(NSString *)title {
    return [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(p_SCD_toggleSwift)];
}

- (NSString *)p_SCD_getRightBarButtonTitle {
    return self.dataSource.isSwift ? @"Swift" : @"Obj-C";
}

// MARK: - Table View

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *reusableHeader = [tableView dequeueReusableHeaderFooterViewWithIdentifier:SCDExampleListTableHeaderView.reuseId];
    SCDExampleListTableHeaderView *header = (SCDExampleListTableHeaderView *)reusableHeader;
    
    header.label.text = [self p_SCD_isFiltering] ? @"Search results" : [self.dataSource.chartCategories objectAtIndex:section];
    
    return header;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self p_SCD_isFiltering] ? 1 : _dataSource.chartCategories.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self p_SCD_isFiltering]) {
        return _filteredExamples.count;
    }
    
    NSString *category = [self.dataSource.chartCategories objectAtIndex:section];
    return self.dataSource.examples[category].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SCDExampleItem *exampleItem = [self p_SCD_exampleAt:indexPath];

    SCDExampleTableCell *exampleCell = [tableView dequeueReusableCellWithIdentifier:SCDExampleTableCell.reuseId];
    [exampleCell updateWithMenuItem:exampleItem];
    
    return exampleCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SCDExampleItem *example = [self p_SCD_exampleAt:indexPath];
    
    SCDExampleBaseViewController *exampleController = [self.dataSource createViewControllerForExample:example];
    if (exampleController != nil) {
        SCDExampleViewController *exampleViewController = [[SCDExampleViewController alloc] initWithExampleController:exampleController];
        exampleViewController.title = example.title;
        [self.navigationController pushViewController:exampleViewController animated:YES];
    }
}

- (SCDExampleItem *)p_SCD_exampleAt:(NSIndexPath *)indexPath {
    if ([self p_SCD_isFiltering]) {
        return _filteredExamples[indexPath.row];
    } else {
        NSString *category = [self.dataSource.chartCategories objectAtIndex:indexPath.section];
        return [self.dataSource.examples[category] objectAtIndex:indexPath.row];
    }
}

// MARK: - Search Bar

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope {
    [self p_SCI_filterContentForSearchText:searchBar.text scope:searchBar.scopeButtonTitles[selectedScope]];
}
    
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    UISearchBar *searchBar = searchController.searchBar;
    NSString *scope = searchBar.scopeButtonTitles[searchBar.selectedScopeButtonIndex];
    
    [self p_SCI_filterContentForSearchText:searchBar.text scope:scope];
}

- (void)p_SCI_filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope {
    _filteredExamples = [SCDSearchExampleUtil getFilteredContentForSearchText:searchText scope:scope dataSource:_dataSource];
    
    [self.tableView reloadData];
}

- (BOOL)p_SCD_isSearchBarEmpty {
    return _searchController.searchBar.text == nil || _searchController.searchBar.text.length == 0;
}

- (BOOL)p_SCD_isFiltering {
    BOOL searchBarScopeIsFiltering = _searchController.searchBar.selectedScopeButtonIndex != 0;
    return _searchController.isActive && (![self p_SCD_isSearchBarEmpty] || searchBarScopeIsFiltering);
}

@end
