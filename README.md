# How to Build the SciChart.iOS Examples

The SciChart.iOS Examples use Cocoapods to get the SciChart.iOS Framework library. 

To install cocoapods and build the examples, run the following commands at a Terminal in OSX:

<pre>
# After git clone https://github.com/ABTSoftware/SciChart.iOS.Examples.git
> cd v2.x/Examples
> pod install
> open .
</pre>

![Pod Install](http://scichart.com/wp-content/uploads/2017/03/pod-install-1.png)

![Pod Install 2](http://scichart.com/wp-content/uploads/2017/03/pod-install-2.png)

This will install the SciChart.iOS Cocoapod. Now open the genertated SciChart.iOS.Examples.xcworkspace

![SciChart.iOS.Examples Workspace](http://scichart.com/wp-content/uploads/2017/03/pod-install-workspace.png)

This will open the Workspace with the SciChart.iOS Swift and ObjectiveC Examples. You can compile and run in a simulator, or on device from XCode. Select a scheme, and a device target, and go! 
