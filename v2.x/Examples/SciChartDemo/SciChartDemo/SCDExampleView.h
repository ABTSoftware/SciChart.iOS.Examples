//
//  SCDExampleView.h
//  SciChartDemo
//
//  Created by Mykola Hrybeniuk on 6/14/16.
//  Copyright © 2016 ABT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCDCallbackBlocks.h"

@interface SCDExampleView : UIView

@property (nonatomic,copy) TouchCallback NeedsHideSideBarMenu;

- (void)setNeedsHideSideBarMenu:(TouchCallback)NeedsHideSideBarMenu;

@end
