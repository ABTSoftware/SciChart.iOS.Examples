//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SideMenuViewController.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SideMenuViewController.h"
#import "SideBarMenuCell.h"

@implementation SideMenuViewController
@synthesize scichartSurface;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeTableView];
}

-(void)initializeTableView{
    
    [self setMenuItems: @[ [[SideBarMenuCell alloc] initWithSettingName: @"Modifiers Group" settingIcon:@"RubberBandZoom" settingSegue:@"ModifiersSegue"],
                           [[SideBarMenuCell alloc] initWithSettingName: @"Show Up Source Code" settingIcon:@"SourceCode" settingSegue:@"SourceCodeSegue"],
                           [[SideBarMenuCell alloc] initWithSettingName: @"Share Example Project" settingIcon:@"XCodeProj" settingSegue:@"ShareProjSegue"]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [tableView setBackgroundColor:[UIColor colorWithRed:0.145 green:0.145 blue:0.145 alpha:1]];
    
    return [self.menuItems count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"menuTableCell";
    
    SideBarMenuCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[SideBarMenuCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    }
    
    SideBarMenuCell * menuItem = [self.menuItems objectAtIndex:indexPath.row];
    
    cell.SettingName.text = [menuItem.SettingName text];
    cell.SettingImage.image = [menuItem.SettingImage image];
    [cell setSettingSegue :menuItem.SettingSegue];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SideBarMenuCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    [self performSegueWithIdentifier:[cell SettingSegue] sender:self];
}
@end
