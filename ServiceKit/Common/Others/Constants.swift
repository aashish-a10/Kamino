//
//  Constants.swift
//

import Foundation

public enum Constants {
    
    public enum Error {
        @Localizable public static var title = "Error"
        @Localizable public static var messages = "Error Messages"
        
    }
    
    public enum Action {
        @Localizable public static var ok = "OK"
        @Localizable public static var like = "Like"
        @Localizable public static var liked = "Liked"
        @Localizable public static var resident = "Resident"
    }
    
    public enum Planet {
        @Localizable static var name = "name"
        @Localizable public static var likes = "likes"
        @Localizable public static var rotationPeriod = "rotation period"
        @Localizable public static var residents = "residents"
        @Localizable public static var orbitalPeriod = "orbital period"
        @Localizable public static var diameter = "diameter"
        @Localizable public static var climate = "climate"
        @Localizable public static var gravity = "gravity"
        @Localizable public static var terrain = "terrain"
        @Localizable public static var surfaceWater = "surface water"
        @Localizable public static var population = "population"
    }
    
    public enum Resident {
        @Localizable static var name = "name"
        @Localizable static var height = "height"
        @Localizable static var mass = "mass"
        @Localizable static var hairColor = "hair color"
        @Localizable static var skinColor = "skin color"
        @Localizable static var eyeColor = "eye color"
        @Localizable static var birthYear = "birth year"
        @Localizable static var gender = "gender"
    }
    
    public enum Title {
        @Localizable public static var residents = "Residents"
    }
}
