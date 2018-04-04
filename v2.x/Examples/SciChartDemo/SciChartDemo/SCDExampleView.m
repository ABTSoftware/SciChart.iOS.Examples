//
//  SCDExampleView.m
//  SciChartDemo
//
//  Created by Mykola Hrybeniuk on 6/14/16.
//  Copyright © 2016 ABT. All rights reserved.
//

#import "SCDExampleView.h"

@implementation SCDExampleView

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
 
    if (_NeedsHideSideBarMenu) {
        _NeedsHideSideBarMenu([[touches anyObject] view]);
    }
    
}

@end
