//
//  ModifierTableViewCell.m
//  SciChartDemo
//
//  Created by Admin on 19/05/2016.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

#import "ModifierTableViewCell.h"
#import "ModifierTableViewController.h"
#import "ModifierTableViewController+InteractionWithExampleData.h"

@implementation ModifierTableViewCell

@synthesize ModifierClassName;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (IBAction)updateModifierState:(id)sender {
    UITableView *tv = (UITableView *) self.superview.superview;
    UITableViewController *vc = (UITableViewController *) tv.dataSource;
    
    if([vc isKindOfClass:[ModifierTableViewController class]]){
        [(ModifierTableViewController*)vc EnableModifier: self.ModifierName.text];
    }
}

-(instancetype)initWithModifierName:(NSString *) modifierName
                ModifierDescription:(NSString *) modifierDescription
                       ModifierIcon:(NSString *) modifierIcon
                   ModifierSelected:(Boolean) modifierSelected
                  ModifierClassName:(NSString *)modifierClassName{
    if((self = [super init])){
        self.ModifierName = [[UILabel alloc]init];
        self.ModifierDescription = [[UITextView alloc]init];
        self.ModifierImageView = [[UIImageView alloc]init];
        self.ModifierSwitch = [[UISwitch alloc]init];
        
        self.ModifierDescription.text = modifierDescription;
        self.ModifierName.text = modifierName;
        self.ModifierImageView.image = [UIImage imageNamed:modifierIcon];
        self.ModifierSwitch.selected = modifierSelected;
        self.ModifierClassName = modifierClassName;
        [self.ModifierDescription scrollRangeToVisible:NSMakeRange(0, 0)];
    }
    return self;
}

@end