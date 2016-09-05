//
//  TVShow.swift
//  MyTVAddictions
//
//  Created by Damonique Thomas on 8/16/16.
//  Copyright © 2016 Damonique Thomas. All rights reserved.
//

import Foundation
import AlamofireObjectMapper
import ObjectMapper

class TVShow :Mappable {
    var id = 0
    var genreIds = [Int]()
    var title = ""
    var posterPath = ""
    var backdropPath = ""
    var overview  = ""
    var voteAverage = 0
    var posterImageData = NSData()
    var backdropImageData = NSData()
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        title <- map["name"]
        posterPath <- map["poster_path"]
        overview <- map["overview"]
        voteAverage <- map["vote_average"]
        genreIds <- map["genre_ids"]
        backdropPath <- map["backdrop_path"]
    }
    
}