import Foundation

// This is the main structure that represents the Bishop Test
struct BishopScore: Identifiable, Codable {
    var id = UUID()
    var date: Date
    var patientName: String?
    var patientAge: Int?
    var previousDeliveries: Int
    
    // Parameters of the Bishop Test
    var dilation: Dilation
    var effacement: Effacement
    var consistency: Consistency
    var position: Position
    var station: Station
    
    // Modifiers
    var preeclampsia: Bool
    var postdatePregnancy: Bool
    var nulliparous: Bool
    var prematureRupture: Bool
    
    // Default values for a new evaluation
    init(date: Date = Date(), patientName: String? = nil, patientAge: Int? = nil, previousDeliveries: Int = 0) {
        self.date = date
        self.patientName = patientName
        self.patientAge = patientAge
        self.previousDeliveries = previousDeliveries
        
        // Default values
        self.dilation = .zero
        self.effacement = .zeroToThirty
        self.consistency = .firm
        self.position = .posterior
        self.station = .minusThree
        
        self.preeclampsia = false
        self.postdatePregnancy = false
        self.nulliparous = previousDeliveries == 0
        self.prematureRupture = false
    }
    
    // Function to calculate the score with or without modifiers
    func calculateTotalScore(applyModifiers: Bool = true) -> Int {
        var score = 0
        
        // Add points for parameters
        score += dilation.rawValue
        score += effacement.rawValue
        score += consistency.rawValue
        score += position.rawValue
        score += station.rawValue
        
        // Apply modifiers only if requested
        if applyModifiers {
            if preeclampsia { score += 1 }
            if previousDeliveries > 0 { score += previousDeliveries }
            if postdatePregnancy { score -= 1 }
            if nulliparous { score -= 1 }
            if prematureRupture { score -= 1 }
        }
        
        return max(0, score) // Do not allow negative scores
    }
    
    // Calculates the total score (with default modifiers)
    var totalScore: Int {
        return calculateTotalScore()
    }
    
    // Interpretation of the result
    var interpretation: ScoreInterpretation {
        if totalScore >= 8 {
            return .favorable
        } else if totalScore >= 6 {
            return .moderatelyFavorable
        } else {
            return .unfavorable
        }
    }
    
    // Recommendations based on the score
    var recommendations: [String] {
        switch interpretation {
        case .favorable:
            return [
                "No cervical ripening required",
                "Induction with oxytocin",
                "Consider amniotomy"
            ]
        case .moderatelyFavorable:
            if nulliparous {
                return [
                    "In nulliparous women, consider cervical ripening",
                    "Evaluate the need for prostaglandins",
                    "Continuous monitoring during induction"
                ]
            } else {
                return [
                    "In multiparous women, start induction with oxytocin",
                    "Consider amniotomy if possible",
                    "Continuous monitoring during induction"
                ]
            }
        case .unfavorable:
            return [
                "Pharmacological cervical ripening with prostaglandins",
                "Consider mechanical methods (balloon)",
                "Reevaluate after cervical ripening"
            ]
        }
    }
}

// Enumerations for the parameters of the Bishop Test
// Code to update the enumerations in Models/BishopScore.swift
// Add conformance to CustomStringConvertible to each enumeration

// For the Dilation enumeration:
enum Dilation: Int, Codable, CaseIterable, Identifiable, CustomStringConvertible {
    case zero = 0
    case oneToTwo = 1
    case threeToFour = 2
    case fiveOrMore = 3
    
    var id: Int { self.rawValue }
    
    var description: String {
        switch self {
        case .zero: return "0 cm"
        case .oneToTwo: return "1-2 cm"
        case .threeToFour: return "3-4 cm"
        case .fiveOrMore: return "≥5 cm"
        }
    }
}

// For the Effacement enumeration:
enum Effacement: Int, Codable, CaseIterable, Identifiable, CustomStringConvertible {
    case zeroToThirty = 0
    case fortyToFifty = 1
    case sixtyToSeventy = 2
    case eightyOrMore = 3
    
    var id: Int { self.rawValue }
    
    var description: String {
        switch self {
        case .zeroToThirty: return "0-30%"
        case .fortyToFifty: return "40-50%"
        case .sixtyToSeventy: return "60-70%"
        case .eightyOrMore: return "≥80%"
        }
    }
}

// For the Consistency enumeration:
enum Consistency: Int, Codable, CaseIterable, Identifiable, CustomStringConvertible {
    case firm = 0
    case medium = 1
    case soft = 2
    
    var id: Int { self.rawValue }
    
    var description: String {
        switch self {
        case .firm: return "Firm"
        case .medium: return "Medium"
        case .soft: return "Soft"
        }
    }
}

// For the Position enumeration:
enum Position: Int, Codable, CaseIterable, Identifiable, CustomStringConvertible {
    case posterior = 0
    case middle = 1
    case anterior = 2
    
    var id: Int { self.rawValue }
    
    var description: String {
        switch self {
        case .posterior: return "Posterior"
        case .middle: return "Middle"
        case .anterior: return "Anterior"
        }
    }
}

// For the Station enumeration:
enum Station: Int, Codable, CaseIterable, Identifiable, CustomStringConvertible {
    case minusThree = 0
    case minusTwo = 1
    case minusOneOrZero = 2
    case plusOneOrPlusTwo = 3
    
    var id: Int { self.rawValue }
    
    var description: String {
        switch self {
        case .minusThree: return "-3"
        case .minusTwo: return "-2"
        case .minusOneOrZero: return "-1/0"
        case .plusOneOrPlusTwo: return "+1/+2"
        }
    }
}
enum ScoreInterpretation: String, Codable {
    case favorable = "Favorable Cervix"
    case moderatelyFavorable = "Moderately Favorable Cervix"
    case unfavorable = "Unfavorable Cervix"
    
    var description: String {
        switch self {
        case .favorable:
            return "A score greater than 8 indicates good conditions for labor induction."
        case .moderatelyFavorable:
            return "A score between 6-7 indicates moderate conditions for induction, especially in multiparous women."
        case .unfavorable:
            return "A score less than 6 indicates unfavorable conditions, cervical ripening is recommended."
        }
    }
    
    var color: String {
        switch self {
        case .favorable: return "FavorableGreen"
        case .moderatelyFavorable: return "ModerateOrange"
        case .unfavorable: return "UnfavorableRed"
        }
    }
}
