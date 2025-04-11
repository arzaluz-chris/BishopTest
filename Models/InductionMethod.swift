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
            name: NSLocalizedString("Oxytocin", comment: "Induction method name"),
            description: NSLocalizedString("Synthetic hormone that stimulates uterine contractions.", comment: "Oxytocin description"),
            indications: [
                NSLocalizedString("Bishop Score ≥ 6", comment: "Oxytocin indication"),
                NSLocalizedString("Favorable cervix", comment: "Oxytocin indication")
            ],
            contraindications: [
                NSLocalizedString("Placenta previa", comment: "Oxytocin contraindication"),
                NSLocalizedString("Vasa previa", comment: "Oxytocin contraindication"),
                NSLocalizedString("Cord prolapse", comment: "Oxytocin contraindication")
            ],
            risks: [
                NSLocalizedString("Uterine hyperstimulation", comment: "Oxytocin risk"),
                NSLocalizedString("FHR abnormalities", comment: "Oxytocin risk"),
                NSLocalizedString("Uterine rupture (rare)", comment: "Oxytocin risk")
            ]
        )
    ]
    
    static let prostaglandins = [
        InductionMethod(
            name: NSLocalizedString("Dinoprostone", comment: "Induction method name"),
            description: NSLocalizedString("Prostaglandin E2 that promotes cervical ripening.", comment: "Dinoprostone description"),
            indications: [
                NSLocalizedString("Bishop Score < 6", comment: "Dinoprostone indication"),
                NSLocalizedString("Unfavorable cervix", comment: "Dinoprostone indication")
            ],
            contraindications: [
                NSLocalizedString("Previous cesarean section", comment: "Dinoprostone contraindication"),
                NSLocalizedString("Grand multiparity (≥6 births)", comment: "Dinoprostone contraindication"),
                NSLocalizedString("Hypersensitivity to prostaglandins", comment: "Dinoprostone contraindication")
            ],
            risks: [
                NSLocalizedString("Tachysystole", comment: "Dinoprostone risk"),
                NSLocalizedString("Uterine hyperstimulation", comment: "Dinoprostone risk"),
                NSLocalizedString("Uterine rupture (rare)", comment: "Dinoprostone risk")
            ]
        ),
        InductionMethod(
            name: NSLocalizedString("Misoprostol", comment: "Induction method name"),
            description: NSLocalizedString("Prostaglandin E1 that promotes cervical ripening.", comment: "Misoprostol description"),
            indications: [
                NSLocalizedString("Bishop Score < 6", comment: "Misoprostol indication"),
                NSLocalizedString("Unfavorable cervix", comment: "Misoprostol indication"),
                NSLocalizedString("Low risk of hyperstimulation", comment: "Misoprostol indication")
            ],
            contraindications: [
                NSLocalizedString("Previous cesarean section", comment: "Misoprostol contraindication"),
                NSLocalizedString("Previous uterine surgery", comment: "Misoprostol contraindication"),
                NSLocalizedString("Hypersensitivity to prostaglandins", comment: "Misoprostol contraindication")
            ],
            risks: [
                NSLocalizedString("Tachysystole", comment: "Misoprostol risk"),
                NSLocalizedString("Uterine hyperstimulation", comment: "Misoprostol risk"),
                NSLocalizedString("Uterine rupture", comment: "Misoprostol risk")
            ]
        )
    ]
    
    static let mechanical = [
        InductionMethod(
            name: NSLocalizedString("Double balloon catheter", comment: "Induction method name"),
            description: NSLocalizedString("Mechanical double balloon device that promotes cervical dilation.", comment: "Mechanical method description"),
            indications: [
                NSLocalizedString("Bishop Score < 6", comment: "Mechanical method indication"),
                NSLocalizedString("Unfavorable cervix", comment: "Mechanical method indication"),
                NSLocalizedString("Previous cesarean section", comment: "Mechanical method indication"),
                NSLocalizedString("High risk of hyperstimulation", comment: "Mechanical method indication")
            ],
            contraindications: [
                NSLocalizedString("PROM (Premature Rupture of Membranes)", comment: "Mechanical method contraindication"),
                NSLocalizedString("Marginal placenta", comment: "Mechanical method contraindication"),
                NSLocalizedString("Active maternal infections", comment: "Mechanical method contraindication")
            ],
            risks: [
                NSLocalizedString("Discomfort during placement", comment: "Mechanical method risk"),
                NSLocalizedString("Mild bleeding", comment: "Mechanical method risk"),
                NSLocalizedString("Lower risk of uterine hyperstimulation", comment: "Mechanical method risk")
            ]
        )
    ]
}
