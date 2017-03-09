//
//  SCDExampleItem.m
//  SciChartDemo
//
//  Created by Mykola Hrybeniuk on 7/4/16.
//  Copyright © 2016 ABT. All rights reserved.
//

#import "SCDExampleItem.h"

@implementation SCDExampleItem

- (instancetype)initWithExampleName:(NSString *) exampleName
                 exampleDescription:(NSString *) exampleDescription
                        exampleIcon:(NSString *) exampleIcon
                        exampleFile:(NSString *) exampleFile {
    
    if (self = [super init]) {
        self.exampleDescription = exampleDescription;
        self.exampleName = exampleName;
        self.exampleIcon = exampleIcon;
        self.exampleFile = exampleFile;
    }
    
    return self;
}

@end
