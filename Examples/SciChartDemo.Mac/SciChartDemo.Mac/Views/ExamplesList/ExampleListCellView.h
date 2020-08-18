//
//  ExampleListCellView.h
//  SciChartDemo.Mac
//
//  Created by Black Thornvision on 04.03.2020.
//  Copyright © 2020 SciChart Ltd. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <SciChart.Examples/SCDExampleItem.h>

NS_ASSUME_NONNULL_BEGIN

@interface ExampleListCellView : NSTableCellView

- (void)updateWithExampleItem:(SCDExampleItem *)menuItem;

@end

NS_ASSUME_NONNULL_END
