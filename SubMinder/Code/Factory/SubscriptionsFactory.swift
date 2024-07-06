//
//  SubscriptionsFactory.swift
//  SubMinder
//
//  Created by Jonathan Miguel Onrubia Solis on 6/7/24.
//

class SubscriptionsFactory {
    
    static let shared = SubscriptionsFactory()
    private init() { }
    
    func getSubscriptions() -> [SubscriptionModel] {
        return [SubscriptionModel(name: "Netflix", image: "netflix"),
                SubscriptionModel(name: "Youtube", image: "youtube"),
                SubscriptionModel(name: "Spotify", image: "spotify"),
                SubscriptionModel(name: "Linkedin", image: "linkedin"),
                SubscriptionModel(name: "Twitch", image: "twitch"),
                SubscriptionModel(name: "Crunchyroll", image: "crunchyroll"),
                SubscriptionModel(name: "Behance", image: "behance")]
    }
    
    func getDefaultSubscription() -> SubscriptionModel {
        SubscriptionModel(name: "Other", image: "netflix")
    }
}
