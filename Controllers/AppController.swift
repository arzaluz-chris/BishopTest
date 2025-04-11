// AppController.swift
import Foundation
import SwiftUI
import Combine

class AppController: ObservableObject {
    @Published var currentBishopScore: BishopScore = BishopScore()
    
    func calculateInterpretation(for score: BishopScore) -> ScoreInterpretation {
        if score.totalScore >= 8 {
            return .favorable
        } else if score.totalScore >= 6 {
            return .moderatelyFavorable
        } else {
            return .unfavorable
        }
    }
    
    func getRecommendations(for score: BishopScore) -> [String] {
        switch calculateInterpretation(for: score) {
        case .favorable:
            return [
                NSLocalizedString("No cervical ripening required", comment: "Favorable recommendation"),
                NSLocalizedString("Induction with oxytocin", comment: "Favorable recommendation"),
                NSLocalizedString("Consider amniotomy", comment: "Favorable recommendation")
            ]
            
        case .moderatelyFavorable:
            if score.nulliparous {
                return [
                    NSLocalizedString("In nulliparous women, consider cervical ripening", comment: "Moderately favorable recommendation for nulliparous"),
                    NSLocalizedString("Evaluate the need for prostaglandins", comment: "Moderately favorable recommendation for nulliparous"),
                    NSLocalizedString("Continuous monitoring during induction", comment: "Moderately favorable recommendation for nulliparous")
                ]
            } else {
                return [
                    NSLocalizedString("In multiparous women, start induction with oxytocin", comment: "Moderately favorable recommendation for multiparous"),
                    NSLocalizedString("Consider amniotomy if possible", comment: "Moderately favorable recommendation for multiparous"),
                    NSLocalizedString("Continuous monitoring during induction", comment: "Moderately favorable recommendation for multiparous")
                ]
            }
            
        case .unfavorable:
            return [
                NSLocalizedString("Pharmacologic cervical ripening with prostaglandins", comment: "Unfavorable recommendation"),
                NSLocalizedString("Consider mechanical methods (balloon)", comment: "Unfavorable recommendation"),
                NSLocalizedString("Reevaluate after cervical ripening", comment: "Unfavorable recommendation")
            ]
        }
    }
    
    func getInductionMethods(for score: BishopScore) -> [InductionMethod] {
        return InductionMethod.recommendedMethods(for: score)
    }
}
