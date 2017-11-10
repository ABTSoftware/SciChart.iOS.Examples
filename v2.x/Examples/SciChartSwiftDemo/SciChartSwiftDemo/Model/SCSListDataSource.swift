//
//  SCSListDataSource.swift
//  SciChartSwiftDemo
//
//  Created by Hrybenuik Mykola on 4/27/17.
//  Copyright © 2017 SciChart Ltd. All rights reserved.
//

import Foundation

struct SCSDataSourceKeys : Codable {
    static let plistFileName = "ExampleListDataSource"
    static let keyCategories = "Categories"
    static let keyExampleName = "exampleName"
    static let keyExampleIcon = "exampleIcon"
    static let keyExampleDescription = "exampleDescription"
    static let keyExampleFile = "exampleSwiftFile"
}

struct SCSListDataSource {
    
    var dataSource = [String : [SCSExampleItem]]()
    var categoryNames = [String]()
    
    init() {
        
        if let path = Bundle.main.path(forResource: SCSDataSourceKeys.plistFileName, ofType: "plist") {
            
            if let myDict = NSDictionary(contentsOfFile: path) {
                
                if let categories = myDict.value(forKey: SCSDataSourceKeys.keyCategories) as? [String : [[String : String]]] {
                    
                    var categoriesKeys = Array(categories.keys)
                    
                    categoriesKeys = categoriesKeys.sorted(by: { (obj1, obj2) -> Bool in
                        
                        let range1_ = obj1.range(of: "\\[([0-9]*?)\\]", options: .regularExpression, range: nil, locale: nil)
                        let range2_ = obj2.range(of: "\\[([0-9]*?)\\]", options: .regularExpression, range: nil, locale: nil)
                        
                        if let range1 = range1_,
                            let range2 = range2_ {
                            
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
                            }
                            else {
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
                                        if exampleClass.characters.count > 0 {
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
