//
//  SCIModifiersStore.h
//  SciChartDemo
//
//  Created by Yaroslav Pelyukh on 5/23/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCIModifiersStore : NSObject{
    NSMutableArray * sciModifiers;
}

@property (nonatomic, retain) NSMutableArray * sciModifiers;

+(id) SharedSCIModifiersStore;

@end
