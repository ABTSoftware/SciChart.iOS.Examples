using System;
using UIKit;
using SciChart.iOS.Charting;

namespace CreatingSciChartSurface
{
    public partial class ViewController : UIViewController
    {
        private SCIChartSurface _surface;

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
        }
        
        public override void DidReceiveMemoryWarning()
        {
            base.DidReceiveMemoryWarning();
            // Release any cached data, images, etc that aren't in use.
        }
    }

}