//
//  YoutubeSearchResponse.swift
//  NetFlix Clone
//
//  Created by Jonrel Baclayon on 7/7/24.
//

import Foundation

struct YoutubeSearchResponse: Codable {
    let items: [VideoElement]
}

struct VideoElement: Codable {
    let id: IDVideoElement
}

struct IDVideoElement: Codable {
    let videoId: String
}

/*
 {
     etag = "r_ldkFhx2XrMg7si5LHiaLa2c2o";
     items =     (
                 {
             etag = "lk8409-m28s-u0WqMRhDC0vgfsE";
             id =             {
                 kind = "youtube#video";
                 videoId = 0Dj2kq5Neus;
             };
             kind = "youtube#searchResult";
         },
 */
