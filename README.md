# SciChart.iOS.Examples

Examples, Showcase Applications and Tutorials for [SciChart.iOS](https://www.scichart.com): High Performance Realtime [iOS Chart Library](https://www.scichart.com/ios-chart-features). 

![iOS ECG Chart](https://www.scichart.com/wp-content/uploads/2017/04/ios-ecg-chart-framed.jpg#2)

Examples are provided in Swift3 & ObjectiveC. If you are looking for other platforms then please see here:

* [Android Charts](https://github.com/ABTSoftware/SciChart.Android.Examples) (Java / Kotlin)
* [WPF Charts](https://github.com/ABTSoftware/SciChart.WPF.Examples) (C# / WPF)
* [Xamarin Charts](https://github.com/ABTSoftware/SciChart.Xamarin.Examples) (C#) BETA!
* [NativeScript Charts](https://github.com/ABTSoftware/SciChart.NativeScript.Examples) (TypeScript / Javascript) ALPHA!

![iOS Bubble Chart](https://www.scichart.com/wp-content/uploads/2017/04/ios-bubble-chart-framed.jpg#2)

   *... Scroll down to see more awesomeness, setup instructions and tutorials ... :)*

![iOS Error Bars Chart](https://www.scichart.com/wp-content/uploads/2017/04/ios-error-bars-chart-framed.jpg#2)

![iOS Multi Pane Stock Chart](https://www.scichart.com/wp-content/uploads/2017/04/ios-multi-pane-stock-charts-framed.jpg#2)

![iOS Rollover Tooltips Chart](https://www.scichart.com/wp-content/uploads/2017/04/ios-rollover-tooltips-framed.jpg#2)

![iOS Stacked Column Chart](https://www.scichart.com/wp-content/uploads/2017/04/ios-stacked-column-chart-framed.jpg#2)

![iOS Realtime Ticking Stock Charts](https://www.scichart.com/wp-content/uploads/2017/04/ios-realtime-ticking-stock-charts-framed.jpg#2)

### Note: Cocoapods Feed Setup

To build, you will need an internet connection to download Cocoapods dependencies from the [SciChart PodSpec repository](https://github.com/ABTSoftware/PodSpecs.git). Podfiles are included [within the examples application directories themselves](https://github.com/ABTSoftware/SciChart.iOS.Examples/blob/master/v2.x/Showcase/Podfile), for example: 

```
# Define the SciChart cocoapods source
source 'https://github.com/ABTSoftware/PodSpecs.git'

# Define workspace
workspace 'SciChart.iOS.Showcase'

# Define projects
project 'SciChartShowcase/SciChartShowcaseDemo.xcodeproj'

# Define a global platform for your project
platform :ios, '8.0'

# Define pods for target SciChartShowcase
target 'SciChartShowcaseDemo' do
    use_frameworks!
    pod 'SciChart'
    project 'SciChartShowcase/SciChartShowcaseDemo.xcodeproj'
end
```

_You can find out how to install a Cocoapod by following the [Readme.md directions here](https://github.com/ABTSoftware/SciChart.iOS.Examples/tree/master/v2.x/Examples)_

# Repository Contents

## SciChart Showcase

The SciChart Showcase demonstrates some featured apps which show the speed, power and flexibility of the SciChart.iOS Chart library. This showcase is written in Swift3 and is designed to be a demonstration of what SciChart can do. Examples include:

![Realtime ECG Application with SciChart.iOS](https://www.scichart.com/wp-content/uploads/2017/06/scichart-medical-scientific-08.png)

* SciChart ECG: Realtime, 4-channel ECG for medical apps 
* SciChart Audio Analyzer: Realtime Audio Analyzer which records the mic, and presents Frequency Spectrum + Spectrogram on a live updating heatmap
* + more coming soon!

![Realtime Audio Analyzer with SciChart.iOS](https://www.scichart.com/wp-content/uploads/2017/06/scichart-medical-scientific-07.png)

## Examples 

The SciChart iOS Examples contain developer example code in ObjectiveC and Swift3 to help you get started as soon as possible with SciChart.iOS. 

![SciChart iOS Examples](https://www.scichart.com/wp-content/uploads/2017/04/XCode-header-for-github.png)

Chart types include: 

* [iOS Line Chart](https://www.scichart.com/ios-line-chart-demo/)
* [iOS Band Chart](https://www.scichart.com/ios-band-series-chart-demo/)
* [iOS Candlestick Chart](https://www.scichart.com/ios-candlestick-chart-demo/)
* [iOS Column Chart](https://www.scichart.com/ios-column-chart-demo/)
* [iOS Mountain / Area Chart](https://www.scichart.com/ios-mountain-chart-demo/) 
* [iOS Scatter Chart](https://www.scichart.com/ios-scatter-chart-demo/) 
* [iOS Impulse / Stem Chart](https://www.scichart.com/ios-impulse-chart/) 
* [iOS Bubble Chart](https://www.scichart.com/ios-bubble-chart-demo/)
* [iOS Fan Chart](https://www.scichart.com/ios-fan-chart/)
* [iOS Heatmap Chart](https://www.scichart.com/ios-heatmap-chart-demo/)
* [iOS Error Bars Chart](https://www.scichart.com/ios-fixed-error-bars/)
* [iOS Stacked Mountain Chart](https://www.scichart.com/ios-stacked-mountain-chart-demo/)
* iOS Stacked Column Chart
* iOS 100% Stacked Mountain Chart
* iOS 100% Stacked Column Chart]

## Tutorials 

SciChart iOS Comes with a number of tutorials to help you get started quickly using our powerful & flexible chart library! Please see below:

![SciChart iOS Tutorials now online](https://www.scichart.com/wp-content/uploads/2017/04/scichart-ios-tutorials-image.png)

* [Tutorial 01 Linking SciChart Framework](https://www.scichart.com/documentation/ios/v2.x/webframe.html#Tutorial%2001%20-%20Linking%20SciChart%20Framework.html)
* [Tutorial 02 Creating A SciChartSurface](https://www.scichart.com/documentation/ios/v2.x/webframe.html#Tutorial%2001%20-%20Linking%20SciChart%20Framework.html)
* [Tutorial 03 Adding Series](https://www.scichart.com/documentation/ios/v2.x/webframe.html#Tutorial%2003%20-%20Adding%20Series%20to%20a%20Chart.html)
* [Tutorial 04 Adding Zooming Panning](https://www.scichart.com/documentation/ios/v2.x/webframe.html#Tutorial%2004%20-%20Adding%20Zooming,%20Panning%20behavior.html)
* [Tutorial 05 Adding ToolTips And Legends](https://www.scichart.com/documentation/ios/v2.x/webframe.html#Tutorial%2005%20-%20Adding%20Tooltips%20and%20Legends.html)
* [Tutorial 06 Adding RealTime Updates](https://www.scichart.com/documentation/ios/v2.x/webframe.html#Tutorial%2006%20-%20Adding%20Realtime%20Updates.html)
* [Tutorial 07 Annotations](https://www.scichart.com/documentation/ios/v2.x/webframe.html#Tutorial%2007%20-%20Adding%20Annotations.html) 
* [Tutorial 08 Adding Multiple Axis](https://www.scichart.com/documentation/ios/v2.x/webframe.html#Tutorial%2008%20-%20Adding%20Multiple%20Axes.html) 
* [Tutorial 09 Adding Multiple Charts](https://www.scichart.com/documentation/ios/v2.x/webframe.html#Tutorial%2009%20-%20Linking%20Multiple%20Charts.html)

At the moment tutorials are provided in Swift3 only. We plan to expand these to ObjectiveC shortly!

## Tech Support and Help 

SciChart iOS is a commercial chart control with world-class tech support. If you need help integrating SciChart to your iOS apps, [Contact Us](https://www.scichart.com/contact-us) and we will do our best to help! 


*Enjoy! - @SciChart Team*

![SciChart iOS Chart Library Collage](https://www.scichart.com/wp-content/uploads/2017/04/ios-chart-examples-collage-perspective.jpg)
