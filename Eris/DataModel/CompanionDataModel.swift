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
    var bgImage: UIImage

    init(name: String, defaultImage: UIImage, talkingImage: UIImage, altImage: UIImage, primaryColor: UIColor, darkerColor: UIColor, darkToneColor: UIColor, portrait: UIImage, bgImage: UIImage) {
        self.defaultImage = defaultImage
        self.talkingImage = talkingImage
        self.altImage = altImage
        self.primaryColor = primaryColor
        self.darkerColor = darkerColor
        self.darkToneColor = darkToneColor
        self.portrait = portrait
        self.name = name
        self.bgImage = bgImage
    }
    
    func getPrice() -> Double {
        if name == "Aiko"  && !UserDefaults.standard.bool(forKey: "Aiko") {
            return 0.99
        }
        return 0
    }
}
enum enumCompanions: String {
    case Clara = "Clara"
    case Luna = "Luna"
    case Aiko = "Aiko"
    func getModel() -> CompanionModel {
        switch self {
        case .Clara:
            return CompanionModel(name: "Clara", defaultImage: UIImage(named: "mascot_default_clara")!, talkingImage: UIImage(named: "mascot_default_clara")!, altImage: UIImage(named: "mascot_default_clara")!, primaryColor: #colorLiteral(red: 0.7137254902, green: 1, blue: 0.9803921569, alpha: 1), darkerColor: #colorLiteral(red: 0.5019607843, green: 0.7019607843, blue: 1, alpha: 1), darkToneColor: #colorLiteral(red: 0.2019917342, green: 0.2213776135, blue: 0.5725490196, alpha: 1), portrait: UIImage(named: "clara_portrait")!, bgImage: UIImage(named: "background_clara")!)
        case .Luna:
            return CompanionModel(name: "Luna", defaultImage: UIImage(named: "mascot_default")!, talkingImage: UIImage(named: "mascot_smile")!, altImage: UIImage(named: "mascot_eyes_closed")!, primaryColor: #colorLiteral(red: 0.8156862745, green: 0.9058823529, blue: 0.8235294118, alpha: 1), darkerColor: #colorLiteral(red: 0.4745098039, green: 0.6745098039, blue: 0.4705882353, alpha: 1), darkToneColor: #colorLiteral(red: 0.02059417517, green: 0.2698388731, blue: 0.09074254698, alpha: 1), portrait: UIImage(named: "luna_portrait")!, bgImage: UIImage(named: "background_luna")!)
        case .Aiko:
            return CompanionModel(name: "Aiko", defaultImage: UIImage(named: "mascot_deafault_aiko")!, talkingImage: UIImage(named: "mascot_deafault_aiko")!, altImage: UIImage(named: "mascot_deafault_aiko")!, primaryColor: #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1), darkerColor: #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1), darkToneColor: #colorLiteral(red: 0.817442602, green: 0.1755420918, blue: 0.5321269133, alpha: 1), portrait: UIImage(named: "aiko_portrait")!, bgImage: UIImage(named: "background_aiko")!)
        }
    }
}
let luna = CompanionModel(name: "Luna", defaultImage: UIImage(named: "mascot_default")!, talkingImage: UIImage(named: "mascot_smile")!, altImage: UIImage(named: "mascot_eyes_closed")!, primaryColor: #colorLiteral(red: 0.8156862745, green: 0.9058823529, blue: 0.8235294118, alpha: 1), darkerColor: #colorLiteral(red: 0.4745098039, green: 0.6745098039, blue: 0.4705882353, alpha: 1), darkToneColor: #colorLiteral(red: 0.02059417517, green: 0.2698388731, blue: 0.09074254698, alpha: 1), portrait: UIImage(named: "luna_portrait")!, bgImage: UIImage(named: "background_luna")!)
let clara = CompanionModel(name: "Clara", defaultImage: UIImage(named: "mascot_default_clara")!, talkingImage: UIImage(named: "mascot_default_clara")!, altImage: UIImage(named: "mascot_default_clara")!, primaryColor: #colorLiteral(red: 0.7137254902, green: 1, blue: 0.9803921569, alpha: 1), darkerColor: #colorLiteral(red: 0.5019607843, green: 0.7019607843, blue: 1, alpha: 1), darkToneColor: #colorLiteral(red: 0.2019917342, green: 0.2213776135, blue: 0.5725490196, alpha: 1), portrait: UIImage(named: "clara_portrait")!, bgImage: UIImage(named: "background_clara")!)
let aiko = CompanionModel(name: "Aiko", defaultImage: UIImage(named: "mascot_deafault_aiko")!, talkingImage: UIImage(named: "mascot_deafault_aiko")!, altImage: UIImage(named: "mascot_deafault_aiko")!, primaryColor: #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1), darkerColor: #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1), darkToneColor: #colorLiteral(red: 0.817442602, green: 0.1755420918, blue: 0.5321269133, alpha: 1), portrait: UIImage(named: "aiko_portrait")!, bgImage: UIImage(named: "background_aiko")!)
class chosenCompanion {
    var companion: CompanionModel
    static var shared = chosenCompanion(companion: enumCompanions(rawValue: UserDefaults.standard.string(forKey: "Companion") ?? "Luna")?.getModel() as? CompanionModel ?? enumCompanions.Luna.getModel())
    init(companion: CompanionModel) {
        self.companion = companion
    }
}

