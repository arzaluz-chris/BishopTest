//  InductionMethod.swift
import Foundation

struct InductionMethod: Identifiable {
    var id = UUID()
    var name: String
    var description: String
    var indications: [String]
    var contraindications: [String]
    var risks: [String]
    
    // Method to recommend options depending on the score
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
    
    // Predefined induction methods
    static let oxytocin = [
        InductionMethod(
            name: "Oxytocin",
            description: "Synthetic hormone that stimulates uterine contractions.",
            indications: [
                "Bishop Score ≥ 6",
                "Favorable cervix"
            ],
            contraindications: [
                "Placenta previa",
                "Vasa previa",
                "Cord prolapse"
            ],
            risks: [
                "Uterine hyperstimulation",
                "FHR abnormalities",
                "Uterine rupture (rare)"
            ]
        )
    ]
    
    static let prostaglandins = [
        InductionMethod(
            name: "Dinoprostone",
            description: "Prostaglandin E2 that promotes cervical ripening.",
            indications: [
                "Bishop Score < 6",
                "Unfavorable cervix"
            ],
            contraindications: [
                "Previous cesarean section",
                "Grand multiparity (≥6 births)",
                "Hypersensitivity to prostaglandins"
            ],
            risks: [
                "Tachysystole",
                "Uterine hyperstimulation",
                "Uterine rupture (rare)"
            ]
        ),
        InductionMethod(
            name: "Misoprostol",
            description: "Prostaglandin E1 that promotes cervical ripening.",
            indications: [
                "Bishop Score < 6",
                "Unfavorable cervix",
                "Low risk of hyperstimulation"
            ],
            contraindications: [
                "Previous cesarean section",
                "Previous uterine surgery",
                "Hypersensitivity to prostaglandins"
            ],
            risks: [
                "Tachysystole",
                "Uterine hyperstimulation",
                "Uterine rupture"
            ]
        )
    ]
    
    static let mechanical = [
        InductionMethod(
            name: "Double balloon catheter",
            description: "Mechanical double balloon device that promotes cervical dilation.",
            indications: [
                "Bishop Score < 6",
                "Unfavorable cervix",
                "Previous cesarean section",
                "High risk of hyperstimulation"
            ],
            contraindications: [
                "PROM (Premature Rupture of Membranes)",
                "Marginal placenta",
                "Active maternal infections"
            ],
            risks: [
                "Discomfort during placement",
                "Mild bleeding",
                "Lower risk of uterine hyperstimulation"
            ]
        )
    ]
}
