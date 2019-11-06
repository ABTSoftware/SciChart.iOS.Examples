//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDExampleSettingsViewController.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SCDExampleSettingsViewController.h"
#import "SCDSettingTableCell.h"

@interface SCDExampleSettingsViewController ()

@property (strong, nonatomic, readonly) UITableView *tableView;

@end

@implementation SCDExampleSettingsViewController

@synthesize tableView = _tableView;

- (UITableView *)tableView {
    if (_tableView == nil) {
        if (@available(iOS 13.0, *)) {
            _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleInsetGrouped];
        } else {
            _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        }
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorColor = UIColor.blackColor;
        _tableView.separatorInset = UIEdgeInsetsZero;
        _tableView.backgroundColor = [UIColor colorNamed:@"color.tableview.background"];
        // Needed to eliminate separators between empty cells
        _tableView.tableFooterView = [UIView new];
        [_tableView registerNib:[UINib nibWithNibName:SCDSettingTableCell.reuseId bundle:nil] forCellReuseIdentifier:SCDSettingTableCell.reuseId];
    }
    return _tableView;
}

- (void)loadView {
    self.view = self.tableView;
}

// MARK: - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _settings.allKeys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _settings[@(section)].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id<ISCDMenuItem> setting = _settings[@(indexPath.section)][indexPath.row];

    SCDSettingTableCell *settingCell = [tableView dequeueReusableCellWithIdentifier:SCDSettingTableCell.reuseId];
    [settingCell updateWithText:setting.title andIcon:setting.icon];

    return settingCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id<ISCDMenuItem> setting = _settings[@(indexPath.section)][indexPath.row];
    setting.action();
}

@end
