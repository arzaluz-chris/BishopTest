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
                "No se requiere maduración cervical previa",
                "Inducción con oxitocina",
                "Considerar amniotomía"
            ]
        case .moderatelyFavorable:
            if score.nulliparous {
                return [
                    "En nulíparas, considerar maduración cervical",
                    "Evaluar necesidad de prostaglandinas",
                    "Monitorización continua durante inducción"
                ]
            } else {
                return [
                    "En multíparas, iniciar inducción con oxitocina",
                    "Considerar amniotomía si es posible",
                    "Monitorización continua durante inducción"
                ]
            }
        case .unfavorable:
            return [
                "Maduración cervical farmacológica con prostaglandinas",
                "Considerar métodos mecánicos (balón)",
                "Reevaluar después de maduración cervical"
            ]
        }
    }
    
    func getInductionMethods(for score: BishopScore) -> [InductionMethod] {
        return InductionMethod.recommendedMethods(for: score)
    }
}
