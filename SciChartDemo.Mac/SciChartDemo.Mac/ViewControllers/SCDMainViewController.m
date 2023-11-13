//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2023. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDMainViewController.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SCDMainViewController.h"
#import "SCDMainItem.h"
#import "SCDSearchCell.h"
#import <SciChart.Examples/SCDSearchExampleUtil.h>
#import <SciChart.Examples/SCDConstants.h>
#import "SCDNewExampleListViewController.h"
#import "SCDExampleListViewController.h"
#import "SCDMainToolbarDelegate.h"
#import <SciChart.Examples/SCDToolbarTitle.h>
#import <SciChart.Examples/SCDToolbarFlexibleSpace.h>
#import <SciChart.Examples/SCDToolbarButton.h>
#import <SciChart.Examples/SCDToolbarButtonsGroup.h>
#import <SciChart.Examples/SCDExampleBaseViewController.h>
#import <SciChart.Examples/SCDConstants.h>
#import <SciChart.Examples/SCDExamplesDataSource.h>
#import <SciChart.Examples/SCDSearchExampleUtil.h>
#import "ExampleListCellView.h"
#import "SCDSectionsModel.h"
#import "SCDSplitViewController.h"
#import <SciChart.Examples/SCDConstants.h>
#import <AppKit/NSScreen.h>
#import "AppMenu.h"
#import <SciChart/SciChart.h>
#import <SciChart.Examples/ISCDToolbarItem.h>
#import "HeaderCellView.h"
#import "ExampleListCellView.h"
#import "SCDSectionsModel.h"
#import "SCDMainToolbarDelegate.h"
#import <SciChart.Examples/SCDToolbarTitle.h>
#import <SciChart.Examples/SCDToolbarFlexibleSpace.h>
#import <SciChart.Examples/SCDToolbarButton.h>
#import <SciChart.Examples/SCDToolbarButtonsGroup.h>
#import <SciChart.Examples/SCDExampleBaseViewController.h>
#import <SciChart.Examples/SCDConstants.h>
#import <SciChart.Examples/SCDExamplesDataSource.h>
#import <SciChart.Examples/SCDSearchExampleUtil.h>



@implementation SCDMainViewController {
    SCDExamplesDataSource *_examplesDataSource;
    SCDMainToolbarDelegate *_toolbarDelegate;
    NSViewController *_detailViewController;
    NSString *_searchString;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [_scrlView.layer setCornerRadius:10.0f];
    [_scrlView.layer setMasksToBounds:YES];
    [_scrlView setHidden:YES];
    _filteredExamples = [[NSArray alloc] init];
    
    [_collectionView registerClass:[SCDMainItem class] forItemWithIdentifier:@"photoItemIdentifier"];
    _arrChartType = [[NSMutableArray alloc] initWithArray:@[
        @{
            @"title": @"2D CHARTS",
            @"subtitle": @"SELECTION OF 2D CHARTS",
            @"image": [NSImage imageNamed:@"2DChart"]
        },
        @{
            @"title": @"3D CHARTS",
            @"subtitle": @"SELECTION OF 3D CHARTS",
            @"image": [NSImage imageNamed:@"3DCharts"]
        },
        @{
            @"title": @"Featured Charts",
            @"subtitle": @"SELECTION OF Featured CHARTS",
            @"image": [NSImage imageNamed:@"featureChart"]
        }
    ]];
    
    [self updateDataSourceFromFile:Examples2DPlistFileName];
}

- (void)updateDataSourceFromFile:(NSString *)fileName {
    _examplesDataSource = [[SCDExamplesDataSource alloc] initWithPlistFileName:fileName];
    //    [self p_SCD_createSections];
    //
    //    if ([self p_SCD_isFiltering]) {
    //        [self updateSearch];
    //    }
}

- (void)p_SCD_createSections {
    //    _tableSectionsModel = [SCDSectionsModel new];
    //    _tableSectionsModel.sectionTitles = _examplesDataSource.chartCategories;
    //    _tableSectionsModel.examplesArray = [NSMutableArray new];
    
    //    for (id key in _examplesDataSource.chartCategories) {
    //        NSArray *sectionObjects = _examplesDataSource.examples[key];
    //        [_tableSectionsModel.examplesArray addObject:sectionObjects];
    //    }
    [_tblView reloadData];
}

- (BOOL)p_SCD_isFiltering {
    return ![self p_SCD_isSearchBarEmpty];
}

- (BOOL)p_SCD_isSearchBarEmpty {
    return _searchString == nil || _searchString.length == 0;
}

#pragma mark :- collectionView Delegate
- (nonnull NSCollectionViewItem *)collectionView:(nonnull NSCollectionView *)collectionView itemForRepresentedObjectAtIndexPath:(nonnull NSIndexPath *)indexPath {
    SCDMainItem *cell = [collectionView makeItemWithIdentifier:@"photoItemIdentifier" forIndexPath:indexPath];
    NSDictionary *data = _arrChartType[indexPath.item];
    cell.lblTitle.stringValue = data[@"title"];
    //cell.lblSubTitle.stringValue = data[@"subtitle"];
    cell.cell_image.image = data[@"image"];
    cell.indexPath = indexPath;
    cell.clickButton.tag = 1;
    return cell;
}

- (NSInteger)collectionView:(nonnull NSCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _arrChartType.count;
}

- (void)collectionView:(NSCollectionView *)collectionView didSelectItemsAtIndexPaths:(NSSet<NSIndexPath *> *)indexPaths {
    NSIndexPath *indexPath = [indexPaths anyObject];
    [[NSUserDefaults standardUserDefaults] setInteger:indexPath.item forKey:@"indexValue"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSStoryboard *mainStoryBoard = [NSStoryboard storyboardWithName:@"SCDMainStoryboard" bundle:[NSBundle mainBundle]];
    NSViewController* vc = [mainStoryBoard instantiateControllerWithIdentifier:@"SCDBasicSplitViewController"];
    vc.title = @"";
    [self presentViewControllerAsModalWindow:vc];
}


#pragma mark :- tableview Delegate
-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return _filteredExamples.count;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    SCDExampleItem *data = _filteredExamples[row];
    SCDSearchCell *vw = [tableView makeViewWithIdentifier:@"cell" owner:self];
    [vw.lblTitle setStringValue:data.title];
    return vw;
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification {
    [self p_SCD_selectExampleAt:_tblView.selectedRow];
}

- (void)p_SCD_selectExampleAt:(NSInteger)index {
    if (index < 0) return;
    SCDExampleItem *data = _filteredExamples[index];
    SCDExampleBaseViewController *exampleViewController = [_examplesDataSource createViewControllerForExample:data];
    exampleViewController.view.frame = CGRectMake(0, 0, 2230, 1750);
    if (exampleViewController != nil) {
        [self presentViewControllerAsModalWindow:exampleViewController];
    }
}

#pragma mark :- search filed Delegate
- (IBAction)onSearchTectChange:(NSSearchField *)sender {
    _searchString = sender.stringValue;
    [self updateSearch];
}

- (void)searchFieldDidStartSearching:(NSSearchField *)sender {
    [_scrlView setHidden:NO];
}

- (void)searchFieldDidEndSearching:(NSSearchField *)sender {
    [_scrlView setHidden:YES];
}

- (void)updateSearch {
    _filteredExamples = [SCDSearchExampleUtil getFilteredContentForSearchText:_searchString scope:@"" dataSource:_examplesDataSource];
    [_tblView reloadData];
}

@end
