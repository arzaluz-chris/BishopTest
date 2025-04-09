//  AppController.swift
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
                "No cervical ripening required",
                "Induction with oxytocin",
                "Consider amniotomy"
            ]
            
        case .moderatelyFavorable:
            if score.nulliparous {
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
                "Pharmacologic cervical ripening with prostaglandins",
                "Consider mechanical methods (balloon)",
                "Reevaluate after cervical ripening"
            ]
        }
    }
    
    func getInductionMethods(for score: BishopScore) -> [InductionMethod] {
        return InductionMethod.recommendedMethods(for: score)
    }
}
