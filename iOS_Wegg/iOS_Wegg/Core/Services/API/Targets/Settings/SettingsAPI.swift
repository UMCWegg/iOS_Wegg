//
//  SettingsAPI.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.02.17.
//

import Foundation

import Moya

enum SettingsAPI {
    case updateProfile(name: String, accountId: String, profileImage: Data?)
    case updateSettings(settings: SettingsUpdateRequest)
}

extension SettingsAPI: TargetType {
   var baseURL: URL {
       guard let url = URL(string: APIConstants.baseURL) else {
           fatalError("❌ 잘못된 Base URL: \(APIConstants.baseURL)")
       }
       return url
   }
   
   var path: String {
       switch self {
       case .updateProfile:
           return APIConstants.User.updateProfile
       case .updateSettings:
           return "/mypage/setting"
       }
   }
   
   var method: Moya.Method {
       switch self {
       case .updateProfile, .updateSettings:
           return .patch
       }
   }
   
   var task: Task {
       switch self {
       case .updateProfile(let name, let accountId, let profileImage):
           var formData: [MultipartFormData] = []
           
           // 프로필 이미지 데이터
           if let imageData = profileImage {
               formData.append(MultipartFormData(
                   provider: .data(imageData),
                   name: "profileImage",
                   fileName: "profile.jpg",
                   mimeType: "image/jpeg"
               ))
           }
           
           // 요청 데이터
           let requestData = ["name": name, "accountId": accountId]
           if let jsonData = try? JSONSerialization.data(withJSONObject: requestData) {
               formData.append(MultipartFormData(
                   provider: .data(jsonData),
                   name: "request",
                   mimeType: "application/json"
               ))
           }
           
           return .uploadMultipart(formData)
       case .updateSettings(let settings):
           return .requestJSONEncodable(settings)
       }

   }
   
    var headers: [String: String]? {
        switch self {
        case .updateProfile:
            return ["Content-Type": "multipart/form-data"]
        case .updateSettings:
            return ["Content-Type": "application/json"]
        }
    }
}
