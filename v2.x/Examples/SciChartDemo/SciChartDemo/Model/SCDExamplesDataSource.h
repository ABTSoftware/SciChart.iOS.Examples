//
//  SCDExamplesDataSource.h
//  SciChartDemo
//
//  Created by Mykola Hrybeniuk on 7/4/16.
//  Copyright © 2016 ABT. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SCDExampleItem;

@interface SCDExamplesDataSource : NSObject

@property (nonatomic, strong) NSDictionary<NSString*, NSMutableArray<SCDExampleItem*>*> *examples2D;
@property (nonatomic, strong) NSArray * chartCategories;

@end
