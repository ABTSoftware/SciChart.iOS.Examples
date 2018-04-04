//
//  SCDSyntaxHighlightedTextView.h
//  SciChartDemo
//
//  Created by Mykola Hrybeniuk on 6/14/16.
//  Copyright © 2016 ABT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCDSyntaxHighlightedTextView : UITextView

@property(nonatomic) NSDictionary *highlightDefinition;

- (void)setHighlightDefinitionWithContentsOfFile:(NSString*)path;

@end
