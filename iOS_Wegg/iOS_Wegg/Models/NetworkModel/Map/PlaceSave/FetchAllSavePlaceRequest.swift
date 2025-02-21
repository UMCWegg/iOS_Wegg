//
//  FetchAllBookMarkPlaceRequest.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 2/21/25.
//

import Foundation

struct FetchAllBookMarkPlaceRequest: Encodable {
    let page: Int
    let size: Int
}
