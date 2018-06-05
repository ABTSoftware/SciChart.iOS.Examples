//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// CustomTooltipViewSwift.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

import UIKit

class CustomTooltipViewSwift: SCIXySeriesDataView {
    
    @IBOutlet weak var xLabel: UILabel!
    @IBOutlet weak var yLabel: UILabel!
    @IBOutlet weak var seriesName: UILabel!
    
    static override func createInstance() -> SCITooltipDataView! {
        let view : CustomTooltipViewSwift = (Bundle.main.loadNibNamed("CustomTooltipViewSwift", owner: nil, options: nil)![0] as? CustomTooltipViewSwift)!
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }
    
    func setData(_ data: SCIXySeriesInfo!) {
        xLabel.text = data.formatXCursorValue(data.xValue())
        yLabel.text = data.formatXCursorValue(data.yValue())
        seriesName.text = data.seriesName()
    }
}
