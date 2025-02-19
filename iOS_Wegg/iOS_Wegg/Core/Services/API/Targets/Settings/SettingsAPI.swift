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
       }
   }
   
   var method: Moya.Method {
       switch self {
       case .updateProfile:
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
       }
   }
   
   var headers: [String: String]? {
       return ["Content-Type": "multipart/form-data"]
   }
}
