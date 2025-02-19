//
//  SearchHotplaceRequest.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 2/19/25.
//

import Foundation

struct SearchHotplaceRequest: Encodable {
    let keyword: String
    let latitude: Double
    let longitude: Double
    let page: Int
    let size: Int
}
