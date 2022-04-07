//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDSyntaxHighlightedTextView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SCDSyntaxHighlightedTextView.h"

NSString *const kRegexHighlightViewTypeAdditional = @"01_additional";
NSString *const kRegexHighlightViewTypeKeyword = @"02_keyword";
NSString *const kRegexHighlightViewTypeURL = @"03_url";
NSString *const kRegexHighlightViewTypeProject = @"04_project";
NSString *const kRegexHighlightViewTypeAttribute = @"05_attribute";
NSString *const kRegexHighlightViewTypeNumber = @"07_number";
NSString *const kRegexHighlightViewTypeCharacter = @"06_character";
NSString *const kRegexHighlightViewTypeString = @"08_string";
NSString *const kRegexHighlightViewTypeComment = @"09_comment";
NSString *const kRegexHighlightViewTypeDocumentationComment = @"10_documentation_comment";
NSString *const kRegexHighlightViewTypeDocumentationCommentKeyword = @"11_documentation_comment_keyword";
NSString *const kRegexHighlightViewTypePreprocessor = @"12_preprocessor";
NSString *const kRegexHighlightViewTypeText = @"text";
NSString *const kRegexHighlightViewTypeBackground = @"background";
NSString *const kRegexHighlightViewTypeOther = @"other";

@implementation SCDSyntaxHighlightedTextView

#pragma mark - Static Methods

+ (NSDictionary*)pv_highlightTheme {
    return [NSDictionary dictionaryWithObjectsAndKeys:
            [UIColor colorWithRed:255.0/255 green:255.0/255 blue:255.0/255 alpha:1],kRegexHighlightViewTypeText,
            [UIColor colorWithRed:40.0/255 green:43.0/255 blue:52.0/255 alpha:1],kRegexHighlightViewTypeBackground,
            [UIColor colorWithRed:72.0/255 green:190.0/255 blue:102.0/255 alpha:1],kRegexHighlightViewTypeComment,
            [UIColor colorWithRed:72.0/255 green:190.0/255 blue:102.0/255 alpha:1],kRegexHighlightViewTypeDocumentationComment,
            [UIColor colorWithRed:72.0/255 green:190.0/255 blue:102.0/255 alpha:1],kRegexHighlightViewTypeDocumentationCommentKeyword,
            [UIColor colorWithRed:230.0/255 green:66.0/255 blue:75.0/255 alpha:1],kRegexHighlightViewTypeString,
            [UIColor colorWithRed:255.0/255 green:255.0/255 blue:255.0/255 alpha:1],kRegexHighlightViewTypeCharacter,
            [UIColor colorWithRed:139.0/255 green:134.0/255 blue:201.0/255 alpha:1],kRegexHighlightViewTypeNumber,
            [UIColor colorWithRed:195.0/255 green:55.0/255 blue:149.0/255 alpha:1],kRegexHighlightViewTypeKeyword,
            [UIColor colorWithRed:211.0/255 green:142.0/255 blue:99.0/255 alpha:1],kRegexHighlightViewTypePreprocessor,
            [UIColor colorWithRed:35.0/255 green:63.0/255 blue:208.0/255 alpha:1],kRegexHighlightViewTypeURL,
            [UIColor colorWithRed:139.0/255 green:233.0/255 blue:253.0/255 alpha:1],kRegexHighlightViewTypeProject,
            [UIColor colorWithRed:80.0/255 green:250.0/255 blue:123.0/255 alpha:1],kRegexHighlightViewTypeAdditional,
            [UIColor colorWithRed:103.0/255 green:135.0/255 blue:142.0/255 alpha:1],kRegexHighlightViewTypeAttribute,
            [UIColor colorWithRed:0.0/255 green:175.0/255 blue:199.0/255 alpha:1],kRegexHighlightViewTypeOther,nil];
}

#pragma mark - Private Methods

- (NSAttributedString*)pv_highlightText:(NSAttributedString*)attributedString {
    //Create a mutable attribute string to set the highlighting
    NSString* string = attributedString.string;
    NSRange range = NSMakeRange(0,[string length]);
    NSMutableAttributedString* coloredString = [[NSMutableAttributedString alloc] initWithAttributedString:attributedString];
    
    //Define the definition to use
    NSDictionary* definition = self.highlightDefinition;
    
    //For each definition entry apply the highlighting to matched ranges
    NSArray *keys = [[definition allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    for(NSString* key in keys) {
        NSString* expression = [definition objectForKey:key];
        if(!expression||[expression length]<=0) continue;
        NSArray* matches = [[NSRegularExpression regularExpressionWithPattern:expression options:NSRegularExpressionDotMatchesLineSeparators error:nil] matchesInString:string options:0 range:range];
        for(NSTextCheckingResult* match in matches) {
            UIColor* textColor = nil;
            //Get the text color, if it is a custom key and no color was defined, choose black
            if(!(textColor=[[SCDSyntaxHighlightedTextView pv_highlightTheme] objectForKey:key]))
                textColor = [UIColor blackColor];
            [coloredString addAttribute:NSForegroundColorAttributeName value:textColor range:[match rangeAtIndex:0]];
        }
    }
    
    self.backgroundColor = [[SCDSyntaxHighlightedTextView pv_highlightTheme] objectForKey:kRegexHighlightViewTypeBackground];
    
    return coloredString.copy;
}

#pragma mark - Public Methods

- (void)setHighlightDefinitionWithContentsOfFile:(NSString*)newPath {
    [self setHighlightDefinition:[NSDictionary dictionaryWithContentsOfFile:newPath]];
}

#pragma mark - Overrided Methods

- (void)setText:(NSString *)text {
    
    self.font = [UIFont systemFontOfSize:14.];
    
    UIColor* textColor = self.textColor ? : [UIColor whiteColor];

    //Set line height, font, color and break mode
    CGFloat minimumLineHeight = [text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                                                   options:NSStringDrawingUsesFontLeading
                                                attributes:@{NSFontAttributeName : self.font}
                                                   context:nil].size.height;
    CGFloat maximumLineHeight = minimumLineHeight;
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setParagraphStyle:[NSParagraphStyle defaultParagraphStyle]];
    style.minimumLineHeight = minimumLineHeight;
    style.maximumLineHeight = maximumLineHeight;
    style.lineBreakMode = NSLineBreakByWordWrapping;
    
    
    self.attributedText = [self pv_highlightText:[[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName : self.font,
                                                                                                              NSForegroundColorAttributeName : textColor,
                                                                                                              NSParagraphStyleAttributeName : style}]];
}



@end
