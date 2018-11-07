//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDExampleItem.h is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import <Foundation/Foundation.h>

@interface SCDExampleItem : NSObject

@property (strong, nonatomic) NSString *exampleIcon;
@property (strong, nonatomic) NSString *exampleName;
@property (strong, nonatomic) NSString *exampleDescription;
@property (strong, nonatomic) NSString *exampleFile;
@property (strong, nonatomic) NSString *exampleFilePath;

- (instancetype)initWithExampleName:(NSString *)exampleName
                 exampleDescription:(NSString *)exampleDescription
                        exampleIcon:(NSString *)exampleIcon
                        exampleFile:(NSString *)exampleFile
                    exampleFilePath:(NSString *)exampleFilePath;

@end
