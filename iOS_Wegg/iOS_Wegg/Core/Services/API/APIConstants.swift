//
//  APIConstants.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 2/1/25.
//

import Foundation

/// API URL 정의한 상수 구조체
struct APIConstants {
    static let baseURL = "https://weggserver.store"
    
    struct Map {
        static let hotplacesURL = "/maps/hotplaces"
        static let schedulePlaceURL = "/maps/plans"
        static let schedulePlaceSearchURL = schedulePlaceURL + "/search"
    }
    
    struct Post {
        static let uploadRandomPost = "/posts"
    }
    
    struct Browse {
        static let fetchBrowsePosts = "/posts/view"
    }
}

