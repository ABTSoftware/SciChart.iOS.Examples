using Foundation;
using ObjCRuntime;
using UIKit;
using CoreGraphics;
using System;

namespace SciChart.iOS.Binding
{
	[BaseType(typeof(NSObject))]
	interface SCIAxisBase { }

	[BaseType(typeof(SCIAxisBase))]
	interface SCINumericAxis
	{
		[Static]
		[Export("new")]
		SCINumericAxis Create();

		[Export("visibleRange", ArgumentSemantic.Strong)]
		SCIDoubleRange VisibleRange { get; set; }
	}

	[BaseType(typeof(NSObject))]
	interface SCIRenderableSeriesBase
	{
		[Export("dataSeries", ArgumentSemantic.Strong)]
		SCIXyDataSeries DataSeries { get; set; }
	}

	[BaseType(typeof(SCIRenderableSeriesBase))]
	interface SCIFastLineRenderableSeries
	{
		[Static]
		[Export("new")]
		SCIFastLineRenderableSeries Create();
	}

	[BaseType(typeof(NSObject))]
	interface SCIAxisCollection
	{
		[Export("add:")] void Add(NSObject axis);
		[Export("count")]
		nint Count { get; }
	}

	[BaseType(typeof(NSObject))]
	interface SCIDoubleRange
	{
		[Export("initWithMin:max:")]
		IntPtr Constructor(NSNumber min, NSNumber max);

		[Export("min")]
		NSNumber Min { get; set; }

		[Export("max")]
		NSNumber Max { get; set; }
	}


	[BaseType(typeof(UIView))]
	interface SCIChartSurface
	{
		[Export("initWithFrame:")]
		IntPtr Constructor(CGRect frame);

		[Static]
		[Export("setRuntimeLicenseKey:")]
		void SetRuntimeLicenseKey(string licenseKey);

		[Export("xAxes")]
		SCIAxisCollection XAxes { get; }
		[Export("yAxes")]
		SCIAxisCollection YAxes { get; }
		[Export("renderableSeries")]
		SCIRenderableSeriesCollection RenderableSeries { get; }


		[Export("invalidateElement")]
		void InvalidateElement();
	}

	[BaseType(typeof(NSObject))]
	interface SCIXyDataSeries
	{
		// Bind the Objective-C initializer
		[Export("initWithXType:yType:")]
		IntPtr Constructor(SCIDataType xType, SCIDataType yType);

		// Bind the append method
		[Export("appendX:y:")]
		void Append(NSNumber x, NSNumber y);
	}

	[BaseType(typeof(NSObject))]
	interface SCIRenderableSeriesCollection
	{
		[Export("add:")]
		void Add(NSObject series);
		[Export("count")]
		nint Count { get; }
	}

}
