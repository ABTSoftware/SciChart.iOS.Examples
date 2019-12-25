# SciChart.iOS Examples
Examples and Tutorials for [SciChart.iOS](https://www.scichart.com): High Performance Realtime [iOS Chart Library](https://www.scichart.com/ios-chart-features/)

<a href="https://www.youtube.com/watch?v=dArRzOPawQI" target="\_blank" Title="SciChart iOS Charts Video"><img Align="center" src="https://www.scichart.com/wp-content/uploads/2017/09/ios-thumbnail-homepage.jpg" Alt="SciChart iOS Charts Video"/></a>

<img Align="left" Width="420" src="https://abtsoftware-wpengine.netdna-ssl.com/wp-content/uploads/2017/05/ios-v2-bubble-chart.png" Alt="iOS Bubble Chart Example"/>
<img Align="left" Width="420" src="https://abtsoftware-wpengine.netdna-ssl.com/wp-content/uploads/2017/05/ios-v2-multi-pane-stock-chart.png" Alt="iOS Multi-Pane Stock Chart Example"/>
<img Align="left" Width="420" src="https://abtsoftware-wpengine.netdna-ssl.com/wp-content/uploads/2017/05/ios-v2-stacked-grouped-column-chart-2.png" Alt="iOS Stacked Columns Side by Side Chart Example"/>
<img Align="left" Width="420" src="https://www.scichart.com/wp-content/uploads/2019/10/scichart-ios-3d-charts-waterfall-chart-example-min.png" Alt="iOS Waterfall 3D Chart Example"/>
<img Align="left" Width="420" src="https://www.scichart.com/wp-content/uploads/2019/10/scichart-ios-3d-charts-uniform-mesh-chart-example-min.png" Alt="iOS Uniform Surface Mesh 3D Chart Example"/>

iOS Chart Examples are provided in Objective-C & Swift. If you are looking for other platforms then please see here:

* [Android Charts](https://github.com/ABTSoftware/SciChart.Android.Examples) (Java / Kotlin)
* [WPF Charts](https://github.com/ABTSoftware/SciChart.WPF.Examples) (C# / WPF)
* [Xamarin Charts](https://github.com/ABTSoftware/SciChart.Xamarin.Examples) (C#)

## Repository Contents:
In **Examples** directory you'll find a simple example app which showcases all the built-in features of SciChart framework, and also demonstrates some customizations.

SciChart iOS Comes with a number of tutorials to help you get started quickly using our powerful & flexible chart library! 
In **Tutorials/tutorials-2d** directory you'll find the final projects for all the SciChart [2D Tutorials](https://www.scichart.com/documentation/ios/current/Tutorials%202D.html)
In **Tutorials/tutorials-3d** you'll find the final projects for all the SciChart [3D Tutorials](https://www.scichart.com/documentation/ios/current/Tutorials%203D.html)

## How to use this repository
Examples and Tutorials projects are linked with SciChart via [Cocoapods](https://cocoapods.org). So in order to test and run examples suite you need to have cocoapods installed. This can be done by typing a simple command in terminal:

    [sudo] gem install cocoapods

### Build Examples
Our examples project named SciChartDemo. So If you have installed cocoapods you can simply link SciChartDemo project with SciChart.framework via cocoapods using the following terminal commands:

    cd YourRepositoryRoot/Examples
    pod install --repo-update

In case of successful installation of CocoaPods, you'll see the generated SciChart.iOS.Examples.xcworkspace, which links an SciChartDemo.xcproject with SciChart.framework:
![SciChart examples Folder Structure](https://www.scichart.com/wp-content/uploads/2019/11/Screenshot-2019-11-20-at-18.13.01.png) 

Open a workspace and build "SciChartDemo" scheme, you can now run and test all the examples you provide.

## Build Tutorials
SciChart iOS Comes with a number of tutorials to help you get started quickly using our powerful & flexible chart library! Please see below:

- [Tutorials 2D](https://www.scichart.com/documentation/ios/current/Tutorials%202D.html)
    - [Tutorial 01 - Create a simple 2D Chart](https://www.scichart.com/documentation/ios/current/tutorial-01---create-a-simple-2d-chart.html)
    - [Tutorial 02 - Zooming and Panning Behavior](https://www.scichart.com/documentation/ios/current/tutorial-02---zooming-and-panning-behavior.html)
    - [Tutorial 03 - Tooltips and Legends](https://www.scichart.com/documentation/ios/current/tutorial-03---tooltips-and-legends.html)
    - [Tutorial 04 - Adding Realtime Updates](https://www.scichart.com/documentation/ios/current/tutorial-04---adding-realtime-updates.html)
    - [Tutorial 05 - Annotations](https://www.scichart.com/documentation/ios/current/tutorial-05---annotations.html)
    - [Tutorial 06 - Multiple Axis](https://www.scichart.com/documentation/ios/current/tutorial-06---multiple-axis.html)
    - [Tutorial 07 - Linking Multiple Charts](https://www.scichart.com/documentation/ios/current/tutorial-07---linking-multiple-charts.html)
- [Tutorials 3D](https://www.scichart.com/documentation/ios/current/Tutorials%203D.html)
    - [3D Tutorial 01 - Create a simple Scatter Chart 3D](https://www.scichart.com/documentation/ios/current/3d-tutorial-01---create-a-simple-scatter-chart-3d.html)
    - [3D Tutorial 02 - Zooming and Rotating](https://www.scichart.com/documentation/ios/current/3d-tutorial-02---zooming-and-rotating.html)`
    - [3D Tutorial 03 - Cursors and Tooltips](https://www.scichart.com/documentation/ios/current/3d-tutorial-03---cursors-and-tooltips.html)
    - [3D Tutorial 04 - Plotting Realtime Data](https://www.scichart.com/documentation/ios/current/3d-tutorial-04---plotting-realtime-data.html)

The process of building tutorials is quite similar. Just note, that there are two sub-folders in "Tutorials" directory.
And separate podfile in each sub-folder ("tutorials-2d and tutorials-3d"). 
All you need to do is run "pod install" command from the directory where corresponding `Podfile` is located:

    cd YourRepositoryRoot/Tutorials/tutorials-2d
    pod install --repo-update

In case of tutorials, workspace contains a separate scheme for each tutorial. Just select the scheme you want to try - build and run:

![Build SciChart Tutorials](https://www.scichart.com/wp-content/uploads/2019/11/Screenshot-2019-11-21-at-11.49.49.png)