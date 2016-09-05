//
//  TMDBConstants.swift
//  MyTVAddictions
//
//  Created by Damonique Thomas on 8/16/16.
//  Copyright © 2016 Damonique Thomas. All rights reserved.
//

import Foundation

extension TMDBClient {
    
    struct Constants {
        static let ApiScheme = "https"
        static let ApiHost = "api.themoviedb.org"
        static let ApiPath = "/3"
        static let ImageURL = "https://image.tmdb.org/t/p/original"
    }
    
    struct ParameterKeys {
        static let APIKey = "api_key"
        static let SearchQuery = "query"
    }
    
    struct ParameterValues {
        static let APIKey = "9eb3d1e5b7c7f5aacc725a42ed178fa0"
    }
    
    struct Methods {
        static let TV_Popular = "/tv/popular"
        static let TV_Genres = "/genre/tv/list"
        static let TV_ShowInfo = "/tv/{id}"
        static let TV_ShowCast = "/tv/{id}/credits"
        static let TV_SeasonInfo = "/season/{id}"
        static let TV_SeasonCast = "/season/{id}/credits"
        static let TV_Search = "/search/tv"
    }
    
    struct URLKeys {
        static let ID = "id"
    }
    
    struct ResponseKeys {
        
    }
    
    struct PosterSizes {
        static let Original = "original"
        static let Thumbnail = "w92"
        static let Detail = "w500"
    }
}