//
//  ModifierTableViewCell.h
//  SciChartDemo
//
//  Created by Admin on 19/05/2016.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

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
