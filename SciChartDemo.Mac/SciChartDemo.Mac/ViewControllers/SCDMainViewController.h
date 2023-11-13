//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2023. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDMainViewController.h is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>
#import <AppKit/NSViewController.h>
#import <AppKit/NSTableView.h>

NS_ASSUME_NONNULL_BEGIN

@interface SCDMainViewController : NSViewController <NSCollectionViewDelegate, NSCollectionViewDataSource, NSTableViewDelegate, NSTableViewDataSource, NSSearchFieldDelegate>

@property (weak) IBOutlet NSCollectionView *collectionView;
@property (weak) IBOutlet NSView *vwBackGroundText;
@property (strong) IBOutlet NSButton *btnViewAllChart;
@property (nonatomic, strong) NSMutableArray *arrChartType;
@property (weak) IBOutlet NSTableView *tblView;
@property (weak) IBOutlet NSScrollView *scrlView;
@property (weak) IBOutlet NSSearchField *searchField;
@property (nonatomic, strong) NSArray *filteredExamples;

@end

NS_ASSUME_NONNULL_END
