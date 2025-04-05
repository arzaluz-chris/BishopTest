import Foundation

// Esta es la estructura principal que representa el Test de Bishop
struct BishopScore: Identifiable, Codable {
    var id = UUID()
    var date: Date
    var patientName: String?
    var patientAge: Int?
    var previousDeliveries: Int
    
    // Parámetros del Test de Bishop
    var dilation: Dilation
    var effacement: Effacement
    var consistency: Consistency
    var position: Position
    var station: Station
    
    // Modificadores
    var preeclampsia: Bool
    var postdatePregnancy: Bool
    var nulliparous: Bool
    var prematureRupture: Bool
    
    // Valores por defecto para una nueva evaluación
    init(date: Date = Date(), patientName: String? = nil, patientAge: Int? = nil, previousDeliveries: Int = 0) {
        self.date = date
        self.patientName = patientName
        self.patientAge = patientAge
        self.previousDeliveries = previousDeliveries
        
        // Valores por defecto
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
    
    // Función para calcular la puntuación con o sin modificadores
    func calculateTotalScore(applyModifiers: Bool = true) -> Int {
        var score = 0
        
        // Sumar puntos por parámetros
        score += dilation.rawValue
        score += effacement.rawValue
        score += consistency.rawValue
        score += position.rawValue
        score += station.rawValue
        
        // Aplicar modificadores solo si se solicita
        if applyModifiers {
            if preeclampsia { score += 1 }
            if previousDeliveries > 0 { score += previousDeliveries }
            if postdatePregnancy { score -= 1 }
            if nulliparous { score -= 1 }
            if prematureRupture { score -= 1 }
        }
        
        return max(0, score) // No permitir puntuaciones negativas
    }
    
    // Calcula la puntuación total (con modificadores por defecto)
    var totalScore: Int {
        return calculateTotalScore()
    }
    
    // Interpretación del resultado
    var interpretation: ScoreInterpretation {
        if totalScore >= 8 {
            return .favorable
        } else if totalScore >= 6 {
            return .moderatelyFavorable
        } else {
            return .unfavorable
        }
    }
    
    // Recomendaciones basadas en la puntuación
    var recommendations: [String] {
        switch interpretation {
        case .favorable:
            return [
                "No se requiere maduración cervical previa",
                "Inducción con oxitocina",
                "Considerar amniotomía"
            ]
        case .moderatelyFavorable:
            if nulliparous {
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
}

// Enumeraciones para los parámetros del Test de Bishop
enum Dilation: Int, Codable, CaseIterable, Identifiable {
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

enum Effacement: Int, Codable, CaseIterable, Identifiable {
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

enum Consistency: Int, Codable, CaseIterable, Identifiable {
    case firm = 0
    case medium = 1
    case soft = 2
    
    var id: Int { self.rawValue }
    
    var description: String {
        switch self {
        case .firm: return "Firme"
        case .medium: return "Media"
        case .soft: return "Blanda"
        }
    }
}

enum Position: Int, Codable, CaseIterable, Identifiable {
    case posterior = 0
    case middle = 1
    case anterior = 2
    
    var id: Int { self.rawValue }
    
    var description: String {
        switch self {
        case .posterior: return "Posterior"
        case .middle: return "Media"
        case .anterior: return "Anterior"
        }
    }
}

enum Station: Int, Codable, CaseIterable, Identifiable {
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
    case favorable = "Cérvix Favorable"
    case moderatelyFavorable = "Cérvix Moderadamente Favorable"
    case unfavorable = "Cérvix Desfavorable"
    
    var description: String {
        switch self {
        case .favorable:
            return "Un puntaje mayor a 8 indica buenas condiciones para la inducción del parto."
        case .moderatelyFavorable:
            return "Un puntaje entre 6-7 indica condiciones moderadas para la inducción, especialmente en multíparas."
        case .unfavorable:
            return "Un puntaje menor a 6 indica condiciones desfavorables, se recomienda maduración cervical previa."
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
