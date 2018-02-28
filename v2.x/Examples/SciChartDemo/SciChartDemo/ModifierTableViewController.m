//
//  ModifierTableViewController.m
//  SciChartDemo
//
//  Created by Yaroslav Pelyukh on 5/19/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

#import "ModifierTableViewController.h"
#import "ModifierTableViewCell.h"
#import "SciModifierModel.h"
#import "ModifierTableViewController+InteractionWithExampleData.h"

@implementation ModifierTableViewController

@synthesize modifiers;
@synthesize sciSurface;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initEnabledModifiers];
    self.navigationItem.title = @"Modifiers Settings";
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [tableView setBackgroundColor:[UIColor colorWithRed:0.145 green:0.145 blue:0.145 alpha:1]];
    return [self.sciSurface.chartModifiers count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ModfierSettingsCell";
    ModifierTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    __weak typeof(self) weakSelf = self;
    [cell setModifierEnableHandler:^(NSString *modifierName) {
        [weakSelf EnableModifier:modifierName];
    }];
    
    if (!cell) {
        cell = [[ModifierTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                            reuseIdentifier:CellIdentifier];
    }
    
    SciModifierModel * menuItem = [self.modifiers objectAtIndex:indexPath.row];
    cell.ModifierName.text = menuItem.Title;
    cell.ModifierImageView.image = menuItem.Icon;
    cell.ModifierDescription.text = menuItem.ModifierDecription;
    cell.ModifierSwitch.on = menuItem.Enabled;
    cell.ModifierClassName = menuItem.ClassName;
    
    UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width * 3, 5)];
    
    [separatorLineView setBackgroundColor:[UIColor colorWithRed:0.110
                                                          green:0.110
                                                           blue:0.110
                                                          alpha:1]];
    [cell setBackgroundColor:[UIColor colorWithRed:0.196
                                             green:0.208
                                              blue:0.227
                                             alpha:1]];
    
    [cell.contentView addSubview:separatorLineView];
    
    return cell;
    
}

@end
