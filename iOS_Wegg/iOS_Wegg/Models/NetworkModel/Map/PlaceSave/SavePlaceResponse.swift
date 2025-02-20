//
//  SavePlaceResponse.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 2/21/25.
//

import Foundation

struct SavePlaceResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: MyAddress
    
    struct MyAddress: Decodable {
        let myAddressId: Int
    }
}
