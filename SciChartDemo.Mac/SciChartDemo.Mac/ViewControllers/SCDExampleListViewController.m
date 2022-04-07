//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDExampleListViewController.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SCDExampleListViewController.h"
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

@implementation SCDExampleListViewController {
    SCDMainToolbarDelegate *_toolbarDelegate;

    SCDExamplesDataSource *_examplesDataSource;
    SCDSectionsModel *_tableSectionsModel;
    SCDExampleItem *_selectedExample;
    
    NSTableView *_tableView;
    NSSearchField *_searchField;
    NSString *_searchString;
    NSArray *_filteredExamples;
}

- (void)loadView {
    self.view = [NSView new];
    
    _searchField = [NSSearchField new];
    _searchField.translatesAutoresizingMaskIntoConstraints = NO;
    _searchField.target = self;
    _searchField.action = @selector(onSearchTextChange:);
    [self.view addSubview:_searchField];
    
    NSScrollView *scrollView = [NSScrollView new];
    scrollView.hasHorizontalScroller = NO;
    scrollView.hasVerticalScroller = YES;
    scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:scrollView];
    [NSLayoutConstraint activateConstraints:@[
        [_searchField.widthAnchor constraintEqualToConstant:262],
        [_searchField.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:8],
        [_searchField.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-8],
        [_searchField.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:8],
        [_searchField.bottomAnchor constraintEqualToAnchor:scrollView.topAnchor constant:-8],
        
        [scrollView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [scrollView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [scrollView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
    ]];
    
    _tableView = [NSTableView new];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [_tableView addTableColumn:[[NSTableColumn alloc] initWithIdentifier:@"column"]];
    _tableView.usesAutomaticRowHeights = YES;
    _tableView.headerView = nil;
    scrollView.documentView = _tableView;
    [_tableView sizeToFit];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self updateDataSourceFromFile:Examples2DPlistFileName];
}

- (void)viewDidAppear {
    [super viewDidAppear];
    
    [self p_SCD_createToolbarForWindow:self.view.window];
}

// MARK: - Toolbar

- (void)p_SCD_createToolbarForWindow:(NSWindow *)window {
    window.toolbar = [[NSToolbar alloc] initWithIdentifier:MAIN_TOOLBAR];
    if (@available(macOS 10.14, *)) {
        window.toolbar.centeredItemIdentifier = TOOLBAR_TITLE;
    }
    
    _toolbarDelegate = [[SCDMainToolbarDelegate alloc] initWithToolbar:window.toolbar];
    window.toolbar.delegate = _toolbarDelegate;
    [_toolbarDelegate addInitialItems:@[
        [self p_SCD_createExamplesTypeToolbarSegment],
        [[SCDToolbarTitle alloc] initWithTitle:@"SciChart macOS"],
        [SCDToolbarFlexibleSpace new],
        [self p_SCD_createIsSwiftToolbarItem]
    ]];
}

- (id<ISCDToolbarItem>)p_SCD_createExamplesTypeToolbarSegment {
    id<ISCDToolbarItem> item = [[SCDToolbarButtonsGroup alloc] initWithToolbarItems:@[
        [[SCDToolbarButton alloc] initWithTitle:@"2D" image:nil andAction:^{ [self updateDataSourceFromFile:Examples2DPlistFileName]; }],
        [[SCDToolbarButton alloc] initWithTitle:@"3D" image:nil andAction:^{ [self updateDataSourceFromFile:Examples3DPlistFileName]; }],
        [[SCDToolbarButton alloc] initWithTitle:@"Featured" image:nil andAction:^{ [self updateDataSourceFromFile:FeaturedAppsPlistName]; }],
    ] withTrackingMode:NSSegmentSwitchTrackingSelectOne andSelectedSegment:0];
    item.identifier = TOOLBAR_EXAMPLES_SELECTOR;

    return item;
}

- (id<ISCDToolbarItem>)p_SCD_createIsSwiftToolbarItem {
    id<ISCDToolbarItem> item = [[SCDToolbarButton alloc] initWithTitle:@"Is Swift" image:[SCIImage imageNamed:@"icon.swift"] isSelected:_examplesDataSource.isSwift andAction:^{
        [self p_SCD_toggleIsSwift];
    }];
    item.identifier = TOOLBAR_IS_SWIFT;

    return item;
}

// MARK: - DataSource

- (void)p_SCD_toggleIsSwift {
    [_examplesDataSource toggleSwift];
    [self p_SCD_createSections];
    
    if ([self p_SCD_isFiltering]) {
        [self updateSearch];
    } else {
        [_tableView reloadData];
    }
    
    if (_selectedExample == nil) return;
    
    NSInteger _selectedIndex = [self p_SCD_indexOfItem:_selectedExample];
    [self p_SCD_selectExampleAt:_selectedIndex];
}

- (void)updateDataSourceFromFile:(NSString *)fileName {
    _examplesDataSource = [[SCDExamplesDataSource alloc] initWithPlistFileName:fileName];
    [self p_SCD_createSections];
    
    if ([self p_SCD_isFiltering]) {
        [self updateSearch];
    }
}

- (void)p_SCD_createSections {
    _tableSectionsModel = [SCDSectionsModel new];
    _tableSectionsModel.sectionTitles = _examplesDataSource.chartCategories;
    _tableSectionsModel.examplesArray = [NSMutableArray new];
    
    for (id key in _examplesDataSource.chartCategories) {
        NSArray *sectionObjects = _examplesDataSource.examples[key];
        [_tableSectionsModel.examplesArray addObject:sectionObjects];
    }
    [_tableView reloadData];
}

// MARK: - Table View

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    if ([self p_SCD_isFiltering]) {
        return _filteredExamples.count;
    }
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
    [self p_SCD_selectExampleAt:_tableView.selectedRow];
}
 
