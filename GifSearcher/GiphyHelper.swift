//
//  GiphyHelper.swift
//  GifSearcher
//
//  Created by Yang, Zebin (Contractor) on 8/27/17.
//  Copyright © 2017 Yang, Zebin. All rights reserved.
//

import UIKit
import RxSwift
import Alamofire
import ImageIO

class Gif: NSObject {
    var url: URL?
    var height: Float?
    var width: Float?
    
}

class GiphyHelper: NSObject {
    static let shared = GiphyHelper()
    fileprivate let apiKey = "78d4b8d11ca74a53ad5ddf67fd64b8f5"
    fileprivate let baseUrl = "https://api.giphy.com"
    fileprivate let trendingPath = "/v1/gifs/trending"
    fileprivate let searchPath = "/v1/gifs/search"
    
    let gifs: Variable<[Gif]> = Variable([])

    func fetchTrendingGifs() {
        guard let base = URL(string: baseUrl) else { return }
        let urlWithPath = base.appendingPathComponent(trendingPath)
        var urlComponents = URLComponents(url: urlWithPath, resolvingAgainstBaseURL: false)
        urlComponents?.queryItems = [URLQueryItem(name: "api_key", value: apiKey),
                                     URLQueryItem(name: "limit", value: "11")]
        
        guard let url = urlComponents?.url else { return }
        Alamofire.request(url, method: .get).responseJSON { (response) in
            guard response.result.isSuccess == true,
                let jsonDict = response.result.value as? [String: AnyObject] else { return }
            
            guard let parsedGif = self.parseJsonData(jsonDict), parsedGif.isEmpty == false else { return }
            
            self.gifs.value = parsedGif
        }
    }
    
    func fetchSearchedGifs(_ searchedContent: String) {
        guard let base = URL(string: baseUrl) else { return }
        let urlWithPath = base.appendingPathComponent(searchPath)
        var urlComponents = URLComponents(url: urlWithPath, resolvingAgainstBaseURL: false)
        urlComponents?.queryItems = [URLQueryItem(name: "api_key", value: apiKey),
                                     URLQueryItem(name: "limit", value: "8"),
                                     URLQueryItem(name: "q", value: searchedContent)]
        
        guard let url = urlComponents?.url else { return }
        Alamofire.request(url, method: .get).responseJSON { (response) in
            guard response.result.isSuccess == true,
                let jsonDict = response.result.value as? [String: AnyObject] else { return }
            
            guard let parsedGif = self.parseJsonData(jsonDict), parsedGif.isEmpty == false else { return }
            
            self.gifs.value = parsedGif
        }
    }
    
    fileprivate func parseJsonData(_ jsonDict: [String: AnyObject]) -> [Gif]? {
        guard let data = jsonDict["data"] as? [Any] else { print("Parse Failed: no data key"); return nil }
        var gifsToReturn = [Gif]()
        for object in data {
            guard let gifInArray = object as? [String: AnyObject], let images = gifInArray["images"] as? [String: AnyObject] else {
                print("Parse Failed: no images key")
                return nil
            }
            guard let original = images["original"] as? [String: AnyObject] else {
                print("Parse Failed: no original key")
                return nil
            }
            guard let urlString = original["url"] as? String, let heightString = original["height"] as? String, let widthString = original["width"] as? String else {
                print("Parse Failed: no url/height/width key")
                return nil
            }
            
            let gif = Gif()
            guard let url = URL(string: urlString) else { return nil}
            gif.url = url
            gif.height = Float(heightString)
            gif.width = Float(widthString)
            
            gifsToReturn.append(gif)
        }
        
        return gifsToReturn
    }
    
}


