//
//  TMDBHelpers.swift
//  MyTVAddictions
//
//  Created by Damonique Thomas on 8/20/16.
//  Copyright © 2016 Damonique Thomas. All rights reserved.
//

import Foundation

extension TMDBClient {
    
    func URLFromParameters(withPathExtension: String?, parameters: [String:AnyObject]) -> String {
        let components = NSURLComponents()
        components.scheme = Constants.ApiScheme
        components.host = Constants.ApiHost
        components.path = Constants.ApiPath + (withPathExtension ?? "")
        components.queryItems = [NSURLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = NSURLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.URL!.absoluteString
    }
    
    func getPhoto(photoURL: String, completionHandler:(imageData: NSData?)->Void) {
        let url = NSURL(string: photoURL)
        if let imageData = NSData(contentsOfURL: url!) {
            completionHandler(imageData: imageData)
        }
        else {
            completionHandler(imageData: nil)
        }
    }
    
    func subtituteKeyInMethod(method: String, key: String, value: String) -> String? {
        if method.rangeOfString("{\(key)}") != nil {
            return method.stringByReplacingOccurrencesOfString("{\(key)}", withString: value)
        } else {
            return nil
        }
    }
    
}
