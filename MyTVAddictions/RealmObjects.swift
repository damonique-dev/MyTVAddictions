//
//  RealmObjects.swift
//  MyTVAddictions
//
//  Created by Damonique Thomas on 9/1/16.
//  Copyright © 2016 Damonique Thomas. All rights reserved.
//

import Foundation
import RealmSwift
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

class TVShowDetail: Object, Mappable  {
    dynamic var id = 0
    dynamic var title = ""
    dynamic var posterPath = ""
    dynamic var overview = ""
    dynamic var numberOfSeasons = 0
    dynamic var posterImageData: NSData? = nil
    
    let rating = RealmOptional<Int>()
    var seasons = List<Season>()
    var cast = List<Cast>()
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        title <- map["name"]
        posterPath <- map["poster_path"]
        overview <- map["overview"]
        seasons <- (map["seasons"], ListTransform<Season>())
        numberOfSeasons <- map["number_of_seasons"]
    }
}

class Season: Object, Mappable {
    dynamic var id = 0
    dynamic var numberOfEpisodes = 0
    dynamic var seasonNum = 0
    dynamic var posterPath = ""
    dynamic var posterImageData: NSData? = nil
    
    var episodes = List<Episode>()
    var show = LinkingObjects(fromType: TVShowDetail.self, property: "seasons")
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        numberOfEpisodes <- map["episode_count"]
        posterPath <- map["poster_path"]
        seasonNum <- map["season_number"]
    }
}

class Episode: Object, Mappable {
    dynamic var id = 0
    dynamic var name = ""
    dynamic var episodeNum = 0
    dynamic var overview = ""
    dynamic var imagePath = ""
    dynamic var airDate = ""
    dynamic var imageData: NSData? = nil
    
    var guestCast = List<Cast>()
    let rating = RealmOptional<Int>()
    var season = LinkingObjects(fromType: Season.self, property: "episodes")
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        airDate <- map["air_date"]
        episodeNum <- map["episode_number"]
        overview <- map["overview"]
        imagePath <- map["still_path"]
        guestCast <- (map["guest_stars"], ListTransform<Cast>())
    }
}

class Cast: Object, Mappable {
    dynamic var id = 0
    dynamic var name = ""
    dynamic var imagePath = ""
    dynamic var imageData: NSData? = nil
    
    var show = LinkingObjects(fromType: TVShowDetail.self, property: "cast")
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        imagePath <- map["profile_path"]
    }
}