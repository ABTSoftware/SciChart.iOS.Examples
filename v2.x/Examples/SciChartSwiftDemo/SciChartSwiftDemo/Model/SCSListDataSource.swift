//
//  SCSListDataSource.swift
//  SciChartSwiftDemo
//
//  Created by Hrybenuik Mykola on 4/27/17.
//  Copyright © 2017 SciChart Ltd. All rights reserved.
//

import Foundation

struct SCSDataSourceKeys {
    static let plistFileName = "ExampleListDataSource"
    static let keyCategories = "Categories"
//    static let keyCategoryName = "CategoryName"
//    static let keyCategoryItems = "CategoryItems"
    static let keyExampleName = "exampleName"
    static let keyExampleIcon = "exampleIcon"
    static let keyExampleDescription = "exampleDescription"
    static let keyExampleFile = "exampleSwiftFile"
}

struct SCSListDataSource {
    
    var dataSource = [String : [SCSExampleItem]]()
    
    init() {
        
        if let path = Bundle.main.path(forResource: SCSDataSourceKeys.plistFileName, ofType: "plist") {
            
            if let myDict = NSDictionary(contentsOfFile: path) {
                
                if let categories = myDict.value(forKey: SCSDataSourceKeys.keyCategories) as? [String : [[String : String]]] {
                    
                    let categoriesKeys = categories.keys
//                    let categoriesValues = categories.values
                    
                    for categoryName in categoriesKeys {
                        
//                        if let categoryName = category.value(forKey: SCSDataSourceKeys.keyCategoryName) as? String {
                        
                            var preparedItemsExample = [SCSExampleItem]()
                            
                            if let itemsOfCategory = categories[categoryName] {
                                
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
                            
                            dataSource.updateValue(preparedItemsExample, forKey: categoryName)
                            
                            
                        //}
 
                    }
                }
            }
        }
    }
    
}
