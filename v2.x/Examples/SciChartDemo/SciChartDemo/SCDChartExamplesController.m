//
//  SciChartTableViewController.m
//  SciChartDemo
//
//  Created by Yaroslav Pelyukh on 2/3/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

#import "SCDChartExamplesController.h"
#import "ExampleTableViewCell.h"
#import "ExampleUIViewController.h"
#include <objc/runtime.h>
#import "LineChartView.h"
#import "SCDSharedProjectConfigurator.h"
#import "UIAlertController+SCDAdditional.h"
#import "UIViewController+SCDLoading.h"
#import "SCDConstants.h"
#import "SCDSourceCodeItem.h"
#import "SCDSourceCodeCell.h"
#import "SCDExampleItem.h"
#import "SCDExamplesDataSource.h"
#import "SCDExampleTableHeader.h"

static NSString *kShowPerformanceSegueId = @"showPerformanceSegueId";
static NSString *kShowChartExampleSegueId = @"showChartExampleSegueId";
static NSString *kCellIdentifier = @"exampleTableCell";
static NSString *kCellSourceCodeIdentifier = @"SCDSourceCodeCell";
static NSString *kExampleTableHeader = @"SCDExampleTableHeader";
static NSString *kScopeSourceCodeSearching = @"Source Code";
static NSString *kScopeExampleSearching = @"Example";

@interface SCDChartExamplesController () <UISearchDisplayDelegate>

@property (nonatomic) SCDExamplesDataSource *dataSource;
@property (nonatomic) NSDictionary<NSString*, NSString*> *cachedSourceCode;
@property (nonatomic) NSUInteger searchScopeIndex;

@end

@implementation SCDChartExamplesController

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationItem setHidesBackButton:YES];
    [self pv_initializeTableView];
    
    [self.searchDisplayController.searchResultsTableView registerNib:[UINib nibWithNibName:@"SCDSourceCodeCell" bundle:nil]
                                              forCellReuseIdentifier:kCellSourceCodeIdentifier];
    
    [self.searchDisplayController.searchResultsTableView registerNib:[UINib nibWithNibName:@"SCDExampleTableViewCell" bundle:nil]
                                              forCellReuseIdentifier:kCellIdentifier];
    
    [self.tableView registerClass:[SCDExampleTableHeader class] forHeaderFooterViewReuseIdentifier:kExampleTableHeader];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:kFirstTimeLaunching];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Private Methods

- (void)pv_initializeTableView {
    self.dataSource = [SCDExamplesDataSource new];
    [self setSearchResults:[NSMutableArray arrayWithCapacity:self.dataSource.examples2D.count]];
}

- (void)pv_filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope{
    
    if([scope isEqualToString:kScopeExampleSearching]){
        NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"exampleName contains[c] %@", searchText];
        NSMutableArray * result =[[NSMutableArray alloc]init];
        for (id key in self.dataSource.examples2D) {
            [result addObjectsFromArray:[[self.dataSource.examples2D valueForKey:key]filteredArrayUsingPredicate:resultPredicate]];
        }
        [self setSearchResults:result];
    }
    else {
        
        NSMutableArray *results = [NSMutableArray new];
        
        for (NSString *key in _cachedSourceCode.allKeys) {
            NSString *content = [_cachedSourceCode objectForKey:key];
            NSRange searchRange = [content rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if (searchRange.location != NSNotFound) {
                SCDSourceCodeItem *item = [SCDSourceCodeItem new];
                item.fileName = key;
                
                NSUInteger countLimit = 15;
                NSUInteger startIndex = searchRange.location > countLimit ? searchRange.location - countLimit : 0;
                NSUInteger endIndex = searchRange.location + searchRange.length + 2*countLimit >= content.length ?
                content.length - searchRange.location :
                searchRange.length + 2*countLimit;
                
                NSRange range = NSMakeRange(startIndex, endIndex);
                
                NSString *subString = [content substringWithRange:range];
                
                if (range.location > 0) {
                    subString = [@"..." stringByAppendingString:subString];
                }
                
                if (range.location + range.length < content.length) {
                    subString = [subString stringByAppendingString:@"..."];
                }
                
                item.descr = subString;
                
                [results addObject:item];
            }
        }
        
        [self setSearchResults:results];
        
    }
}

