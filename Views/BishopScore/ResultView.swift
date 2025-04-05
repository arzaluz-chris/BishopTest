import SwiftUI
import Combine

struct ResultView: View {
    let bishopScore: BishopScore
    @ObservedObject var dataStore: DataStore
    @Binding var isPresented: Bool
    @State private var showingSavedConfirmation = false
    @Environment(\.selectedTabPublisher) var selectedTabPublisher
    @AppStorage("useModifiers") private var useModifiers = true
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Puntuación
                    ZStack {
                        Circle()
                            .fill(scoreColor.opacity(0.2))
                            .frame(width: 140, height: 140)
                        
                        Circle()
                            .stroke(scoreColor, lineWidth: 5)
                            .frame(width: 140, height: 140)
                        
                        Text("\(bishopScore.calculateTotalScore(applyModifiers: useModifiers))")
                            .font(.system(size: 50, weight: .bold))
                            .foregroundColor(scoreColor)
                    }
                    .padding(.top)
                    
                    // Interpretación
                    VStack(alignment: .leading, spacing: 10) {
                        Text(interpretation.rawValue)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(scoreColor)
                        
                        Text(interpretation.description)
                            .font(.body)
                            .multilineTextAlignment(.leading)
                            .padding(.bottom, 5)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(scoreColor.opacity(0.1))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    
                    // Recomendaciones
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Recomendaciones:")
                            .font(.headline)
                            .padding(.bottom, 5)
                        
                        ForEach(recommendations, id: \.self) { recommendation in
                            HStack(alignment: .top) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(scoreColor)
                                
                                Text(recommendation)
                                    .font(.body)
                            }
                            .padding(.vertical, 3)
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.systemBackground))
                    .cornerRadius(10)
                    .shadow(radius: 2)
                    .padding(.horizontal)
                    
                    // Métodos de inducción recomendados
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Métodos de inducción recomendados:")
                            .font(.headline)
                            .padding(.bottom, 5)
                        
                        ForEach(InductionMethod.recommendedMethods(for: adjustedScore), id: \.id) { method in
                            HStack(alignment: .top) {
                                Image(systemName: "syringe.fill")
                                    .foregroundColor(scoreColor)
                                
                                Text(method.name)
                                    .font(.body)
                                    .fontWeight(.medium)
                            }
                            .padding(.vertical, 3)
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.systemBackground))
                    .cornerRadius(10)
                    .shadow(radius: 2)
                    .padding(.horizontal)
                    
                    // Botones
                    HStack {
                        Button(action: {
                            dataStore.saveScore(bishopScore)
                            showingSavedConfirmation = true
                        }) {
                            Text("Guardar")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color("AppPrimary"))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        
                        Button(action: {
                            isPresented = false
                        }) {
                            Text("Cerrar")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.gray.opacity(0.3))
                                .foregroundColor(.primary)
                                .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom)
            }
            .navigationBarTitle("Resultado", displayMode: .inline)
            .alert(isPresented: $showingSavedConfirmation) {
                Alert(
                    title: Text("Guardado"),
                    message: Text("La evaluación ha sido guardada correctamente."),
                    dismissButton: .default(Text("OK")) {
                        // Cerrar la vista actual
                        isPresented = false
                        
                        // Navegar a la pestaña Home (índice 0)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            selectedTabPublisher.send(0)
                        }
                    }
                )
            }
        }
    }
    
    // Puntuación ajustada para cálculos
    private var adjustedScore: BishopScore {
        var score = bishopScore
        if !useModifiers {
            score.preeclampsia = false
            score.postdatePregnancy = false
            score.prematureRupture = false
            score.nulliparous = false
        }
        return score
    }
    
    // Interpretación basada en la puntuación ajustada
    var interpretation: ScoreInterpretation {
        let score = bishopScore.calculateTotalScore(applyModifiers: useModifiers)
        if score >= 8 {
            return .favorable
        } else if score >= 6 {
            return .moderatelyFavorable
        } else {
            return .unfavorable
        }
    }
    
    // Recomendaciones basadas en la interpretación
    var recommendations: [String] {
        switch interpretation {
        case .favorable:
            return [
                "No se requiere maduración cervical previa",
                "Inducción con oxitocina",
                "Considerar amniotomía"
            ]
        case .moderatelyFavorable:
            if bishopScore.nulliparous && useModifiers {
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
    
    var scoreColor: Color {
        switch interpretation {
        case .favorable:
            return Color("FavorableGreen")
        case .moderatelyFavorable:
            return Color("ModerateOrange")
        case .unfavorable:
            return Color("UnfavorableRed")
        }
    }
}
