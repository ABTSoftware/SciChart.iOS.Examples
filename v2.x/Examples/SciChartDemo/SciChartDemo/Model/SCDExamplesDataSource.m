//
//  SCDExamplesDataSource.m
//  SciChartDemo
//
//  Created by Mykola Hrybeniuk on 7/4/16.
//  Copyright © 2016 ABT. All rights reserved.
//

#import "SCDExamplesDataSource.h"
#import "SCDExampleItem.h"

@implementation SCDExamplesDataSource

- (instancetype)init {
    
    self = [super init];
    if (self) {
        
        self.chartCategories = [NSArray arrayWithObjects:@"Basic Chart Types", @"Styling and Theming", @"Create a MultiSeries Chart", @"Extra features", @"Tooltips and HitTest", @"Create Stock Charts", @"Performance demo", @"Zoom and Pan a Chart", @"Modify Axis Behaviour",  nil];
        
        self.examples2D = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:
                                                               [[NSMutableArray alloc]initWithObjects:
                                                                
                                                                [[SCDExampleItem alloc] initWithExampleName:@"Dashed Line Chart"
                                                                                         exampleDescription:@"Dashed Line Chart"
                                                                                                exampleIcon:@"LineChart"
                                                                                                exampleFile:@"DashedLineChartView"],
                                                                
                                                                [[SCDExampleItem alloc] initWithExampleName:@"Line Chart"
                                                                                         exampleDescription:@"Generates a Line-Chart in code."
                                                                                                exampleIcon:@"LineChart"
                                                                                                exampleFile:@"LineChartView"],
                                                                
                                                                [[SCDExampleItem alloc] initWithExampleName:@"Legend Chart"
                                                                                         exampleDescription:@"Generates a Line-Chart in code with Legend Modifier."
                                                                                                exampleIcon:@"Annotations"
                                                                                                exampleFile:@"LegendChartView"],
                                                                
                                                                [[SCDExampleItem alloc] initWithExampleName:@"Digital Line Chart"
                                                                                         exampleDescription:@"Generates a Digital Line-Chart in code."
                                                                                                exampleIcon:@"LineChart"
                                                                                                exampleFile:@"DigitalLineChartView"],
                                                                
                                                                [[SCDExampleItem alloc] initWithExampleName:@"Column Chart"
                                                                                         exampleDescription:@"Generates a simple Column Series chart in code-behind."
                                                                                                exampleIcon:@"ColumnChart"
                                                                                                exampleFile:@"ColumnChartView"],
                                                                
                                                                [[SCDExampleItem alloc] initWithExampleName:@"Mountain Chart"
                                                                                         exampleDescription:@"Generates a Mountain (Area) Chart in code."
                                                                                                exampleIcon:@"MountainChart"
                                                                                                exampleFile:@"MountainChartView"],
                                                                
                                                                [[SCDExampleItem alloc] initWithExampleName:@"Digital Mountain Chart"
                                                                                         exampleDescription:@"Generates a Digital Mountain (Area) Chart in code."
                                                                                                exampleIcon:@"MountainChart"
                                                                                                exampleFile:@"DigitalMountainChartView"],
                                                                
                                                                [[SCDExampleItem alloc] initWithExampleName:@"Candlestick Chart"
                                                                                         exampleDescription:@"Generates a simple Candlestick chart in code."
                                                                                                exampleIcon:@"CandlestickChart"
                                                                                                exampleFile:@"CandlestickChartView"],
                                                                
                                                                [[SCDExampleItem alloc] initWithExampleName:@"Scatter Chart"
                                                                                         exampleDescription:@"Generates a Scatter chart in code."
                                                                                                exampleIcon:@"ScatterChart"
                                                                                                exampleFile:@"ScatterSeriesChartView"],
                                                                
                                                                [[SCDExampleItem alloc] initWithExampleName:@"Heatmap Chart"
                                                                                         exampleDescription:@"Demonstrates how to create a real-time Heatmap using SciChart."
                                                                                                exampleIcon:@"HeatmapChart"
                                                                                                exampleFile:@"HeatmapChartView"],
                                                                
                                                                [[SCDExampleItem alloc] initWithExampleName:@"Bubble Chart"
                                                                                         exampleDescription:@"Generates a line and bubble series chart in code."
                                                                                                exampleIcon:@"BubbleChart"
                                                                                                exampleFile:@"BubbleChartView"],
                                                                
                                                                [[SCDExampleItem alloc] initWithExampleName:@"Band Series Chart"
                                                                                         exampleDescription:@"Generates a simple Band Series chart in code."
                                                                                                exampleIcon:@"BandChart"
                                                                                                exampleFile:@"BandChartView"],
                                                                
                                                                [[SCDExampleItem alloc] initWithExampleName:@"Digital Band Series Chart"
                                                                                         exampleDescription:@"Generates a simple Digital Band Series chart in code."
                                                                                                exampleIcon:@"BandChart"
                                                                                                exampleFile:@"DigitalBandChartView"],
                                                                
                                                                [[SCDExampleItem alloc] initWithExampleName:@"Adding series with millions points Demo"
                                                                                         exampleDescription:@"Generates super fast adding of FastLineRenderableSeries."
                                                                                                exampleIcon:@"LineChart"
                                                                                                exampleFile:@"LinePerformanceChartView"],
                                                                
                                                                [[SCDExampleItem alloc] initWithExampleName:@"Impulse Chart"
                                                                                         exampleDescription:@"Generates a Impulse-Chart in code."
                                                                                                exampleIcon:@"LineChart"
                                                                                                exampleFile:@"ImpulseChartView"],
                                                                
                                                                [[SCDExampleItem alloc] initWithExampleName:@"Error Bars Chart"
                                                                                         exampleDescription:@"Generates a ErrorBars-Chart in code."
                                                                                                exampleIcon:@"LineChart"
                                                                                                exampleFile:@"ErrorBarsChartView"],
                                                                
                                                                [[SCDExampleItem alloc] initWithExampleName:@"Fan Chart"
                                                                                         exampleDescription:@"Generates a Fan-Chart in code."
                                                                                                exampleIcon:@"LineChart"
                                                                                                exampleFile:@"FanChartView"],nil],
                                                               
                                                               [[NSMutableArray alloc]initWithObjects:
                                                                [[SCDExampleItem alloc] initWithExampleName:@"Theme Manager"
                                                                                         exampleDescription:@"Theme Manager"
                                                                                                exampleIcon:@"StackedMountainChart"
                                                                                                exampleFile:@"ThemeProviderUsingChartView"],
                                                                
                                                                [[SCDExampleItem alloc] initWithExampleName:@"Custom Theme"
                                                                                         exampleDescription:@"Custom Theme"
                                                                                                exampleIcon:@"StackedMountainChart"
                                                                                                exampleFile:@"ThemeCustomChartView"],
                                                                
                                                                [[SCDExampleItem alloc] initWithExampleName:@"Using PointMarkers"
                                                                                         exampleDescription:@"Demonstrates the PointMarker API which allows data-point markers to be added to many RenderableSeries types."
                                                                                                exampleIcon:@"LineChart"
                                                                                                exampleFile:@"UsingPointMarkersChartView"],
                                                                nil],
                                                               
                                                               [[NSMutableArray alloc]initWithObjects:
                                                                [[SCDExampleItem alloc] initWithExampleName:@"StackedMountain Chart"
                                                                                         exampleDescription:@"Generates a Stacked Mountain chart in code."
                                                                                                exampleIcon:@"StackedMountainChart"
                                                                                                exampleFile:@"StackedMountainChartView"],
                                                                [[SCDExampleItem alloc] initWithExampleName:@"Stacked Column Chart"
                                                                                         exampleDescription:@"Generates a Stacked Column chart in code."
                                                                                                exampleIcon:@"ColumnChart"
                                                                                                exampleFile:@"StackedColumnVerticalChartView"],
                                                                [[SCDExampleItem alloc] initWithExampleName:@"Stacked Column Side By Side"
                                                                                         exampleDescription:@"Generates a Stacked Column Side By Side chart in code."
                                                                                                exampleIcon:@"ColumnChart"
                                                                                                exampleFile:@"StackedColumnSideBySideChartView"],
                                                                [[SCDExampleItem alloc] initWithExampleName:@"Stacked Column 100%"
                                                                                         exampleDescription:@"Generates a Stacked Column 100% chart in code."
                                                                                                exampleIcon:@"ColumnChart"
                                                                                                exampleFile:@"StackedColumnFullFillChartView"],
                                                                [[SCDExampleItem alloc] initWithExampleName:@"Stacked Bar Chart"
                                                                                         exampleDescription:@"Generates a Stacked Column 100% chart in code."
                                                                                                exampleIcon:@"ColumnChart"
                                                                                                exampleFile:@"StackedColumnChartView"],
                                                                nil],
                                                               
                                                               [[NSMutableArray alloc]initWithObjects:
                                                                [[SCDExampleItem alloc] initWithExampleName:@"ECG Monitor Demo"
                                                                                         exampleDescription:@"The ECG Monitor Demo showcases a real-time heart-rate monitor."
                                                                                                exampleIcon:@"RealTime"
                                                                                                exampleFile:@"ECGChartView"],
                                                                [[SCDExampleItem alloc] initWithExampleName:@"Oscilloscope Demo"
                                                                                         exampleDescription:@"Showcases Sorted and Unsorted Data Series in a real-time"
                                                                                                exampleIcon:@"RealTime"
                                                                                                exampleFile:@"OscilloscopeChartView"],
                                                                [[SCDExampleItem alloc] initWithExampleName:@"Annotations are Easy"
                                                                                         exampleDescription:@"Generates a simple Annotations demo."
                                                                                                exampleIcon:@"Annotations"
                                                                                                exampleFile:@"AnnotationsChartView"],
                                                                
                                                                [[SCDExampleItem alloc] initWithExampleName:@"Multiple Axes"
                                                                                         exampleDescription:@"Multiple Axes"
                                                                                                exampleIcon:@"LineChart"
                                                                                                exampleFile:@"MultipleAxesChartView"],
                                                                
                                                                [[SCDExampleItem alloc] initWithExampleName:@"Secondary Y Axes"
                                                                                         exampleDescription:@"Secondary Y Axes"
                                                                                                exampleIcon:@"LineChart"
                                                                                                exampleFile:@"SecondaryYAxesChartView"],
                                                                
                                                                [[SCDExampleItem alloc] initWithExampleName:@"Multiple Surface"
                                                                                         exampleDescription:@"Multiple Surface"
                                                                                                exampleIcon:@"LineChart"
                                                                                                exampleFile:@"MultipleSurfaceChartView"],
                                                                
                                                                [[SCDExampleItem alloc] initWithExampleName:@"Multiple-Pane Stock Chart"
                                                                                         exampleDescription:@"Multiple-Pane Stock Chart"
                                                                                                exampleIcon:@"LineChart"
                                                                                                exampleFile:@"MultiPaneStockChartView"],
                                                                
                                                                [[SCDExampleItem alloc] initWithExampleName:@"Palette Provider"
                                                                                         exampleDescription:@"Conditional style change"
                                                                                                exampleIcon:@"LineChart"
                                                                                                exampleFile:@"PalettedChartView"],
                                                                
                                                                [[SCDExampleItem alloc] initWithExampleName:@"Custom modifier example"
                                                                                         exampleDescription:@"Create custom modifier with subclassing"
                                                                                                exampleIcon:@"LineChart"
                                                                                                exampleFile:@"CustomModifierView"],
                                                                
                                                                [[SCDExampleItem alloc] initWithExampleName:@"Column drill down"
                                                                                         exampleDescription:@"Custom modifier to view details"
                                                                                                exampleIcon:@"ColumnChart"
                                                                                                exampleFile:@"ColumnDrillDownView"],
                                                                nil],
                                                               [[NSMutableArray alloc]initWithObjects:
                                                                [[SCDExampleItem alloc] initWithExampleName:@"Using CursorModifier"
                                                                                         exampleDescription:@"Demonstrates using the CursorModifier API"
                                                                                                exampleIcon:@"LineChart"
                                                                                                exampleFile:@"UsingCursorModifierChartView"],
                                                                [[SCDExampleItem alloc] initWithExampleName:@"Using RolloverModifier"
                                                                                         exampleDescription:@"Demonstrates using the RolloverModifier API"
                                                                                                exampleIcon:@"LineChart"
                                                                                                exampleFile:@"UsingRolloverModifierChartView"],
                                                                [[SCDExampleItem alloc] initWithExampleName:@"Using TooltipModifier"
                                                                                         exampleDescription:@"Demonstrates using the TooltipModifier API"
                                                                                                exampleIcon:@"LineChart"
                                                                                                exampleFile:@"UsingTooltipModifierChartView"],
                                                                [[SCDExampleItem alloc] initWithExampleName:@"Customization RolloverModifier"
                                                                                         exampleDescription:@"Demonstrates customization of the RolloverModifier"
                                                                                                exampleIcon:@"LineChart"
                                                                                                exampleFile:@"RolloverCustomizationChartView"],
                                                                [[SCDExampleItem alloc] initWithExampleName:@"Customization CursorModifier"
                                                                                         exampleDescription:@"Demonstrates customization of the CursorModifier"
                                                                                                exampleIcon:@"LineChart"
                                                                                                exampleFile:@"CursorCustomizationChartView"],
                                                                [[SCDExampleItem alloc] initWithExampleName:@"Customization TooltipModifier"
                                                                                         exampleDescription:@"Demonstrates customization of the TooltipModifier"
                                                                                                exampleIcon:@"LineChart"
                                                                                                exampleFile:@"TooltipCustomizationChartView"],
                                                                [[SCDExampleItem alloc] initWithExampleName:@"Series Selection"
                                                                                         exampleDescription:@"Demonstration of selection modifier and series selected style"
                                                                                                exampleIcon:@"Annotations"
                                                                                                exampleFile:@"SeriesSelectionView"],
                                                                [[SCDExampleItem alloc] initWithExampleName:@"Pan and Zoom a Chart"
                                                                                         exampleDescription:@"Demonstration chart scrolling and zooming"
                                                                                                exampleIcon:@"LineChart"
                                                                                                exampleFile:@"PanAndZoomChartView"],
                                                                nil],
                                                               [[NSMutableArray alloc]initWithObjects:
                                                                [[SCDExampleItem alloc] initWithExampleName:@"Realtime Ticking Stock Chart"
                                                                                         exampleDescription:@"Realtime Ticking Stock Chart"
                                                                                                exampleIcon:@"CandlestickChart"
                                                                                                exampleFile:@"RealtimeTickingStockChartView"],
                                                                nil],
                                                               
                                                               [[NSMutableArray alloc]initWithObjects:
                                                                [[SCDExampleItem alloc] initWithExampleName:@"FIFO Performance Demo (1k points)"
                                                                                         exampleDescription:@"FIFO Performance test."
                                                                                                exampleIcon:@"LineChart"
                                                                                                exampleFile:@"FIFOSpeedTestSciChart"],
                                                                
                                                                [[SCDExampleItem alloc] initWithExampleName:@"Series Performance Demo"
                                                                                         exampleDescription:@"100 Series. Each series has 100 points."
                                                                                                exampleIcon:@"LineChart"
                                                                                                exampleFile:@"NxMSeriesSpeedTestSciChart"],
                                                                
                                                                [[SCDExampleItem alloc] initWithExampleName:@"Scatter Performance Demo (20k points)"
                                                                                         exampleDescription:@"Scatter chart with 20k points."
                                                                                                exampleIcon:@"LineChart"
                                                                                                exampleFile:@"ScatterSpeedTestSciChart"],
                                                                
                                                                [[SCDExampleItem alloc] initWithExampleName:@"Appending Performance Demo"
                                                                                         exampleDescription:@"Appendig 1k points per sec during 10 sec."
                                                                                                exampleIcon:@"LineChart"
                                                                                                exampleFile:@"AppendSpeedTestSciChart"],
                                                                
                                                                [[SCDExampleItem alloc] initWithExampleName:@"3xSeries Performance Demo"
                                                                                         exampleDescription:@"Animated appending to 1 milion points"
                                                                                                exampleIcon:@"LineChart"
                                                                                                exampleFile:@"SCDSeriesAppendingTestSciChart"],
                                                                nil],
                                                               [[NSMutableArray alloc]initWithObjects:
                                                                [[SCDExampleItem alloc] initWithExampleName:@"Drag Axis to Scale a Chart"
                                                                                         exampleDescription:@"Showcase how to add Axis-Drag scaling"
                                                                                                exampleIcon:@"LineChart"
                                                                                                exampleFile:@"DragAxisToScaleChartView"],
                                                                nil],
                                                               
                                                               [[NSMutableArray alloc]initWithObjects:
                                                                [[SCDExampleItem alloc] initWithExampleName:@"Vertical Chart"
                                                                                         exampleDescription:@"Showcase how to draw vertical chart"
                                                                                                exampleIcon:@"LineChart"
                                                                                                exampleFile:@"VerticalChartView"],
                                                                
                                                                [[SCDExampleItem alloc] initWithExampleName:@"Logarithmic Axes"
                                                                                         exampleDescription:@"This example demonstrates X and Y logarithmix axis in SciChart."
                                                                                                exampleIcon:@"LineChart"
                                                                                                exampleFile:@"LogarithmicAxisChartView"],
                                                                nil],
                                                               nil]
                                                      forKeys: self.chartCategories];
    }
    return self;
}

@end
