//
//  DeletePlaceResponse.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 2/21/25.
//

import Foundation

struct DeletePlaceResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: Result
    
    struct Result: Decodable {
        let success: Bool
        let myAddressId: Int
    }
}
