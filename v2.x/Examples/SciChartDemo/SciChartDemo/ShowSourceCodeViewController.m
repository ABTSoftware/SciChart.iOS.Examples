//
//  ShowSourceCodeViewController.m
//  SciChartDemo
//
//  Created by Yaroslav Pelyukh on 5/5/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

#import "ShowSourceCodeViewController.h"
#import "SCDSyntaxHighlightedTextView.h"

@interface ShowSourceCodeViewController ()

@end

@implementation ShowSourceCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Set the syntax highlighting to use (the tempalate file contains the default highlighting)
    [self.sourceCodeTextView setHighlightDefinitionWithContentsOfFile:[[NSBundle mainBundle] pathForResource:self.sourceCodeType ofType:@"plist"]];
    self.sourceCodeTextView.text = self.sourceCodeText;
}

- (NSString *)sourceCodeType {
    if (!_sourceCodeType) {
        _sourceCodeType = kObjectiveCSourceCodeType;
    }
    return _sourceCodeType;
    
}

@end
