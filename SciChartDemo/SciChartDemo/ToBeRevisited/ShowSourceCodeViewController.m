//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// ShowSourceCodeViewController.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "ShowSourceCodeViewController.h"
#import "SCDSyntaxHighlightedTextView.h"
#import <SciChart.Examples/SCDConstants.h>

@interface ShowSourceCodeViewController ()

@end

@implementation ShowSourceCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Set the syntax highlighting to use (the tempalate file contains the default highlighting)
    [self.sourceCodeTextView setHighlightDefinitionWithContentsOfFile:[[NSBundle bundleWithIdentifier:ExamplesBundleId] pathForResource:self.sourceCodeType ofType:@"plist"]];
    self.sourceCodeTextView.text = self.sourceCodeText;
}

- (NSString *)sourceCodeType {
    if (!_sourceCodeType) {
        _sourceCodeType = kObjectiveCSourceCodeType;
    }
    return _sourceCodeType;
    
}

@end
