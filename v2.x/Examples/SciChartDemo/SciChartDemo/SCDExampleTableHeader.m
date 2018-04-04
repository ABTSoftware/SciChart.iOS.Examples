//
//  SCDExampleTableHeader.m
//  SciChartDemo
//
//  Created by Mykola Hrybeniuk on 7/4/16.
//  Copyright © 2016 ABT. All rights reserved.
//

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
