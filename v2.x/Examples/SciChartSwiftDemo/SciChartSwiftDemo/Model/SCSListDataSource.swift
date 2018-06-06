//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCSListDataSource.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

import Foundation

struct SCSDataSourceKeys: Codable {
    static let plistFileName = "ExampleListDataSource"
    static let keyCategories = "Categories"
    static let keyExampleName = "exampleName"
    static let keyExampleIcon = "exampleIcon"
    static let keyExampleDescription = "exampleDescription"
    static let keyExampleFile = "exampleFile"
}

struct SCSListDataSource {
    
    var dataSource = [String: [SCSExampleItem]]()
    var categoryNames = [String]()
    
    init() {
        if let path = Bundle.main.path(forResource: SCSDataSourceKeys.plistFileName, ofType: "plist") {
            if let myDict = NSDictionary(contentsOfFile: path) {
                if let categories = myDict.value(forKey: SCSDataSourceKeys.keyCategories) as? [String : [[String : String]]] {
                    var categoriesKeys = Array(categories.keys)
                    categoriesKeys = categoriesKeys.sorted(by: { (obj1, obj2) -> Bool in
                        let range1_ = obj1.range(of: "\\[([0-9]*?)\\]", options: .regularExpression, range: nil, locale: nil)
                        let range2_ = obj2.range(of: "\\[([0-9]*?)\\]", options: .regularExpression, range: nil, locale: nil)
                        
                        if let range1 = range1_, let range2 = range2_ {
                            var number1 = String(obj1[range1.lowerBound...range1.upperBound])
                            var number2 = String(obj2[range2.lowerBound...range2.upperBound])
                            
                            number1 = String(number1.dropFirst())
                            number1 = String(number1.dropLast(2))
                            number2 = String(number2.dropFirst())
                            number2 = String(number2.dropLast(2))
                           
                            let number_1 = Int(number1)!
                            let number_2 = Int(number2)!

                            if (number_1 < number_2) {
                                return true
                            } else {
                                return false
                            }
                        }
                        return false
                    })
                    
                    for i in 0..<categoriesKeys.count {
                        let categoryKey = categoriesKeys[i]
                        if  let range = categoryKey.range(of: "\\[([0-9]*?)\\]", options: .regularExpression, range: nil, locale: nil) {
                            let categoryName = categoryKey.replacingCharacters(in: range, with: "")
                            categoryNames.append(categoryName)
                        }
                        
                        var preparedItemsExample = [SCSExampleItem]()
                        if let itemsOfCategory = categories[categoryKey] {
                            
                            for exampleItem in itemsOfCategory {
                                if let exampleName = exampleItem[SCSDataSourceKeys.keyExampleName],
                                    let exampleIcon = exampleItem[SCSDataSourceKeys.keyExampleIcon],
                                    let exampleDescr = exampleItem[SCSDataSourceKeys.keyExampleDescription],
                                    let exampleClass = exampleItem[SCSDataSourceKeys.keyExampleFile] {
                                    if !exampleClass.isEmpty {
                                        preparedItemsExample.append(SCSExampleItem(exampleName, exampleIcon, exampleClass, exampleDescr))
                                    }
                                }
                            }
                        }
                        dataSource.updateValue(preparedItemsExample, forKey: categoryNames[i])
                    }
                }
            }
        }
    }
}