- (void)p_SCD_selectExampleAt:(NSInteger)index {
    if (index < 0) return;
    
    _selectedExample = [self p_SCD_itemAt:index];
    SCDExampleBaseViewController *exampleViewController = [_examplesDataSource createViewControllerForExample:_selectedExample];
    if (exampleViewController != nil) {
        [_toolbarDelegate updateTitle:[[SCDToolbarTitle alloc] initWithTitle:exampleViewController.title]];
        [_toolbarDelegate updateExampleItems:[exampleViewController generateToolbarItems]];

        [NSNotificationCenter.defaultCenter postNotificationName:EXAMPLE_SELECTION_CHANGED object:exampleViewController];
    }
}

- (SCDExampleItem *)p_SCD_itemAt:(NSInteger)row {
    if ([self p_SCD_isFiltering] && row >= 0) {
        return _filteredExamples[row];
    } else {
        return [_tableSectionsModel itemAtIndex:row];
    }
}

- (NSInteger)p_SCD_indexOfItem:(SCDExampleItem *)item {
    if ([self p_SCD_isFiltering]) {
        return [_filteredExamples indexOfObjectPassingTest:^BOOL(SCDExampleItem *example, NSUInteger idx, BOOL *stop) {
            if ([example.fileName isEqualToString:item.fileName]) {
                *stop = YES;
                return YES;
            }
            return NO;
        }];
    } else {
        return [_tableSectionsModel indexOfItem:_selectedExample];
    }
}

- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row {
    id item = [self p_SCD_itemAt:row];
    return [item isKindOfClass:SCDExampleItem.class];
}

// MARK: - Search Bar

- (void)onSearchTextChange:(NSSearchField *)sender {
    _searchString = sender.stringValue;
    [self updateSearch];
}

- (void)updateSearch {
    _filteredExamples = [SCDSearchExampleUtil getFilteredContentForSearchText:_searchString scope:@"" dataSource:_examplesDataSource];
    
    [_tableView reloadData];
}

- (BOOL)p_SCD_isFiltering {
    return ![self p_SCD_isSearchBarEmpty];
}

- (BOOL)p_SCD_isSearchBarEmpty {
    return _searchString == nil || _searchString.length == 0;
}

@end
