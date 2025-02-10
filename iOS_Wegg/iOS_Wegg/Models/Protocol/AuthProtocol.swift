//
//  AuthProtocol.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.02.10.
//

import Foundation

protocol AuthRequest: Codable {
    var email: String? { get }
    var socialType: SocialType? { get }
    var oauthID: String? { get }
}

protocol AuthResponse: Codable {
    var accessToken: String { get }
    var refreshToken: String? { get }
}
