//  PreviewData.swift
import Foundation

struct PreviewData {
    static let sampleBishopScore = BishopScore(
        date: Date(),
        patientName: "María García",
        patientAge: 28,
        previousDeliveries: 1
    )
    
    static let sampleBishopScoreFavorable: BishopScore = {
        var score = BishopScore(
            date: Date(),
            patientName: "Laura Martínez",
            patientAge: 32,
            previousDeliveries: 2
        )
        score.dilation = .threeToFour
        score.effacement = .eightyOrMore
        score.consistency = .soft
        score.position = .anterior
        score.station = .plusOneOrPlusTwo
        return score
    }()
    
    static let sampleBishopScoreUnfavorable: BishopScore = {
        var score = BishopScore(
            date: Date().addingTimeInterval(-86400 * 3),
            patientName: "Ana Rodríguez",
            patientAge: 25,
            previousDeliveries: 0
        )
        score.dilation = .zero
        score.effacement = .zeroToThirty
        score.consistency = .firm
        score.position = .posterior
        score.station = .minusThree
        score.nulliparous = true
        return score
    }()
    
    static let sampleBishopScores: [BishopScore] = [
        sampleBishopScore,
        sampleBishopScoreFavorable,
        sampleBishopScoreUnfavorable
    ]
}
