//
//  Genre.swift
//  MyTVAddictions
//
//  Created by Damonique Thomas on 8/16/16.
//  Copyright © 2016 Damonique Thomas. All rights reserved.
//

import Foundation
import AlamofireObjectMapper
import ObjectMapper

class Genre :Mappable {
    var id = 0
    var name = ""
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
    }
    
}