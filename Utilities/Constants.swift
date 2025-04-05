//  Constants.swift
import Foundation
import SwiftUI

struct Constants {
    // App Information
    static let appName = "BishopTest"
    static let appVersion = "1.0.0"
    static let appCopyright = "© 2025 BishopTest App"
    
    // URLs
    static let wikipediaURL = "https://es.wikipedia.org/wiki/Test_de_Bishop"
    static let privacyPolicyURL = "https://www.bishoptest.app/privacy"
    
    // UI Constants
    struct UI {
        static let primaryColor = Color("Primary")
        static let secondaryColor = Color("Secondary")
        static let accentColor = Color("Accent")
        static let favorableColor = Color("FavorableGreen")
        static let moderateColor = Color("ModerateOrange")
        static let unfavorableColor = Color("UnfavorableRed")
        
        static let cornerRadius: CGFloat = 10
        static let buttonHeight: CGFloat = 50
        static let iconSize: CGFloat = 24
    }
    
    // Storage Keys
    struct StorageKeys {
        static let userName = "userName"
        static let userSpecialty = "userSpecialty"
        static let useModifiers = "useModifiers"
        static let darkMode = "darkMode"
        static let savedScores = "BishopScores.json"
    }
}
