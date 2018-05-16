//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// ModifierTableViewController+InteractionWithExampleData.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "ModifierTableViewController+InteractionWithExampleData.h"
#import "SciModifierModel.h"

@implementation ModifierTableViewController (ModifierTableView_InteractionWithExampleData)

- (void) EnableModifier:(NSString*)modifierIdentifier{
    
    SCIChartModifierCollection * chartModifierGroup = [self.sciSurface chartModifiers];
    
    int index = [self modifierGroupModifierIndex:modifierIdentifier];
    
    if (index > -1 && index < [chartModifierGroup count]) {
        id<SCIChartModifierProtocol> modifier = [chartModifierGroup  itemAt:index];
        [modifier setIsEnabled:![modifier isEnabled]];
    }
    
}

- (void) initEnabledModifiers{
    

    
    SCIChartModifierCollection * chartModifierGroup = [self.sciSurface chartModifiers];
    
    self.modifiers = [[NSMutableArray alloc]init];
    for (int i=0; i<[chartModifierGroup count]; i++) {
        
        id<SCIChartModifierProtocol> modifier = [chartModifierGroup itemAt:i];
        
        SciModifierModel * modifierModel = [[SciModifierModel alloc]init];
        [modifierModel setTitle: [modifier modifierName]];
        [modifierModel setIcon:[UIImage imageNamed: NSStringFromClass([modifier class])]];
        [modifierModel setEnabled:[modifier isEnabled]];
        
        [self.modifiers addObject: modifierModel];
    }
}

-(BOOL) modifierGroupIncludesModifier: (NSString*)modifierClassName{
    
    SCIChartModifierCollection * chartModifierGroup = [self.sciSurface chartModifiers];
    
    for (int i=0; i<[chartModifierGroup count]; i++) {
        if ([[(id<SCIChartModifierProtocol>)[chartModifierGroup itemAt:i] modifierName] isEqualToString:modifierClassName]){
            return YES;
        }
    }
    
    return NO;
}

-(int) modifierGroupModifierIndex: (NSString*)modifierIdentifier{
    
    SCIChartModifierCollection * chartModifierGroup = [self.sciSurface chartModifiers];
    int j=0;
    for (int i=0; i<[chartModifierGroup count]; i++) {
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
