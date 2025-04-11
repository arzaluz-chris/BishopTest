// BishopScore.swift
import Foundation

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
                NSLocalizedString("No cervical ripening required", comment: "Recommendation for favorable cervix"),
                NSLocalizedString("Induction with oxytocin", comment: "Recommendation for favorable cervix"),
                NSLocalizedString("Consider amniotomy", comment: "Recommendation for favorable cervix")
            ]
        case .moderatelyFavorable:
            if nulliparous {
                return [
                    NSLocalizedString("In nulliparous women, consider cervical ripening", comment: "Recommendation for moderately favorable cervix in nulliparous"),
                    NSLocalizedString("Evaluate the need for prostaglandins", comment: "Recommendation for moderately favorable cervix in nulliparous"),
                    NSLocalizedString("Continuous monitoring during induction", comment: "Recommendation for moderately favorable cervix in nulliparous")
                ]
            } else {
                return [
                    NSLocalizedString("In multiparous women, start induction with oxytocin", comment: "Recommendation for moderately favorable cervix in multiparous"),
                    NSLocalizedString("Consider amniotomy if possible", comment: "Recommendation for moderately favorable cervix in multiparous"),
                    NSLocalizedString("Continuous monitoring during induction", comment: "Recommendation for moderately favorable cervix in multiparous")
                ]
            }
        case .unfavorable:
            return [
                NSLocalizedString("Pharmacological cervical ripening with prostaglandins", comment: "Recommendation for unfavorable cervix"),
                NSLocalizedString("Consider mechanical methods (balloon)", comment: "Recommendation for unfavorable cervix"),
                NSLocalizedString("Reevaluate after cervical ripening", comment: "Recommendation for unfavorable cervix")
            ]
        }
    }
}

// Localize enum descriptions
enum Dilation: Int, Codable, CaseIterable, Identifiable, CustomStringConvertible {
    case zero = 0
    case oneToTwo = 1
    case threeToFour = 2
    case fiveOrMore = 3
    
    var id: Int { self.rawValue }
    
    var description: String {
        switch self {
        case .zero: return NSLocalizedString("0 cm", comment: "Dilation value")
        case .oneToTwo: return NSLocalizedString("1-2 cm", comment: "Dilation value")
        case .threeToFour: return NSLocalizedString("3-4 cm", comment: "Dilation value")
        case .fiveOrMore: return NSLocalizedString("≥5 cm", comment: "Dilation value")
        }
    }
}

enum Effacement: Int, Codable, CaseIterable, Identifiable, CustomStringConvertible {
    case zeroToThirty = 0
    case fortyToFifty = 1
    case sixtyToSeventy = 2
    case eightyOrMore = 3
    
    var id: Int { self.rawValue }
    
    var description: String {
        switch self {
        case .zeroToThirty: return NSLocalizedString("0-30%", comment: "Effacement value")
        case .fortyToFifty: return NSLocalizedString("40-50%", comment: "Effacement value")
        case .sixtyToSeventy: return NSLocalizedString("60-70%", comment: "Effacement value")
        case .eightyOrMore: return NSLocalizedString("≥80%", comment: "Effacement value")
        }
    }
}

enum Consistency: Int, Codable, CaseIterable, Identifiable, CustomStringConvertible {
    case firm = 0
    case medium = 1
    case soft = 2
    
    var id: Int { self.rawValue }
    
    var description: String {
        switch self {
        case .firm: return NSLocalizedString("Firm", comment: "Consistency value")
        case .medium: return NSLocalizedString("Medium", comment: "Consistency value")
        case .soft: return NSLocalizedString("Soft", comment: "Consistency value")
        }
    }
}

enum Position: Int, Codable, CaseIterable, Identifiable, CustomStringConvertible {
    case posterior = 0
    case middle = 1
    case anterior = 2
    
    var id: Int { self.rawValue }
    
    var description: String {
        switch self {
        case .posterior: return NSLocalizedString("Posterior", comment: "Position value")
        case .middle: return NSLocalizedString("Middle", comment: "Position value")
        case .anterior: return NSLocalizedString("Anterior", comment: "Position value")
        }
    }
}

enum Station: Int, Codable, CaseIterable, Identifiable, CustomStringConvertible {
    case minusThree = 0
    case minusTwo = 1
    case minusOneOrZero = 2
    case plusOneOrPlusTwo = 3
    
    var id: Int { self.rawValue }
    
    var description: String {
        switch self {
        case .minusThree: return NSLocalizedString("-3", comment: "Station value")
        case .minusTwo: return NSLocalizedString("-2", comment: "Station value")
        case .minusOneOrZero: return NSLocalizedString("-1/0", comment: "Station value")
        case .plusOneOrPlusTwo: return NSLocalizedString("+1/+2", comment: "Station value")
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
            return NSLocalizedString("A score greater than 8 indicates good conditions for labor induction.", comment: "Favorable cervix description")
        case .moderatelyFavorable:
            return NSLocalizedString("A score between 6-7 indicates moderate conditions for induction, especially in multiparous women.", comment: "Moderately favorable cervix description")
        case .unfavorable:
            return NSLocalizedString("A score less than 6 indicates unfavorable conditions, cervical ripening is recommended.", comment: "Unfavorable cervix description")
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
