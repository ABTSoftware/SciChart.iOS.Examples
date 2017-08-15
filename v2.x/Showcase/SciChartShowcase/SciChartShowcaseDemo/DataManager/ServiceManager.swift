//
//  ServiceManager.swift
//  SciChartShowcaseDemo
//
//  Created by Hrybeniuk Mykola on 7/15/17.
//  Copyright © 2017 SciChart Ltd. All rights reserved.
//

import Foundation

protocol Mappable {
    
    init(with responseString: String)
    
}

enum RequsetType: String {
    case get = "GET"
    case post = "POST"
}

typealias CompletionHandler<T> = (_ succes: Bool, _ object: T?) -> ()

//"https://www.google.com/finance/getprices?q=GOOG&x=NASD&i=86400&p=40Y&f=d,c,v,k,o,h,l"

class ServiceManager {
    
    func makeRequest<T: Mappable>(_ urlString: String, _ httpParams: [String : String]?, requestType: RequsetType, handler:@escaping CompletionHandler<T>) {
        
        var fullUrl = urlString
        
        if let params = httpParams, params.count > 0 {
            var paramsPart = "?"
            for key in params.keys {
                if let value = params[key] {
                    paramsPart = paramsPart+key+"="+value+"&"
                }
            }
            fullUrl = fullUrl+paramsPart
        }
        
        if let url = URL(string: fullUrl) {
            let session = URLSession.shared
            let request = NSMutableURLRequest(url: url)
            request.httpMethod = requestType.rawValue
            request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
            let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
                
                guard let dataResponse: Data = data, let _: URLResponse = response, error == nil else {
                    DispatchQueue.main.async {
                        handler(false, nil)
                    }
                    return
                }
                
                if let dataString = String.init(data: dataResponse, encoding: .utf8) {
  
                    let mappableObject = T(with: dataString)
                    DispatchQueue.main.async {
                        handler(true, mappableObject)
                    }
                    
                }
                else {
                    DispatchQueue.main.async {
                        handler(false, nil)
                    }
                }
                
            }
            task.resume()
        }
      
    }
    
    func getPrices(with stockIndex: StockIndex, timeScale: TimeScale, period: TimePeriod,  handler: @escaping CompletionHandler<StockPrices>) {
        
        let params = ["q" : stockIndex.rawValue,
                      "i" : String(timeScale.rawValue),
                      "p" : period.rawValue,
                      "f" : "d,c,v,k,o,h,l"]
        
        let baseUrl = "https://www.google.com/finance/getprices"
        
        makeRequest(baseUrl, params, requestType: .get, handler: handler)
        
    }
    
}
