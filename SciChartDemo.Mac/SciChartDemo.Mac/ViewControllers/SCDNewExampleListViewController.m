//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2023. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDNewExampleListViewController.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SCDNewExampleListViewController.h"
#import "SCDExampleListViewController.h"
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
#import "SCDChartDetailViewController.h"
#import "SCDBasicSplitViewController.h"
#import <SciChart.Examples/SCDConstants.h>
#import <SciChart.Examples/SCDExampleBaseViewController.h>
#import "SCDNewExampleListViewController.h"
#import "SCDChartDetailViewController.h"

@implementation SCDNewExampleListViewController {
    SCDExamplesDataSource *_examplesDataSource;
    __weak SCDExampleBaseViewController *_exampleViewController;
    SCDSectionsModel *_tableSectionsModel;
    SCDChartDetailViewController *_detailViewController;
    SCDExampleItem *_selectedExample;
    NSTableView *_tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    _chartListTableView.delegate = self;
    _chartListTableView.dataSource = self;
    _arrayOfExamples = [[NSArray alloc] init];
    _detailViewController.view = [NSView new];
    _chartListTableView.rowHeight = 45; // matches cell height
    _chartListTableView.intercellSpacing = NSMakeSize(10, 10);
    _chartListTableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self updateDataSourceFromFile:Examples2DPlistFileName];
    [self p_SCD_createSections];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)updateDataSourceFromFile:(NSString *)fileName {
    _examplesDataSource = [[SCDExamplesDataSource alloc] initWithPlistFileName:fileName];
}

- (void)p_SCD_createSections {
    _tableSectionsModel = [SCDSectionsModel new];
    _tableSectionsModel.sectionTitles = _examplesDataSource.chartCategories;
    _tableSectionsModel.examplesArray = [NSMutableArray new];
    
    for (id key in _examplesDataSource.chartCategories) {
        NSArray *sectionObjects = _examplesDataSource.examples[key];
        [_tableSectionsModel.examplesArray addObject:sectionObjects];
    }
    [_chartListTableView reloadData];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return _tableSectionsModel.countOfItems;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    id item = [self p_SCD_itemAt:row];
    NSView *view;
    if ([item isKindOfClass:SCDExampleItem.class]) {
        view = [self p_SCD_tableView:tableView tryGetCellOfType:ExampleListCellView.class withItem:item];
        [(ExampleListCellView *)view updateWithExampleItem:item];
    } else {
        view = [self p_SCD_tableView:tableView tryGetCellOfType:HeaderCellView.class withItem:item];
        [(HeaderCellView *)view updateWithTitle:item];
    }
    
    return view;
}

- (NSView *)p_SCD_tableView:(NSTableView *)tableView tryGetCellOfType:(Class)cellType withItem:(SCDExampleItem *)item {
    NSString *identifier = NSStringFromClass(cellType);
    NSView *view = [tableView makeViewWithIdentifier:identifier owner:self];
    if (view == nil) {
        view = [cellType new];
        view.identifier = identifier;
    }
    return view;
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification {
    [self p_SCD_selectExampleAt:_chartListTableView.selectedRow];
}

- (void)p_SCD_selectExampleAt:(NSInteger)index {
    if (index < 0) return;
    _selectedExample = [self p_SCD_itemAt:index];
    SCDExampleBaseViewController *exampleViewController = [_examplesDataSource createViewControllerForExample:_selectedExample];
    exampleViewController.view.frame = CGRectMake(0, 0, 150, 250);
    if (exampleViewController != nil) {
        [NSNotificationCenter.defaultCenter postNotificationName:EXAMPLE_SELECTION_CHANGED object:exampleViewController];
    }
}

- (SCDExampleItem *)p_SCD_itemAt:(NSInteger)row {
    return [_tableSectionsModel itemAtIndex:row];
}

//- (nonnull NSCollectionViewItem *)collectionView:(nonnull NSCollectionView *)collectionView itemForRepresentedObjectAtIndexPath:(nonnull NSIndexPath *)indexPath {
//    SCDListViewCell *cell = [_chartListCollectionView makeItemWithIdentifier:@"chartsViewIdentifier" forIndexPath:indexPath];
//
//    return cell;
//}
//
//- (NSInteger)collectionView:(nonnull NSCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    return 3;
//}
//
//- (void)collectionView:(NSCollectionView *)collectionView didSelectItemsAtIndexPaths:(NSSet<NSIndexPath *> *)indexPaths {
//    NSIndexPath *indexPath = [indexPaths anyObject];
//
//    NSStoryboard *mainStoryBoard = [NSStoryboard storyboardWithName:@"SCDMainStoryboard" bundle:[NSBundle mainBundle]];
//    NSViewController* vc = [mainStoryBoard instantiateControllerWithIdentifier:@"SCDBasicSplitViewController"];
////    vc._getStringValue = _searchString;
//    [self presentViewControllerAsModalWindow:vc];
//
//}

//- (void)prepareForSegue:(NSStoryboardSegue *)segue sender:(id)sender {
//    if ([segue.identifier isEqualToString:@"SCDNewExampleListViewController"]) {
//       // NSIndexPath *indexPath = (NSIndexPath *)sender;
//        NSViewController* vc = [[SCDNewExampleListViewController alloc] initWithNibName:nil bundle:nil];
//        [self presentViewControllerAsSheet:vc];
//    }
//}

@end
