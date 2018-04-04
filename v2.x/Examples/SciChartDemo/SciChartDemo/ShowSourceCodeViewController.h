//
//  ShowSourceCodeViewController.h
//  SciChartDemo
//
//  Created by Yaroslav Pelyukh on 5/5/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SCDSyntaxHighlightedTextView;

static NSString *kObjectiveCSourceCodeType = @"objectivec";
static NSString *kSwiftSourceCodeType = @"swift";

@interface ShowSourceCodeViewController : UIViewController
@property (strong, nonatomic) NSString *sourceCodeType; //Default kObjectiveCSourceCodeType
@property (strong, nonatomic) NSString *sourceCodeText;
@property (strong, nonatomic) IBOutlet SCDSyntaxHighlightedTextView *sourceCodeTextView;

@end
