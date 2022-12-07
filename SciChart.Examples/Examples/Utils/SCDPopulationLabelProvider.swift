//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2022. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// PopulationLabelProvider.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

class SCDPopulationLabelProvider: SCINumericLabelProvider {

    override func formatLabel(_ dataValue: ISCIComparable) -> ISCIString {
        // return a formatting string for tick labels
         return NSString(string: "\(setXValueWithAgeRange(Int(dataValue.toDouble())))" )
    }

    override func formatCursorLabel(_ dataValue: ISCIComparable) -> ISCIString {
        // return a formatting string for modifiers’ axis labels
        return formatLabel(dataValue)
    }
    func setXValueWithAgeRange(_ index: Int) -> String {
                switch index {
                case 0: return "100+"
                case 1: return "95-99"
                case 2: return "90-94"
                case 3: return "85-89"
                case 4: return "80-84"
                case 5: return "75-79"
                case 6: return "70-74"
                case 7: return "65-69"
                case 8: return "60-64"
                case 9: return "55-59"
                case 10: return "50-54"
                case 11: return "45-49"
                case 12: return "40-44"
                case 13: return "35-39"
                case 14: return "30-34"
                case 15: return "25-29"
                case 16: return "20-24"
                case 17: return "15-19"
                case 18: return "10-14"
                case 19: return "5-9"
                case 20: return "0-4"
                default: return ""
                }
            }
}
