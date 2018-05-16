//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// ModifierTableViewCell.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "ModifierTableViewCell.h"
#import "ModifierTableViewController.h"
#import "ModifierTableViewController+InteractionWithExampleData.h"

@implementation ModifierTableViewCell

@synthesize ModifierClassName;

- (IBAction)updateModifierState:(id)sender {
    if (_modifierEnableHandler) {
        _modifierEnableHandler(self.ModifierName.text);
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
