//  InductionMethod.swift
import Foundation

struct InductionMethod: Identifiable {
    var id = UUID()
    var name: String
    var description: String
    var indications: [String]
    var contraindications: [String]
    var risks: [String]
    
    // Método para recomendar opciones dependiendo del score
    static func recommendedMethods(for score: BishopScore) -> [InductionMethod] {
        if score.totalScore >= 8 {
            return InductionMethod.oxytocin
        } else if score.totalScore >= 6 {
            if score.nulliparous {
                return InductionMethod.prostaglandins + InductionMethod.mechanical
            } else {
                return InductionMethod.oxytocin
            }
        } else {
            if score.previousDeliveries > 0 && score.previousDeliveries < 5 {
                return InductionMethod.prostaglandins
            } else {
                return InductionMethod.mechanical
            }
        }
    }
    
    // Métodos de inducción predefinidos
    static let oxytocin = [
        InductionMethod(
            name: "Oxitocina",
            description: "Hormona sintética que estimula las contracciones uterinas.",
            indications: [
                "Bishop Score ≥ 6",
                "Cérvix favorable"
            ],
            contraindications: [
                "Placenta previa",
                "Vasa previa",
                "Prolapso de cordón"
            ],
            risks: [
                "Hiperestimulación uterina",
                "Alteraciones de FCF",
                "Rotura uterina (raro)"
            ]
        )
    ]
    
    static let prostaglandins = [
        InductionMethod(
            name: "Dinoprostona",
            description: "Prostaglandina E2 que favorece la maduración cervical.",
            indications: [
                "Bishop Score < 6",
                "Cérvix desfavorable"
            ],
            contraindications: [
                "Cesárea anterior",
                "Multiparidad (≥6 partos)",
                "Hipersensibilidad a prostaglandinas"
            ],
            risks: [
                "Taquisistolia",
                "Hiperestimulación uterina",
                "Rotura uterina (raro)"
            ]
        ),
        InductionMethod(
            name: "Misoprostol",
            description: "Prostaglandina E1 que favorece la maduración cervical.",
            indications: [
                "Bishop Score < 6",
                "Cérvix desfavorable",
                "Bajo riesgo de hiperestimulación"
            ],
            contraindications: [
                "Cesárea anterior",
                "Cirugía uterina previa",
                "Hipersensibilidad a prostaglandinas"
            ],
            risks: [
                "Taquisistolia",
                "Hiperestimulación uterina",
                "Rotura uterina"
            ]
        )
    ]
    
    static let mechanical = [
        InductionMethod(
            name: "Balón cervical doble",
            description: "Dispositivo mecánico de doble balón que favorece la dilatación cervical.",
            indications: [
                "Bishop Score < 6",
                "Cérvix desfavorable",
                "Cesárea anterior",
                "Alto riesgo de hiperestimulación"
            ],
            contraindications: [
                "RPM (Rotura Prematura de Membranas)",
                "Placenta marginal",
                "Infecciones maternas activas"
            ],
            risks: [
                "Disconfort durante colocación",
                "Sangrado leve",
                "Menor riesgo de hiperestimulación uterina"
            ]
        )
    ]
}
