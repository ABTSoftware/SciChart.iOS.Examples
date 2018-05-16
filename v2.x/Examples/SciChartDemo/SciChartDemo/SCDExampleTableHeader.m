//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDExampleTableHeader.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SCDExampleTableHeader.h"

@implementation SCDExampleTableHeader {
    UILabel *_titleLabel;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, 18, 20)];
        [image setImage:[UIImage imageNamed:@"RightArrow.png"]];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 10, self.frame.size.width, 20)];
        [_titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
        [_titleLabel setTextColor:[UIColor colorWithRed:0.875
                                            green:0.878
                                             blue:0.886
                                            alpha:1.0]];
        [self addSubview:image];
        [self addSubview:_titleLabel];
        
        [self.contentView           setBackgroundColor:[UIColor colorWithRed:0.137
                                                 green:0.141
                                                  blue:0.149
                                                 alpha:1.0]];
        
    }
    
    return self;
}

- (void)setupWithItem:(NSString *)item {
    _titleLabel.text = item;
    [_titleLabel sizeToFit];
}

@end
