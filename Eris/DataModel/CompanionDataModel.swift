//
//  CompanionDataModel.swift
//  Eris
//
//  Created by Dmitry Chicherin on 15/10/2566 BE.
//

import Foundation
import UIKit

struct CompanionModel {
    var defaultImage: UIImage
    var talkingImage: UIImage
    var altImage: UIImage
    var portrait: UIImage
    var primaryColor: UIColor
    var darkerColor: UIColor
    var darkToneColor: UIColor
    var name: String

    init(name: String, defaultImage: UIImage, talkingImage: UIImage, altImage: UIImage, primaryColor: UIColor, darkerColor: UIColor, darkToneColor: UIColor, portrait: UIImage) {
        self.defaultImage = defaultImage
        self.talkingImage = talkingImage
        self.altImage = altImage
        self.primaryColor = primaryColor
        self.darkerColor = darkerColor
        self.darkToneColor = darkToneColor
        self.portrait = portrait
        self.name = name
    }
    
    func getPrice() -> Int {
        return 0
    }
}
enum enumCompanions: String {
    case Clara = "Clara"
    case Luna = "Luna"
    func getModel() -> CompanionModel {
        switch self {
        case .Clara:
            return CompanionModel(name: "Clara", defaultImage: UIImage(named: "mascot_default_clara")!, talkingImage: UIImage(named: "mascot_default_clara")!, altImage: UIImage(named: "mascot_default_clara")!, primaryColor: #colorLiteral(red: 0.7137254902, green: 1, blue: 0.9803921569, alpha: 1), darkerColor: #colorLiteral(red: 0.5019607843, green: 0.7019607843, blue: 1, alpha: 1), darkToneColor: #colorLiteral(red: 0.4078431373, green: 0.4941176471, blue: 1, alpha: 1), portrait: UIImage(named: "clara_portrait")!)
        case .Luna:
            return CompanionModel(name: "Luna", defaultImage: UIImage(named: "mascot_default")!, talkingImage: UIImage(named: "mascot_smile")!, altImage: UIImage(named: "mascot_eyes_closed")!, primaryColor: #colorLiteral(red: 0.8156862745, green: 0.9058823529, blue: 0.8235294118, alpha: 1), darkerColor: #colorLiteral(red: 0.4745098039, green: 0.6745098039, blue: 0.4705882353, alpha: 1), darkToneColor: #colorLiteral(red: 0.4745098039, green: 0.6745098039, blue: 0.4705882353, alpha: 1), portrait: UIImage(named: "luna_portrait")!)
        }
    }
}
let luna = CompanionModel(name: "Luna", defaultImage: UIImage(named: "mascot_default")!, talkingImage: UIImage(named: "mascot_smile")!, altImage: UIImage(named: "mascot_eyes_closed")!, primaryColor: #colorLiteral(red: 0.8156862745, green: 0.9058823529, blue: 0.8235294118, alpha: 1), darkerColor: #colorLiteral(red: 0.4745098039, green: 0.6745098039, blue: 0.4705882353, alpha: 1), darkToneColor: #colorLiteral(red: 0.4745098039, green: 0.6745098039, blue: 0.4705882353, alpha: 1), portrait: UIImage(named: "luna_portrait")!)
let clara = CompanionModel(name: "Luna", defaultImage: UIImage(named: "mascot_default_clara")!, talkingImage: UIImage(named: "mascot_default_clara")!, altImage: UIImage(named: "mascot_default_clara")!, primaryColor: #colorLiteral(red: 0.7137254902, green: 1, blue: 0.9803921569, alpha: 1), darkerColor: #colorLiteral(red: 0.5019607843, green: 0.7019607843, blue: 1, alpha: 1), darkToneColor: #colorLiteral(red: 0.4078431373, green: 0.4941176471, blue: 1, alpha: 1), portrait: UIImage(named: "clara_portrait")!)
class chosenCompanion {
    var companion: CompanionModel
    static var shared = chosenCompanion(companion: enumCompanions(rawValue: UserDefaults.standard.string(forKey: "Companion") ?? "Luna")?.getModel() as? CompanionModel ?? enumCompanions.Luna.getModel())
    init(companion: CompanionModel) {
        self.companion = companion
    }
}

