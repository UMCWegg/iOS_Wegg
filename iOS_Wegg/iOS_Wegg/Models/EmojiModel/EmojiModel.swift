//
//  File.swift
//  iOS_Wegg
//
//  Created by 송승윤 on 1/30/25.
//

import Foundation

/// 이모티콘 모델 설정
struct EmojiModel {
    let name: String
    let imageName: String
    
    static func getEmojiModels() -> [EmojiModel] {
        return [
            EmojiModel(name: "smile", imageName: "smile2.png"),
            EmojiModel(name: "laugh", imageName: "laugh.png"),
            EmojiModel(name: "blush", imageName: "blush.png"),
            EmojiModel(name: "star_eyes", imageName: "star_eyes.png"),
            EmojiModel(name: "heart_eyes", imageName: "heart_eyes.png"),
            EmojiModel(name: "kiss", imageName: "kiss.png"),
            EmojiModel(name: "yawn", imageName: "yawn.png"),
            EmojiModel(name: "sleep", imageName: "sleep.png"),
            EmojiModel(name: "thinking", imageName: "thinking.png"),
            EmojiModel(name: "pinocchio", imageName: "pinocchio.png"),
            EmojiModel(name: "cool", imageName: "cool.png"),
            EmojiModel(name: "cry", imageName: "cry.png"),
            EmojiModel(name: "wave", imageName: "wave.png"),
            EmojiModel(name: "fist_bump", imageName: "fist_bump.png"),
            EmojiModel(name: "thumbs_up", imageName: "thumbs_up2.png"),
            EmojiModel(name: "high_five", imageName: "high_five.png"),
            EmojiModel(name: "clap", imageName: "clap.png"),
            EmojiModel(name: "pray", imageName: "pray.png"),
            EmojiModel(name: "heart", imageName: "heart2.png"),
            EmojiModel(name: "skull", imageName: "skull.png"),
            EmojiModel(name: "poop", imageName: "poop.png"),
            EmojiModel(name: "robot", imageName: "robot.png"),
            EmojiModel(name: "eyes", imageName: "eyes.png"),
            EmojiModel(name: "trophy", imageName: "trophy.png")
        ]
    }
}
