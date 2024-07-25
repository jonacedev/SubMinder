//
//  SubscriptionModelDto.swift
//  SubMinder
//
//  Created by Jonathan Miguel Onrubia Solis on 8/7/24.
//

import Foundation
import SwiftUI

enum SubscriptionType: String {
    case weekly = "Semanal"
    case monthly = "Mensual"
    case quarterly = "Trimestral"
    case yearly = "Anual"
    case freeTrial = "Prueba"
    
    init(type: String) {
        switch type.lowercased() {
        case "semanal":
            self = .weekly
        case "mensual":
            self = .monthly
        case "trimestral":
            self = .quarterly
        case "anual":
            self = .yearly
        case "prueba":
            self = .freeTrial
        default:
            self = .monthly
        }
    }
}

struct SubscriptionModelDto: Identifiable {
    let id: String
    let name: String
    let image: String
    let price: Double
    let paymentDate: String
    let type: SubscriptionType
    let divisa: String
    
    init(id: String, name: String, image: String, price: Double, paymentDate: String, type: SubscriptionType, divisa: String) {
        self.id = id
        self.name = name
        self.image = image
        self.price = price
        self.paymentDate = paymentDate
        self.type = type
        self.divisa = divisa
    }
    
    init(name: String, image: String, price: Double, paymentDate: String, type: SubscriptionType, divisa: String) {
        self.id = UUID().uuidString
        self.name = name
        self.image = image
        self.price = price
        self.paymentDate = paymentDate
        self.type = type
        self.divisa = divisa
    }
    
    init(model: NewSubscriptionModel) {
        self.id = model.id
        self.name = model.name
        self.image = model.image
        self.price = model.price
        self.paymentDate = model.paymentDate
        self.type = SubscriptionType(type: model.type)
        self.divisa = model.divisa
    }
    
    func getBackgroundColor() -> Color {
        return switch image {
        case "netflix": .colorNetflix
        case "spotify": .colorSpotify
        case "adobecreative": .colorAdobeCreative
        case "amazonmusic": .colorAmazonMusic
        case "amazonprime": .colorAmazonPrime
        case "appledeveloper": .colorAppleDeveloper
        case "applemusic": .colorAppleMusic
        case "appletv": .colorAppletv
        case "audible": .colorAudible
        case "calm": .colorCalm
        case "canva": .colorCanva
        case "crunchyroll": .colorCrunchyroll
        case "dazn": .colorDazn
        case "deezer": .colorDeezer
        case "disney": .colorDisney
        case "dropbox": .colorDropbox
        case "duolingo": .colorDuolingo
        case "espn": .colorEspn
        case "figma": .colorFigma
        case "flaticon": .colorFlaticon
        case "flickr": .colorFlickr
        case "freepik": .colorFreepik
        case "glovo": .colorGlovo
        case "googlecloud": .colorGoogleCloud
        case "hbo": .colorHbo
        case "hostinger": .colorHostinger
        case "hulu": .colorHulu
        case "icloud": .colorIcloud
        case "linkedin": .colorLinkedin
        case "medium": .colorMedium
        case "movistar": .colorMovistar
        case "nationalgeo": .colorNationalGeo
        case "nintendo": .colorNintendo
        case "orange": .colorOrange
        case "patreon": .colorPatreon
        case "platzi": .colorPlatzi
        case "playstation": .colorPlaystation
        case "shopify": .colorShopify
        case "showtime": .colorShowtime
        case "sketch": .colorSketch
        case "sky": .colorSky
        case "soundcloud": .colorSoundcloud
        case "tidal": .colorTidal
        case "tinder": .colorTinder
        case "twitch": .colorTwitch
        case "uber": .colorUber
        case "ubereats": .colorUberEats
        case "vimeo": .colorVimeo
        case "vodafone": .colorVodafone
        case "vsco": .colorVsco
        case "wix": .colorWix
        case "xbox": .colorXbox
        case "youtube": .colorYoutube
        default: .addBlue
        }
    }
}
