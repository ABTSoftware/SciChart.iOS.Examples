//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2023. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// CustomSeriesInfoProvider.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

protocol CustomXySeriesTooltipDelegate {
    func getTouchDataSeriesIndex(dataSeriesIndex: Int)
}

protocol CustomSeriesInfoProviderDelegate {
    func getTouchDataSeriesIndex(dataSeriesIndex: Int)
}

class CustomSeriesInfoProvider: SCIDefaultXySeriesInfoProvider, CustomXySeriesTooltipDelegate {
    
    var delegate: CustomSeriesInfoProviderDelegate?
    
    class CustomXySeriesTooltip: SCIXySeriesTooltip {
        
        var tooltipDelegate: CustomXySeriesTooltipDelegate?
        
        override func internalUpdate(with seriesInfo: SCIXySeriesInfo) {
            var string = NSString.empty;
            string += "X: \(seriesInfo.formattedXValue.rawString)\n"
            string += "Y: \(seriesInfo.formattedYValue.rawString)"
            self.text = string;
            
            setSeriesColor(0xFFFFFFFF)
            
            tooltipDelegate?.getTouchDataSeriesIndex(dataSeriesIndex: seriesInfo.dataSeriesIndex)
        }
    }
    
    override func getSeriesTooltipInternal(seriesInfo: SCIXySeriesInfo, modifierType: AnyClass) -> ISCISeriesTooltip {
        if (modifierType == SCITooltipModifier.self) {
            let customXySeriesTooltip = CustomXySeriesTooltip(seriesInfo: seriesInfo)
            customXySeriesTooltip.tooltipDelegate = self
            return customXySeriesTooltip
        } else {
            return super.getSeriesTooltipInternal(seriesInfo: seriesInfo, modifierType: modifierType)
        }
    }
    
    func getTouchDataSeriesIndex(dataSeriesIndex: Int) {
        delegate?.getTouchDataSeriesIndex(dataSeriesIndex: dataSeriesIndex)
    }
}
