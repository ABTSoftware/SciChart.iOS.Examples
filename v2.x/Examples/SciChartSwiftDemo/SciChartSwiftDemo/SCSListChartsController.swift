//
//  SCSListChartsController.swift
//  SciChartSwiftDemo
//
//  Created by Mykola Hrybeniuk on 6/1/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

import UIKit
import SciChart

class SCSListChartsController: UITableViewController {
    
    let cellId = "CellId"
    let listChartsName = ["SCSLineChartView", "SCSDigitalLineChartView", "SCSUsingRolloverModifierChartView","SCSColumnChartView", "SCSMountainChartView", "SCSDigitalMountainChartView", "SCSCandlestickChartView", "SCSScatterSeriesChartView", "SCSHeatmapChartView", "SCSBubbleChartView", "SCSBandChartView", "SCSDigitalBandChartView","SCSStackedMountainChartView", "SCSECGChartView", "SCSAnnotationsChartView", "SCSMultipleAxesChartView", "SCSMultipleSurfaceChartView", "SCSLinePerformanceChartView", "SCSAppendSpeedTestSciChart", "SCSFIFOSpeedTestSciChart", "SCSNxMSeriesSpeedTestSciChart", "SCSScatterSpeedTestSciChart", "SCSSeriesAppendingTestSciChart", "SCSRealtimeTickingStockChartView", "SCSMultiPaneStockChartView", "SCSPalettedChartView", "SCSLegendChartView", "SCSUsingTooltipModifierChartView", "SCSUsingCursorModifierChartView", "SCSRolloverCustomizationChartView", "SCSCursorCustomizationChartView", "SCSTooltipCustomizationChartView", "SCSImpulseChartView", "SCSCustomModifierView", "SCSErrorBarsChartView", "SCSFanChartView", "SCSColumnDrillDownView", "SCSStackedColumnChartView", "SCSStackedColumnSideBySideChartView", "SCSStackedColumnVerticalChartView", "SCSThemeProviderUsingChartView", "SCSThemeCustomChartView", "SCSSeriesSelectionView"];
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listChartsName.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellId")
        cell?.textLabel?.text = String(listChartsName[indexPath.row])
        return cell!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowChartSegueId" {
         
            if let chartController = segue.destination as? SCSChartViewController, let cell = sender as? UITableViewCell {
                let indexPath = tableView.indexPath(for: cell)!
                let className = "SciChartSwiftDemo."+listChartsName[indexPath.row];
                let chartViewClass = NSClassFromString(className) as! UIView.Type
                chartController.setupView(chartViewClass)
                chartController.title = listChartsName[indexPath.row]
                
            }
        }
    }
    
    
}
