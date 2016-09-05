//
//  TMDBClient.swift
//  MyTVAddictions
//
//  Created by Damonique Thomas on 8/16/16.
//  Copyright © 2016 Damonique Thomas. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper

class TMDBClient {
    
    var parameters = [ParameterKeys.APIKey:ParameterValues.APIKey]
    
    class func sharedInstance() -> TMDBClient {
        struct Singleton {
            static var sharedInstance = TMDBClient()
        }
        return Singleton.sharedInstance
    }
    
    func getPopularTVShows(completionHandler: (result: [TVShow]?, error: NSError?) -> Void) {
        let endpoint = URLFromParameters(Methods.TV_Popular, parameters: parameters)
        Alamofire.request(.GET, endpoint).responseArray(keyPath: "results") { (response: Response<[TVShow], NSError>) in
            guard let tvShows = response.result.value else {
                print("error getting popular tv shows ")
                let error = response.result.error!
                completionHandler(result: nil, error: error)
                return
            }
            completionHandler(result: tvShows, error: nil)
            
        }
    }
    
    func getTvShowInfo(id: String, completionHandler: (result: TVShowDetail?, error: NSError?) -> Void) {
        let method = subtituteKeyInMethod(Methods.TV_ShowInfo, key: URLKeys.ID, value: id)!
        let endpoint = URLFromParameters(method, parameters: parameters)

        Alamofire.request(.GET, endpoint).responseObject { (response: Response<TVShowDetail, NSError>) in
            guard let tvShow = response.result.value else {
                print("error getting tv show info ")
                let error = response.result.error!
                completionHandler(result: nil, error: error)
                return
            }
            completionHandler(result: tvShow, error: nil)
        }
    }
    
    func getTVSeasonInfo(id: String, seasonNum: String, completionHandler: (result: [Episode]?, error: NSError?) -> Void) {
        let tvMethod = subtituteKeyInMethod(Methods.TV_ShowInfo, key: URLKeys.ID, value: id)!
        let seasonMethod = subtituteKeyInMethod(Methods.TV_SeasonInfo, key: URLKeys.ID, value: seasonNum)!
        let endpoint = URLFromParameters((tvMethod+seasonMethod), parameters: parameters)

        Alamofire.request(.GET, endpoint).responseArray(keyPath: "episodes") { (response: Response<[Episode], NSError>) in
            guard let episodes = response.result.value else {
                print("error getting season episodes ")
                let error = response.result.error!
                completionHandler(result: nil, error: error)
                return
            }
            completionHandler(result: episodes, error: nil)
        }
    }
    
    func getTVSeasonCast(id: String, seasonNum: String, completionHandler: (result: [Cast]?, error: NSError?) -> Void) {
        let tvMethod = subtituteKeyInMethod(Methods.TV_ShowInfo, key: URLKeys.ID, value: id)!
        let seasonMethod = subtituteKeyInMethod(Methods.TV_SeasonCast, key: URLKeys.ID, value: seasonNum)!
        let endpoint = URLFromParameters((tvMethod+seasonMethod), parameters: parameters)
        
        Alamofire.request(.GET, endpoint).responseArray(keyPath: "cast") { (response: Response<[Cast], NSError>) in
            guard let cast = response.result.value else {
                print("error getting season episodes ")
                let error = response.result.error!
                completionHandler(result: nil, error: error)
                return
            }
            completionHandler(result: cast, error: nil)
        }
    }
    
    func getTVShowCast(id: String, completionHandler: (result: [Cast]?, error: NSError?) -> Void) {
        let tvMethod = subtituteKeyInMethod(Methods.TV_ShowCast, key: URLKeys.ID, value: id)!
        let endpoint = URLFromParameters(tvMethod, parameters: parameters)
        
        Alamofire.request(.GET, endpoint).responseArray(keyPath: "cast") { (response: Response<[Cast], NSError>) in
            guard let cast = response.result.value else {
                print("error getting show cast")
                let error = response.result.error!
                completionHandler(result: nil, error: error)
                return
            }
            completionHandler(result: cast, error: nil)
        }
    }
    
    func searchTV(query: String,  completionHandler: (result: [TVShow]?, error: NSError?) -> Void) {
        parameters[ParameterKeys.SearchQuery] = query
        let endpoint = URLFromParameters(Methods.TV_Search, parameters: parameters)
        
        Alamofire.request(.GET, endpoint).responseArray(keyPath: "results") { (response: Response<[TVShow], NSError>) in
            guard let tvShows = response.result.value else {
                print("error getting popular tv shows ")
                let error = response.result.error!
                completionHandler(result: nil, error: error)
                return
            }
            completionHandler(result: tvShows, error: nil)
            
        }
    }

}