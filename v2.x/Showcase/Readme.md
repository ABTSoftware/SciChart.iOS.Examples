# How to Build the SciChart.iOS Showcase

The SciChart.iOS Showcase uses Cocoapods to get the SciChart.iOS Framework library. 

To install cocoapods and build the examples, run the following commands at a Terminal in OSX:

<pre>
# After git clone https://github.com/ABTSoftware/SciChart.iOS.Examples.git
> cd v2.x/Showcase/SciChartShowcase
> pod install
> open .
</pre>

[Image]

This will install the SciChart.iOS Cocoapod. Now open the genertated SciChart.iOS.Showcase.xcworkspace

[Image]

This will open the Workspace with the SciChart.iOS Showcase project referencing SciChart.iOS as a Pod. You can compile and run in a simulator, or on device from XCode. Select a scheme, and a device target, and go! 
