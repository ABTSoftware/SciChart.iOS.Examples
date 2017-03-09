//
//  SCDExampleItem.h
//  SciChartDemo
//
//  Created by Mykola Hrybeniuk on 7/4/16.
//  Copyright © 2016 ABT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCDExampleItem : NSObject

@property (strong, nonatomic) NSString *exampleIcon;
@property (strong, nonatomic) NSString *exampleName;
@property (strong, nonatomic) NSString *exampleDescription;
@property (strong, nonatomic) NSString *exampleFile;


- (instancetype)initWithExampleName:(NSString *) exampleName
                 exampleDescription:(NSString *) exampleDescription
                        exampleIcon:(NSString *) exampleIcon
                        exampleFile:(NSString *) exampleFile;

@end
