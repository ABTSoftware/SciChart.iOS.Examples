//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// DataProviderBase.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

import Foundation
import RxSwift

protocol ISCIDataProvider {
    associatedtype E
    func getData() -> Observable<E>
}

class DataProviderBase<E>: ISCIDataProvider {
    
    private var dataObservable: Observable<E>!
    private var isStarted = false
    
    init(dispatchTimeInterval: DispatchTimeInterval) {
        dataObservable = Observable<Int>
            .interval(dispatchTimeInterval, scheduler: ConcurrentDispatchQueueScheduler(qos: .userInteractive))
            .map({ l in self.onNext() })
            .do(onError: { error in
                print("DataProvider onError: \(error.localizedDescription)")
            }, onCompleted: {
                self.tryStop()
            }, onSubscribe: {
                self.tryStart()
            }, onDispose: {
                self.tryStop()
            })
            .subscribe(on: MainScheduler.instance)
    }
    
    func getData() -> Observable<E> {
        return dataObservable
    }
    
    func tryStart() {
        if isStarted { return }
        
        onStart()
        isStarted = true
    }
    
    func tryStop() {
        if !isStarted { return }
        
        onStop()
        isStarted = false
    }
    
    func onStart() {}
    
    func onStop() {}
    
    func onNext() -> E {
        fatalError("Must be overrided")
    }
}
