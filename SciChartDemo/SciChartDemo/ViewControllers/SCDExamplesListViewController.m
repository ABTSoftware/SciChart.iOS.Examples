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

@property (strong, nonatomic, readonly) UIImageView *backgroundImage;


@end

@implementation SCDExamplesListViewController {
    NSArray *_filteredExamples;
    
}

NSArray *cell0SubMenuItemsArray;
BOOL isSection0Cell0Expanded;

@synthesize searchController = _searchController;
@synthesize backgroundImage = _backgroundImage;


- (UISearchController *)searchController {
    if (_searchController == nil) {
        _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
        _searchController.searchResultsUpdater = self;
        _searchController.obscuresBackgroundDuringPresentation = NO;
        _searchController.searchBar.delegate = self;
        _searchController.searchBar.barStyle = UIBarStyleBlack;
        if (@available(iOS 13.0, *)) {
            _searchController.searchBar.searchTextField.leftView.tintColor = [UIColor colorWithRed:(71/255.f) green:(189/255.f) blue:(230/255.f) alpha:1.0];
        }
        _searchController.searchBar.placeholder = @"Search example, source code and more";
        _searchController.searchBar.scopeButtonTitles = @[@"2D Charts", @"3D Charts", @"Featured Apps"];
        
        [_searchController.searchBar setScopeBarButtonTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
        [_searchController.searchBar setScopeBarButtonTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
        
    }
    return _searchController;
}

- (UIImageView *)backgroundImage {
    if (_backgroundImage == nil) {
        _backgroundImage = [UIImageView new];
        _backgroundImage.tintColor = UIColor.whiteColor;
        _backgroundImage.image = [UIImage imageNamed:@"chart.background"];
    }
    return _backgroundImage;
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithStyle:UITableViewStylePlain];
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView initWithFrame:CGRectZero style:UITableViewStyleGrouped];

    [self.view bringSubviewToFront:self.tableView];
    self.tableView.separatorInset = UIEdgeInsetsZero;
//    self.tableView = UITableViewStylePlain;
    self.tableView.backgroundColor = UIColor.clearColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // Needed to eliminate separators between empty cells
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundView = self.backgroundImage;
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chartlist.background"]];
    [tempImageView setFrame:self.tableView.frame];
    
    self.tableView.backgroundView = tempImageView;
    
    self.navigationController.navigationBar.titleTextAttributes = @{
        NSFontAttributeName:[UIFont fontWithName:@"Inter-Regular" size:21],
        NSForegroundColorAttributeName: [UIColor whiteColor]
        };
    
    if (@available(iOS 15.0, *)) {
        self.tableView.sectionHeaderTopPadding = 0;
    }
    
    [self.tableView registerClass:SCDExampleListTableHeaderView.class forHeaderFooterViewReuseIdentifier:SCDExampleListTableHeaderView.reuseId];
    [self.tableView registerClass:SCDExampleTableCell.class forCellReuseIdentifier:SCDExampleTableCell.reuseId];
    
    // The backBarButtonItem property of a navigation item reflects the back button you want displayed
    // when the current view controller is just below the topmost view controller.
    // In other words, the back button is not used when the current view controller is topmost.
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStylePlain target:nil action:nil];
 
    UIButton *backButtonT = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [backButtonT setImage:[UIImage imageNamed:@"chartlist.home"] forState:UIControlStateNormal];
    backButtonT.backgroundColor = [UIColor colorWithRed:(23/255.f) green:(36/255.f) blue:(61/255.f) alpha:0.3];
    backButtonT.layer.cornerRadius = 8;
    backButtonT.layer.borderWidth = 1;
    backButtonT.layer.borderColor = [UIColor colorWithRed:(76/255.f) green:(81/255.f) blue:(86/255.f) alpha:0.7].CGColor;
    [backButtonT addTarget:self action:@selector(p_SCD_navigateHome) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButtonT];
    self.navigationItem.rightBarButtonItem = [self p_SCD_getRightBarButtonWithTitle:[self p_SCD_getRightBarButtonTitle]];
    self.navigationItem.searchController = self.searchController;
    cell0SubMenuItemsArray = @[@"Category", @"Feature", @"Name", @"Most Used"];
    
     [[UILabel appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:[UIColor colorWithRed:(255/255.f) green:(255/255.f) blue:(255/255.f) alpha:0.5]];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [[UILabel appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:[UIColor colorWithRed:(255/255.f) green:(255/255.f) blue:(255/255.f) alpha:0.5]];
}


- (void)viewDidAppear:(BOOL)animated {
    _searchController.searchBar.searchTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Search example, source code and more" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:(255/255.f) green:(255/255.f) blue:(255/255.f) alpha:0.5]}];
    [[UILabel appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:[UIColor colorWithRed:(255/255.f) green:(255/255.f) blue:(255/255.f) alpha:0.5]];
   
}

- (void)navRightBarTapped {
    self.navigationItem.hidesSearchBarWhenScrolling = false;
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
//    if (section != 0) {
        UIView *reusableHeader = [tableView dequeueReusableHeaderFooterViewWithIdentifier:SCDExampleListTableHeaderView.reuseId];
        SCDExampleListTableHeaderView *header = (SCDExampleListTableHeaderView *)reusableHeader;
        header.backgroundColor = UIColor.clearColor;
        header.label.text = [self p_SCD_isFiltering] ? @"Search results" : [self.dataSource.chartCategories objectAtIndex:section];
        
        return header;

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
        return 80;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    NSLog(@"Value of hello = %lu", (unsigned long)_dataSource.chartCategories.count + 1);

    return [self p_SCD_isFiltering] ? 1 : (_dataSource.chartCategories.count);
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
        exampleCell.selectionStyle = UITableViewCellSelectionStyleNone;
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
        NSLog(@"Value of value = %@", [self.dataSource.examples[category] objectAtIndex:indexPath.row]);
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

