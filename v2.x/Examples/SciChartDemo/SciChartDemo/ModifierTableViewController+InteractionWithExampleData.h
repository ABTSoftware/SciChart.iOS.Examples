//
//  ModifierTableViewController+ModifierTableView_InteractionWithExampleData.h
//  SciChartDemo
//
//  Created by Yaroslav Pelyukh on 5/24/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

#import "ModifierTableViewController.h"

@interface ModifierTableViewController (ModifierTableView_InteractionWithExampleData)

-(void) EnableModifier:(NSString *) modifierIdentifier;

- (void) initEnabledModifiers;

@end
