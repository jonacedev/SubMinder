//
//  SubscriptionsFactory.swift
//  SubMinder
//
//  Created by Jonathan Miguel Onrubia Solis on 6/7/24.
//

class SubscriptionsFactory {
    
    static let shared = SubscriptionsFactory()
    private init() { }
    
    func getSubscriptions() -> [SubscriptionSelectorModel] {
        return [SubscriptionSelectorModel(name: "Netflix", image: "netflix"),
                SubscriptionSelectorModel(name: "Youtube", image: "youtube"),
                SubscriptionSelectorModel(name: "Spotify", image: "spotify"),
                SubscriptionSelectorModel(name: "Linkedin", image: "linkedin"),
                SubscriptionSelectorModel(name: "Twitch", image: "twitch"),
                SubscriptionSelectorModel(name: "Crunchyroll", image: "crunchyroll"),
                SubscriptionSelectorModel(name: "Behance", image: "behance"), 
                SubscriptionSelectorModel(name: "Netflix", image: "netflix"),
                SubscriptionSelectorModel(name: "Youtube", image: "youtube"),
                SubscriptionSelectorModel(name: "Spotify", image: "spotify"),
                SubscriptionSelectorModel(name: "Linkedin", image: "linkedin"),
                SubscriptionSelectorModel(name: "Twitch", image: "twitch"),
                SubscriptionSelectorModel(name: "Crunchyroll", image: "crunchyroll"),
                SubscriptionSelectorModel(name: "Behance", image: "behance")]
    }
    
    func getDefaultSubscription() -> SubscriptionSelectorModel {
        SubscriptionSelectorModel(name: "Other", image: "netflix")
    }
}
