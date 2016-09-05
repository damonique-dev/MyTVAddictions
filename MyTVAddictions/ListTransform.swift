//
//  ListTransform.swift
//  MyTVAddictions
//
//  Created by Damonique Thomas on 9/2/16.
//  Copyright © 2016 Damonique Thomas. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper
import SwiftyJSON

class ListTransform<T:RealmSwift.Object where T:Mappable> : TransformType {
    typealias Object = List<T>
    typealias JSON = [AnyObject]
    
    let mapper = Mapper<T>()
    
    func transformFromJSON(value: AnyObject?) -> Object? {
        let results = List<T>()
        if let value = value as? [AnyObject] {
            for json in value {
                if let obj = mapper.map(json) {
                    results.append(obj)
                }
            }
        }
        return results
    }
    
    func transformToJSON(value: Object?) -> JSON? {
        var results = [AnyObject]()
        if let value = value {
            for obj in value {
                let json = mapper.toJSON(obj)
                results.append(json)
            }
        }
        return results
    }
}