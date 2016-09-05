//
//  TVShowDetail.swift
//  MyTVAddictions
//
//  Created by Damonique Thomas on 8/20/16.
//  Copyright © 2016 Damonique Thomas. All rights reserved.
//

import Foundation
import AlamofireObjectMapper
import ObjectMapper

//class TVShowDetail :Mappable {
//    var id = 0
//    var genres = [Genre]()
//    var title = ""
//    var posterPath = ""
//    var overview  = ""
//    var numberOfSeasons = 0
//    var seasons = [Season]()
//    
//    required convenience init?(_ map: Map) {
//        self.init()
//    }
//    
//    func mapping(map: Map) {
//        id <- map["id"]
//        title <- map["name"]
//        posterPath <- map["poster_path"]
//        overview <- map["overview"]
//        genres <- map["genres"]
//        seasons <- map["seasons"]
//        numberOfSeasons <- map["number_of_seasons"]
//    }
//}
//
//class Genres: Mappable {
//    var name = ""
//    
//    required convenience init?(_ map: Map) {
//        self.init()
//    }
//    
//    func mapping(map: Map) {
//        name <- map["name"]
//    }
//
//}
//
//class Season: Mappable {
//     var id = 0
//     var numbOfEpisodes = 0
//     var posterPath = ""
//     var seasonNum = 0
//    
//    required convenience init?(_ map: Map) {
//        self.init()
//    }
//    
//    func mapping(map: Map) {
//        id <- map["id"]
//        numbOfEpisodes <- map["episode_count"]
//        posterPath <- map["poster_path"]
//        seasonNum <- map["season_number"]
//    }
//}
//
//class Episode: Mappable {
//    var id = 0
//    var name = ""
//    var airDate = ""
//    var episodeNum = 0
//    var overview = ""
//    var imagePath = ""
//    
//    required convenience init?(_ map: Map) {
//        self.init()
//    }
//    
//    func mapping(map: Map) {
//        id <- map["id"]
//        name <- map["name"]
//        airDate <- map["air_date"]
//        episodeNum <- map["episode_number"]
//        overview <- map["overview"]
//        imagePath <- map["still_path"]
//    }
//    
//}
