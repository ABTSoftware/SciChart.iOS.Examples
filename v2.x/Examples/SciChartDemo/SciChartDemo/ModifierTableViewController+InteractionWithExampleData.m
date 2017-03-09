//
//  ModifierTableViewController+ModifierTableView_InteractionWithExampleData.m
//  SciChartDemo
//
//  Created by Yaroslav Pelyukh on 5/24/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

#import "ModifierTableViewController+InteractionWithExampleData.h"
#import "SciModifierModel.h"

@implementation ModifierTableViewController (ModifierTableView_InteractionWithExampleData)

- (void) EnableModifier:(NSString*)modifierIdentifier{
    
    SCIModifierGroup * chartModifierGroup = [self.sciSurface chartModifier];
    
    id<SCIChartModifierProtocol> modifier = [chartModifierGroup  itemAt:[self modifierGroupModifierIndex:modifierIdentifier]];
    [modifier setIsEnabled:![modifier isEnabled]];
}

- (void) initEnabledModifiers{
    SCIModifierGroup * chartModifierGroup = [self.sciSurface chartModifier];
    self.modifiers = [[NSMutableArray alloc]init];
    for (int i=0; i<[chartModifierGroup itemCount];i++) {
        
        id<SCIChartModifierProtocol> modifier = [chartModifierGroup itemAt:i];
        
        SciModifierModel * modifierModel = [[SciModifierModel alloc]init];
        [modifierModel setTitle: [modifier modifierName]];
        [modifierModel setIcon:[UIImage imageNamed: NSStringFromClass([modifier class])]];
        [modifierModel setEnabled:[modifier isEnabled]];
        
        [self.modifiers addObject: modifierModel];
    }
}

-(Boolean) modifierGroupIncludesModifier: (NSString*)modifierClassName{
    
    SCIModifierGroup * chartModifierGroup = [self.sciSurface chartModifier];
    
    for (int i=0; i<chartModifierGroup.itemCount; i++) {
        if ([[(id<SCIChartModifierProtocol>)[chartModifierGroup itemAt:i] modifierName] isEqualToString:modifierClassName]){
            return YES;
        }
    }
    
    return NO;
}

-(int) modifierGroupModifierIndex: (NSString*)modifierIdentifier{
    
    SCIModifierGroup * chartModifierGroup = [self.sciSurface chartModifier];
    int j=0;
    for (int i=0; i<chartModifierGroup.itemCount; i++) {
        NSString * name = [(id<SCIChartModifierProtocol>)[chartModifierGroup itemAt:i] modifierName];
        if ([name isEqualToString:modifierIdentifier]){
            return j;
        }
        j++;
    }
    j=-1;
    return j;
}

@end