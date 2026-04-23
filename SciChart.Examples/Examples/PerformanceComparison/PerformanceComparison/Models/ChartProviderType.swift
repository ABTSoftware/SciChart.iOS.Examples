// ******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// ChartProviderType.swift is part of the SCICHART® PerformanceComparison.
// Permission is hereby granted to modify, create derivative works,
// distribute and publish any part of this source code whether for commercial,
// private or personal use.
//
// The SCICHART® PerformanceComparison are distributed in the hope
// that they will be useful, but without any warranty. It is provided "AS IS"
// without warranty of any kind, either expressed or implied.
// ******************************************************************************

import UIKit

enum ChartProviderType : String, CaseIterable {
    case corePlot = "CorePlot"
    case charts = "Charts"
    case sciChart = "SciChart"
    
    func getParameters() -> [IChartProviderParameters] {
        switch self {
        case .sciChart:
            return [SciChartParameters(),
                    // SciChartParameters(useMetal: false),
                    // SciChartParameters(useMetal: false, resamplingMode: .none),
                    // SciChartParameters(useMetal: true, resamplingMode: .none)
            ]
        default:
            return [OtherChartProviderParameters()]
        }
    }
}