- (SCDExampleItem*)pv_getSelectedCell:(NSIndexPath *)indexPath{
    if (self.searchDisplayController.active)
        return [self.searchResults objectAtIndex:indexPath.row];
    else
        return [[self.dataSource.examples2D objectForKey:[self.dataSource.chartCategories objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
}

#pragma mark - TableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.searchDisplayController.searchResultsTableView) return 1;
    else return [self.dataSource.chartCategories count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [tableView setBackgroundColor:[UIColor colorWithRed:0.145 green:0.145 blue:0.145 alpha:1]];
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [self.searchResults count];
    }
    else{
        return [(NSMutableArray*)[self.dataSource.examples2D objectForKey:[self.dataSource.chartCategories objectAtIndex:section]] count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    
    if (self.searchDisplayController.searchResultsTableView == tableView && self.searchScopeIndex == 1) {
        SCDSourceCodeCell *sourceCodeCell = [tableView dequeueReusableCellWithIdentifier:kCellSourceCodeIdentifier];
        SCDSourceCodeItem *sourceCodeItem = [self.searchResults objectAtIndex:indexPath.row];
        [sourceCodeCell setupWithItem:sourceCodeItem];
        cell = sourceCodeCell;
    }
    else {
        
        ExampleTableViewCell *exampleCell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
        SCDExampleItem * exampleItem = nil;
        
        if (tableView == self.searchDisplayController.searchResultsTableView)
            exampleItem = (SCDExampleItem*)[self.searchResults objectAtIndex:indexPath.row];
        else
            exampleItem = [[self.dataSource.examples2D objectForKey:[self.dataSource.chartCategories objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
        
        [exampleCell setupWithItem:exampleItem];
        cell = exampleCell;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.searchDisplayController.searchResultsTableView == tableView && self.searchScopeIndex == 1)
        return 58.f;
    else
        return 60.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    SCDExampleTableHeader *header = (SCDExampleTableHeader*)[tableView dequeueReusableHeaderFooterViewWithIdentifier:kExampleTableHeader];
    [header setupWithItem:[self.dataSource.chartCategories objectAtIndex:section]];
    return header;
}

#pragma mark - TableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    
    if ([cell isKindOfClass:[ExampleTableViewCell class]]) {
        [self performSegueWithIdentifier:kShowChartExampleSegueId sender:cell];
    }
    else if ([cell isKindOfClass:[SCDSourceCodeCell class]]) {
        
        SCDSourceCodeCell *sourceCodeCell = (SCDSourceCodeCell*)cell;
        
        NSURL *fileUrl = [NSURL URLWithString:sourceCodeCell.fileNameLabel.text];
        
        NSString * filePath = [[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[fileUrl.pathExtension isEqualToString:@"swift"] ? @"ChartViews" : @"ExampleViews"]
                               stringByAppendingPathComponent:fileUrl.lastPathComponent];
        
        NSString *data = [NSString stringWithContentsOfFile:filePath
                                                   encoding:NSUTF8StringEncoding
                                                      error:nil];
        
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ShowSourceCodeViewController *controller = [storyBoard instantiateViewControllerWithIdentifier:kSourceCodeViewControllerId];
        controller.sourceCodeText = data;
        controller.sourceCodeType = [fileUrl.pathExtension isEqualToString:@"swift"] ? kSwiftSourceCodeType : kObjectiveCSourceCodeType;
        [self.navigationController pushViewController:controller animated:YES];
    }

}

#pragma mark - SearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(int)selectedScope {

    if (selectedScope == 1 && !_cachedSourceCode) {
        
        [self startAnimating];
        
        [SCDSharedProjectConfigurator cachedSourceCodeWithHandler:^(BOOL succes, NSMutableDictionary<NSString *,NSString *> *cachedDictionary, NSError *error) {
            self.searchScopeIndex = selectedScope;
            self.cachedSourceCode = cachedDictionary;
            
            if (searchBar.text) {
                [self pv_filterContentForSearchText:searchBar.text scope:kScopeSourceCodeSearching];
            }
            
            [self.searchDisplayController.searchResultsTableView reloadData];
           
            [self stopAnimating];
        }];
    }
    else {
        self.searchScopeIndex = selectedScope;
        if (searchBar.text) {
            [self pv_filterContentForSearchText:searchBar.text scope: self.searchScopeIndex == 1 ? kScopeSourceCodeSearching : kScopeExampleSearching];
        }
        
    }
    
}

- (void)searchBar:(UISearchBar*)searchBar textDidChange:(nonnull NSString *)searchText{
    NSString *scope = [self.searchDisplayController.searchBar.scopeButtonTitles objectAtIndex:self.searchScopeIndex];
    [self pv_filterContentForSearchText:searchText scope:scope];
}

#pragma mark - IBActions & Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    NSIndexPath *indexPath;
    if (self.searchDisplayController.active)
        indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
    else
        indexPath = [self.tableView indexPathForSelectedRow];
    
    SCDExampleItem *itemCell = [self pv_getSelectedCell:indexPath];
    ExampleUIViewController *uiviewController = segue.destinationViewController;
    [uiviewController setExampleName: [itemCell exampleName]];
    [uiviewController setExampleUIViewName: [itemCell exampleFile]];
    
}

- (IBAction)shareActionNavBarItem:(UIBarButtonItem*)sender {
   
    NSMutableArray *chartNames = [NSMutableArray new];
    
    for (NSString *categoryName in self.dataSource.chartCategories) {
        for (SCDExampleItem *item in [self.dataSource.examples2D objectForKey:categoryName]) {
            [chartNames addObject:item.exampleFile];
        }
    }
    
    DidDoneHandler handler = ^(BOOL succes, NSString *pathToZipFile, NSError *error) {
        if (succes) {
            NSURL *url = [NSURL fileURLWithPath:pathToZipFile];
            
            UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:@[url] applicationActivities:nil];
            activityController.popoverPresentationController.barButtonItem = sender;
            activityController.popoverPresentationController.sourceView = self.view;
            [self presentViewController:activityController animated:YES completion:nil];
        }
        else {
            NSLog(@"%@", error);
        }
        [self stopAnimating];
    };
    
    UIAlertController *alert = [UIAlertController shareAlertControllerWithSwiftShareActionHandler:^(UIAlertAction *action) {
        [self startAnimating];
        [SCDSharedProjectConfigurator pathForZipedSwiftShareProjectWithChartNames:chartNames
                                                                      withHandler:handler];
    }
                                                                        andObjcShareActionHandler:^(UIAlertAction *action) {
        [self startAnimating];
        [SCDSharedProjectConfigurator pathForZipedObjcShareProjectWithChartNames:chartNames
                                                                     withHandler:handler];
                                                                        }];
    
    alert.popoverPresentationController.barButtonItem = sender;
    alert.popoverPresentationController.sourceView = self.view;
    [self presentViewController:alert
                       animated:YES
                     completion:nil];
    
}

#pragma GCC diagnostic pop

@end
