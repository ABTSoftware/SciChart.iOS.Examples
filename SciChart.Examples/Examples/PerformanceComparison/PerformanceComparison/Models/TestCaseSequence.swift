// ******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// TestCaseSequence.swift is part of the SCICHART® PerformanceComparison.
// Permission is hereby granted to modify, create derivative works,
// distribute and publish any part of this source code whether for commercial,
// private or personal use.
//
// The SCICHART® PerformanceComparison are distributed in the hope
// that they will be useful, but without any warranty. It is provided "AS IS"
// without warranty of any kind, either expressed or implied.
// ******************************************************************************

import UIKit

struct TestCaseSequence: Sequence {
    
    private let groups: [TestGroup]
    
    init() {
        groups = generateGroups(testPerGroup: nil)
    }
    
    init(testPerGroup: Int) {
        groups = generateGroups(testPerGroup: testPerGroup)
    }
    
    func makeIterator() -> Iterator {
        return Iterator(testGroups: groups)
    }
    
    struct Iterator: IteratorProtocol {
        let groups: [TestGroup]
        var currentGroupIndex: Int = 0
        var currentTestIndex: Int = 0
        
        var currentGroupTestCount: Int {
            return groups[currentGroupIndex].testParameters.count
        }
        
        init(testGroups: [TestGroup]) {
            groups = testGroups
        }
        
        mutating func next() -> TestCase? {
            var nextTestCase: TestCase? = nil
            
            let group = groups[currentGroupIndex]
            let parameters = group.testParameters
            
            if (currentTestIndex < parameters.count) {
                nextTestCase = parameters[currentTestIndex].createTestCase(chartProvider: group.provider, chartProviderParams: group.providerParams)
                currentTestIndex += 1
            }
            
            return nextTestCase
        }
        
        mutating func nextGroupTest() -> TestCase? {
            currentGroupIndex += 1
            currentTestIndex = 0
            
            return currentGroupIndex < groups.count ? next() : nil
        }
    }
}

func generateGroups(testPerGroup: Int?) -> [TestGroup] {
    var result = [TestGroup]()
    
    for provider in ChartProviderType.allCases {
        for params in provider.getParameters() {
            for type in TestType.typesToTest() {
                var parameters = type.getParameters()
                if let testPerGroup = testPerGroup {
                    parameters = Array(parameters.prefix(testPerGroup))
                }
                if (!parameters.isEmpty) {
                    result.append(TestGroup(provider: provider, providerParams: params, testParameters: parameters))
                }
            }
        }
    }
    
    return result
}
