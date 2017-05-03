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
    
    SCIModifierGroup * chartModifierGroup = (SCIModifierGroup*)[self.sciSurface chartModifier];
    
    int index = [self modifierGroupModifierIndex:modifierIdentifier];
    
    if (index > -1 && index < chartModifierGroup.itemCount) {
        id<SCIChartModifierProtocol> modifier = [chartModifierGroup  itemAt:index];
        [modifier setIsEnabled:![modifier isEnabled]];
    }
    
}

- (void) initEnabledModifiers{
    
    if (![[self.sciSurface chartModifier] isKindOfClass:[SCIModifierGroup class]]) {
        return;
    }
    
    SCIModifierGroup * chartModifierGroup = (SCIModifierGroup*)[self.sciSurface chartModifier];
    
    self.modifiers = [[NSMutableArray alloc]init];
    for (int i=0; i<[chartModifierGroup itemCount]; i++) {
        
        id<SCIChartModifierProtocol> modifier = [chartModifierGroup itemAt:i];
        
        SciModifierModel * modifierModel = [[SciModifierModel alloc]init];
        [modifierModel setTitle: [modifier modifierName]];
        [modifierModel setIcon:[UIImage imageNamed: NSStringFromClass([modifier class])]];
        [modifierModel setEnabled:[modifier isEnabled]];
        
        [self.modifiers addObject: modifierModel];
    }
}

-(BOOL) modifierGroupIncludesModifier: (NSString*)modifierClassName{
    
    SCIModifierGroup * chartModifierGroup = (SCIModifierGroup*)[self.sciSurface chartModifier];
    
    for (int i=0; i<chartModifierGroup.itemCount; i++) {
        if ([[(id<SCIChartModifierProtocol>)[chartModifierGroup itemAt:i] modifierName] isEqualToString:modifierClassName]){
            return YES;
        }
    }
    
    return NO;
}

-(int) modifierGroupModifierIndex: (NSString*)modifierIdentifier{
    
    SCIModifierGroup * chartModifierGroup = (SCIModifierGroup*)[self.sciSurface chartModifier];
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
