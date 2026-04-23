using UIKit;
using CoreGraphics;
using Foundation;
using SciChart.iOS.Binding;
using System;

namespace SciChartDemoApp
{
    public class ViewController : UIViewController
    {
        public override void ViewDidLoad()
        {
            base.ViewDidLoad();
            // InvokeOnMainThread(() =>
            // {
            var surface = new SCIChartSurface(View.Bounds);
            surface.AutoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight;
            View.AddSubview(surface);

            var xAxis = new SCINumericAxis();
            xAxis.VisibleRange = new SCIDoubleRange(new NSNumber(0), new NSNumber(50));

            var yAxis = new SCINumericAxis();
            yAxis.VisibleRange = new SCIDoubleRange(new NSNumber(0), new NSNumber(10));

            surface.XAxes.Add(xAxis);
            surface.YAxes.Add(yAxis);

            var dataSeries = new SCIXyDataSeries(SCIDataType.Double, SCIDataType.Double);
            for (int i = 0; i < 100; i++)
            {
                var x = i;
                var y = Math.Sin(i * 0.1) * 10;
                dataSeries.Append(new NSNumber(x), new NSNumber(y));
            }


            var lineSeries = new SCIFastLineRenderableSeries();
            lineSeries.DataSeries = dataSeries;

            surface.RenderableSeries.Add(lineSeries);
            surface.InvalidateElement();
            // });

        }
    }
}
