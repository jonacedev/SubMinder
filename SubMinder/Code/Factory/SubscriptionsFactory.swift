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
        return [SubscriptionSelectorModel(name: "Netflix", image: "netflix", color: .colorNetflix),
                SubscriptionSelectorModel(name: "Youtube", image: "youtube", color: .colorYoutube),
                SubscriptionSelectorModel(name: "Spotify", image: "spotify", color: .colorSpotify),
                SubscriptionSelectorModel(name: "Linkedin", image: "linkedin", color: .colorLinkedin),
                SubscriptionSelectorModel(name: "Twitch", image: "twitch", color: .colorTwitch),
                SubscriptionSelectorModel(name: "HBO", image: "hbo", color: .colorHbo),
                SubscriptionSelectorModel(name: "Disney", image: "disney", color: .colorDisney),
                SubscriptionSelectorModel(name: "Crunchyroll", image: "crunchyroll", color: .colorCrunchyroll),
                SubscriptionSelectorModel(name: "Uber Eats", image: "ubereats", color: .colorUberEats),
                SubscriptionSelectorModel(name: "Glovo", image: "glovo", color: .colorGlovo),
                SubscriptionSelectorModel(name: "Amazon Prime", image: "amazonprime", color: .colorAmazonPrime),
                SubscriptionSelectorModel(name: "Amazon Music", image: "amazonmusic", color: .colorAmazonMusic),
                SubscriptionSelectorModel(name: "Apple Music", image: "applemusic", color: .colorAppleMusic),
                SubscriptionSelectorModel(name: "Apple TV", image: "appletv", color: .colorAppleTV),
                SubscriptionSelectorModel(name: "Uber", image: "uber", color: .colorUber),
                SubscriptionSelectorModel(name: "Adobe Creative Cloud", image: "adobecreative", color: .colorAdobeCreative),
                SubscriptionSelectorModel(name: "Audible", image: "audible", color: .colorAudible),
                SubscriptionSelectorModel(name: "Calm", image: "calm", color: .colorCalm),
                SubscriptionSelectorModel(name: "Canva", image: "canva", color: .colorCanva),
                SubscriptionSelectorModel(name: "DAZN", image: "dazn", color: .colorDazn),
                SubscriptionSelectorModel(name: "Deezer", image: "deezer", color: .colorDeezer),
                SubscriptionSelectorModel(name: "Dropbox", image: "dropbox", color: .colorDropbox),
                SubscriptionSelectorModel(name: "Duolingo", image: "duolingo", color: .colorDuolingo),
                SubscriptionSelectorModel(name: "ESPN", image: "espn", color: .colorEspn),
                SubscriptionSelectorModel(name: "Figma", image: "figma", color: .colorFigma),
                SubscriptionSelectorModel(name: "Flaticon", image: "flaticon", color: .colorFlaticon),
                SubscriptionSelectorModel(name: "Flickr", image: "flickr", color: .colorFlickr),
                SubscriptionSelectorModel(name: "Freepik", image: "freepik", color: .colorFreepik),
                SubscriptionSelectorModel(name: "Google Cloud", image: "googlecloud", color: .colorGoogleCloud),
                SubscriptionSelectorModel(name: "Hostinger", image: "hostinger", color: .colorHostinger),
                SubscriptionSelectorModel(name: "Hulu", image: "hulu", color: .colorHulu),
                SubscriptionSelectorModel(name: "iCloud", image: "icloud", color: .colorICloud),
                SubscriptionSelectorModel(name: "Medium", image: "medium", color: .colorMedium),
                SubscriptionSelectorModel(name: "Movistar", image: "movistar", color: .colorMovistar),
                SubscriptionSelectorModel(name: "National Geographic", image: "nationalgeo", color: .colorNationalGeo),
                SubscriptionSelectorModel(name: "Nintendo", image: "nintendo", color: .colorNintendo),
                SubscriptionSelectorModel(name: "Orange", image: "orange", color: .colorOrange),
                SubscriptionSelectorModel(name: "Patreon", image: "patreon", color: .colorPatreon),
                SubscriptionSelectorModel(name: "Platzi", image: "platzi", color: .colorPlatzi),
                SubscriptionSelectorModel(name: "Playstation", image: "playstation", color: .colorPlaystation),
                SubscriptionSelectorModel(name: "Shopify", image: "shopify", color: .colorShopify),
                SubscriptionSelectorModel(name: "Showtime", image: "showtime", color: .colorShowtime),
                SubscriptionSelectorModel(name: "Sketch", image: "sketch", color: .colorSketch),
                SubscriptionSelectorModel(name: "Sky", image: "sky", color: .colorSky),
                SubscriptionSelectorModel(name: "Soundcloud", image: "soundcloud", color: .colorSoundcloud),
                SubscriptionSelectorModel(name: "Tidal", image: "tidal", color: .colorTidal),
                SubscriptionSelectorModel(name: "Tinder", image: "tinder", color: .colorTinder),
                SubscriptionSelectorModel(name: "Vimeo", image: "vimeo", color: .colorVimeo),
                SubscriptionSelectorModel(name: "Vodafone", image: "vodafone", color: .colorVodafone),
                SubscriptionSelectorModel(name: "VSCO", image: "vsco", color: .colorVsco),
                SubscriptionSelectorModel(name: "WIX", image: "wix", color: .colorWix),
                SubscriptionSelectorModel(name: "Xbox", image: "xbox", color: .colorXbox),
                SubscriptionSelectorModel(name: "Apple developer", image: "appledeveloper", color: .colorAppleDeveloper)]
    }
    
    func getDefaultSubscription() -> SubscriptionSelectorModel {
        SubscriptionSelectorModel(name: "Other", image: "netflix", color: .addBlue)
    }
}
