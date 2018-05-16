//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// ModifierTableViewCell.h is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import <UIKit/UIKit.h>

typedef void(^ActionHandler)(NSString *modifierName);

@interface ModifierTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *ModifierImageView;
@property (strong, nonatomic) IBOutlet UILabel     *ModifierName;
@property (strong, nonatomic) IBOutlet UITextView  *ModifierDescription;
@property (strong, nonatomic) IBOutlet UISwitch    *ModifierSwitch;
@property (strong, nonatomic) NSString             *ModifierClassName;

- (IBAction)updateModifierState:(id)sender;

-(instancetype)initWithModifierName:(NSString *) modifierName
                ModifierDescription:(NSString *) modifierDescription
                       ModifierIcon:(NSString *) modifierIcon
                   ModifierSelected:(Boolean)    modifierSelected
                  ModifierClassName:(NSString *) modifierClassName;

@property (nonatomic, copy) ActionHandler modifierEnableHandler;

@end
