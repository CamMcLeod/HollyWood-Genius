//
//  getYarnLoader.swift
//  HollywoodGenius
//
//  Created by Cameron Mcleod on 2019-06-24.
//  Copyright © 2019 Cameron Mcleod. All rights reserved.
//

import Foundation
import AVKit
import AVFoundation


func getYarnLoader(movieString : String) -> AVPlayer {
    
    let baseUrl1 = "https://getyarn.io/yarn-find?text=%3A%22"
    let query1 = baseUrl1 + movieString.replacingOccurrences(of: " ", with: "%20") + "%22"
    let url1 = URL(string: baseUrl1 + query1)!
    var videoString = "whoops"
    var clipString = "uhoh"
    var videoPlayer : AVPlayer = AVPlayer.init()
    
    let task1 = URLSession.shared.dataTask(with: url1) { (data, response, error) in
        guard let data = data else {
            print("data was nil")
            return
        }
        guard let htmlString = String(data: data, encoding: .utf8) else {
            print("couldn't cast data into String")
            return
        }
        let clipStart = htmlString.firstIndex(of: "🔥") ?? htmlString.endIndex
        let secondPart = htmlString[clipStart...]
        let clipToUID = secondPart.range(of: "video/")?.upperBound
        let stringUIDtoEnd = secondPart[clipToUID!...]
        let endofUID = stringUIDtoEnd.firstIndex(of: "\"")
        let index : String.Index
        index = endofUID!
        let stringUID = stringUIDtoEnd[..<index]
        videoString = String(stringUID)
        
        let baseUrl2 = "https://getyarn.io/video/"
        let url2 = URL(string: baseUrl2 + videoString)!
        
        let task2 = URLSession.shared.dataTask(with: url2) { (data, response, error) in
            guard let data = data else {
                print("data was nil")
                return
            }
            guard let htmlString = String(data: data, encoding: .utf8) else {
                print("couldn't cast data into String")
                return
            }
            let clipToUID = htmlString.range(of: "https://getyarn.io/yarn-clip/")?.upperBound
            let secondPart = htmlString[clipToUID!...]
            let endofUID = secondPart.firstIndex(of: "\"")
            let stringUID = htmlString[clipToUID!...]
            let index : String.Index
            index = endofUID!
            let clipUID = stringUID[..<index]
            clipString = String(clipUID)
            
            let url3 = URL(string: "https://y.yarn.co/" + clipString + ".mp4")!
            
            let task3 = URLSession.shared.dataTask(with: url3) { (data, response, error) in
                guard data != nil else {
                    print("data was nil")
                    return
                }
                
                videoPlayer = AVPlayer.init(url: url3)
                
            }
            
            task3.resume()
        }
        
        task2.resume()
    }
    
    task1.resume()
    
    return videoPlayer
}

