using System;
using UIKit;
using SciChart.iOS.Charting;

namespace AddingToolTipsAndLegendModifier
{
    public partial class ViewController : UIViewController
    {
        private SCIChartSurface _surface;
        private XyDataSeries<Double, Double> _lineDataSeries;
        private XyDataSeries<Double, Double> _scatterDataSeries;


        private SCIFastLineRenderableSeries _lineRenderableSeries;
        private SCIXyScatterRenderableSeries _scatterRenderableSeries;

        public ViewController(IntPtr handle) : base(handle)
        {
        }

        public override void ViewDidLoad()
        {
            base.ViewDidLoad();
            // Perform any additional setup after loading the view, typically from a nib.
            _surface = new SCIChartSurface();
            _surface.TranslatesAutoresizingMaskIntoConstraints = true;
            _surface.Frame = this.View.Bounds;

            this.View.AddSubview(_surface);

            _surface.XAxes.Add(new SCINumericAxis());
            _surface.YAxes.Add(new SCINumericAxis());

            CreateDataSeries();
            CreateRenderableSeries();
            AddModifiers();
        }

        void CreateDataSeries()
        {
            // Init line data series
            _lineDataSeries = new XyDataSeries<Double, Double>();
            // Naming data series, so its name will be shown in LegendModifier
            _lineDataSeries.SeriesName = "LineSeries";
            for (var i = 0; i < 10; i++)
            {
                _lineDataSeries.Append(i, Math.Sin(i));
            }

            // Init scatter data series
            _scatterDataSeries = new XyDataSeries<Double, Double>();
            // Naming data series, so its name will be shown in LegendModifier
            _scatterDataSeries.SeriesName = "ScatterSeries";
            for (var i = 0; i < 10; i++)
            {
                _scatterDataSeries.Append(i, Math.Sin(i));
            }
        }

        void CreateRenderableSeries()
        {
            _lineRenderableSeries = new SCIFastLineRenderableSeries();
            _lineRenderableSeries.DataSeries = _lineDataSeries;


            _scatterRenderableSeries = new SCIXyScatterRenderableSeries();
            _scatterRenderableSeries.DataSeries = _scatterDataSeries;


            _surface.RenderableSeries.Add(_lineRenderableSeries);
            _surface.RenderableSeries.Add(_scatterRenderableSeries);
        }

        void AddModifiers()
        {
            var xAxisDragmodifier = new SCIXAxisDragModifier();
            xAxisDragmodifier.DragMode = SCIAxisDragMode.Pan;
            xAxisDragmodifier.ClipModeX = SCIClipMode.None;

            var yAxisDragmodifier = new SCIYAxisDragModifier();
            yAxisDragmodifier.DragMode = SCIAxisDragMode.Pan;

            var extendZoomModifier = new SCIZoomExtentsModifier();
            var pinchZoomModifier = new SCIPinchZoomModifier();

            // Adding Rollover and Legend modifiers
            var rolloverModifier = new SCIRolloverModifier();
            var legendCollectionModifier = new SCILegendModifier();

            var groupModifier = new SCIChartModifierCollection();
            groupModifier.Add(xAxisDragmodifier);
            groupModifier.Add(yAxisDragmodifier);
            groupModifier.Add(pinchZoomModifier);
            groupModifier.Add(extendZoomModifier);
            groupModifier.Add(rolloverModifier);
            groupModifier.Add(legendCollectionModifier);

            _surface.ChartModifiers = groupModifier;
        }

        public override void DidReceiveMemoryWarning()
        {
            base.DidReceiveMemoryWarning();
            // Release any cached data, images, etc that aren't in use.

        }
    }
}