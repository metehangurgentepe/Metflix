//
//  Constants.swift
//  MetFlix
//
//  Created by Metehan Gürgentepe on 15.02.2024.
//

import Foundation
import UIKit


enum ScreenSize{
    static let width = UIScreen.main.bounds.size.width
    static let height = UIScreen.main.bounds.size.height
    static let maxLength = max(ScreenSize.width, ScreenSize.height)
    static let minLength = min(ScreenSize.width, ScreenSize.height)
}


enum DeviceTypes {
    static let idiom = UIDevice.current.userInterfaceIdiom
    static let nativeScale = UIScreen.main.nativeScale
    static let scale = UIScreen.main.scale
    
    
    static let isiPhoneSE = idiom == .phone && ScreenSize.maxLength == 568.0
    static let isiPhone8Standart = idiom == .phone && ScreenSize.maxLength == 667.0 && nativeScale == scale
    static let isiPhone8Zoomed = idiom == .phone && ScreenSize.maxLength == 667.0 && nativeScale > scale
    static let isiPhone8PlusStandart = idiom == .phone && ScreenSize.maxLength == 736.0
    static let isiPhone8PlusZoomed = idiom == .phone && ScreenSize.maxLength == 736.0 && nativeScale < scale
    static let isiPhoneX = idiom == .phone && ScreenSize.maxLength == 812.0
    static let isiPhoneXsMaxAndXr = idiom == .phone && ScreenSize.maxLength == 896.0
    static let isiPad = idiom == .phone && ScreenSize.maxLength >= 1024
    
    static func isiPhoneXAspectRatio() -> Bool {
        return isiPhoneX || isiPhoneXsMaxAndXr
    }
}


enum Images {
    static let metflixLogo = UIImage(named: "metflixIcon")
    static let infoButton = UIImage(named: "info.circle")
    static let playButton = UIImage(named: "playButton")
    static let defaultPhoto = UIImage(named: "fight_club")
}


enum SFSymbols {
    static let person =  UIImage(systemName: "person")
    static let playRectangle = UIImage(systemName:"play.rectangle")
    static let home = UIImage(systemName:"house")
    static let selectedHome = UIImage(systemName:"house.fill")
    static let search = UIImage(systemName: "magnifyingglass")
    static let selectedSearch = UIImage(systemName: "magnifyingglass.circle.fill")
    static let favorites = UIImage(systemName:"heart")
    static let selectedFavorites = UIImage(systemName:"heart.fill")
    static let followers = UIImage(systemName:"heart")
    static let following = UIImage(systemName:"person.2")
    static let filter = UIImage(systemName: "line.3.horizontal.decrease.circle.fill")
    static let question = UIImage(systemName: "questionmark")
    static let starFill = UIImage(systemName: "star.fill")
    static let star = UIImage(systemName: "star.fill")
    static let halfStar = UIImage(systemName: "star.lefthalf.fill")
    static let lane = UIImage(systemName: "lane")
    static let newAndPopular = UIImage(systemName: "play.rectangle.on.rectangle")
    static let selectedNewAndPopular = UIImage(systemName: "play.rectangle.on.rectangle.fill")
}

enum Genre {
    static let allCases = ["Comedy", "Family", "Action", "Drama", "Fantasy", "Science Fiction"]
}
