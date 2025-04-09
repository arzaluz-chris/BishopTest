// ResultView.swift
import SwiftUI
import Combine

struct ResultView: View {
    let bishopScore: BishopScore
    @ObservedObject var dataStore: DataStore
    @Binding var isPresented: Bool
    @State private var showingSavedConfirmation = false
    @State private var animateScore = false
    @Environment(\.selectedTabPublisher) var selectedTabPublisher
    @AppStorage("useModifiers") private var useModifiers = true
    
    // Date formatter
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 28) {
                // Score header
                VStack(spacing: 16) {
                    // Score animation
                    ZStack {
                        // Outer circle (progress)
                        Circle()
                            .trim(from: 0, to: CGFloat(min(Double(score) / 13.0, 1.0)))
                            .stroke(
                                scoreColor,
                                style: StrokeStyle(lineWidth: 12, lineCap: .round)
                            )
                            .frame(width: 160, height: 160)
                            .rotationEffect(.degrees(-90))
                            .animation(.easeInOut(duration: 1.5), value: animateScore)
                        
                        // Inner circle
                        Circle()
                            .fill(scoreColor.opacity(0.1))
                            .frame(width: 140, height: 140)
                        
                        // Score
                        VStack(spacing: 0) {
                            Text("\(score)")
                                .font(.system(size: 60, weight: .bold, design: .rounded))
                                .foregroundColor(scoreColor)
                            
                            Text("points")
                                .font(.system(size: 16, design: .rounded))
                                .foregroundColor(scoreColor.opacity(0.8))
                        }
                    }
                    .padding(.top, 20)
                    
                    // Interpretation
                    Text(interpretation.rawValue)
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(scoreColor)
                        .multilineTextAlignment(.center)
                    
                    // Description
                    Text(interpretation.description)
                        .font(.system(size: 16, weight: .regular, design: .rounded))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                        .foregroundColor(.secondary)
                }
                .padding(.bottom, 10)
                
                // Patient information
                if bishopScore.patientName != nil || bishopScore.patientAge != nil {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Patient Information")
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                            .padding(.bottom, 4)
                        
                        // Information card content
                        VStack(alignment: .leading, spacing: 12) {
                            if let name = bishopScore.patientName, !name.isEmpty {
                                infoRow(icon: "person.fill", title: "Patient", value: name)
                            }
                            
                            if let age = bishopScore.patientAge {
                                infoRow(icon: "calendar", title: "Age", value: "\(age) years")
                            }
                            
                            infoRow(icon: "figure.2", title: "Previous births", value: "\(bishopScore.previousDeliveries)")
                            
                            infoRow(icon: "clock.fill", title: "Date", value: dateFormatter.string(from: bishopScore.date))
                        }
                    }
                    .padding(20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(BishopDesign.Colors.cardBackground)
                    .cornerRadius(20)
                    .padding(.horizontal, 20)
                }
                
                // Evaluated parameters
                VStack(alignment: .leading, spacing: 16) {
                    Text("Parameters")
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .padding(.bottom, 4)
                    
                    // Parameter grid
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        parameterBadge(
                            title: "Dilation",
                            value: bishopScore.dilation.description,
                            points: bishopScore.dilation.rawValue
                        )
                        
                        parameterBadge(
                            title: "Effacement",
                            value: bishopScore.effacement.description,
                            points: bishopScore.effacement.rawValue
                        )
                        
                        parameterBadge(
                            title: "Consistency",
                            value: bishopScore.consistency.description,
                            points: bishopScore.consistency.rawValue
                        )
                        
                        parameterBadge(
                            title: "Position",
                            value: bishopScore.position.description,
                            points: bishopScore.position.rawValue
                        )
                        
                        parameterBadge(
                            title: "Station",
                            value: bishopScore.station.description,
                            points: bishopScore.station.rawValue
                        )
                    }
                    
                    // Modifiers if enabled
                    if useModifiers && (bishopScore.preeclampsia || bishopScore.postdatePregnancy || bishopScore.prematureRupture || bishopScore.nulliparous || bishopScore.previousDeliveries > 0) {
                        Divider()
                            .padding(.vertical, 8)
                        
                        Text("Applied Modifiers")
                            .font(.system(size: 16, weight: .medium, design: .rounded))
                            .padding(.bottom, 8)
                        
                        // Active modifiers list
                        VStack(alignment: .leading, spacing: 8) {
                            if bishopScore.preeclampsia {
                                modifierRow(title: "Preeclampsia", points: 1)
                            }
                            
                            if bishopScore.previousDeliveries > 0 {
                                modifierRow(title: "Partos previos (\(bishopScore.previousDeliveries))", points: bishopScore.previousDeliveries)
                            }
                            
                            if bishopScore.postdatePregnancy {
                                modifierRow(title: "Post-term pregnancy", points: -1)
                            }
                            
                            if bishopScore.nulliparous {
                                modifierRow(title: "Nulliparity", points: -1)
                            }
                            
                            if bishopScore.prematureRupture {
                                modifierRow(title: "Premature rupture of membranes", points: -1)
                            }
                        }
                    }
                }
                .padding(20)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(BishopDesign.Colors.cardBackground)
                .cornerRadius(20)
                .padding(.horizontal, 20)
                
                // Recommendations
                VStack(alignment: .leading, spacing: 16) {
                    Text("Recommendations")
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .padding(.bottom, 4)
                    
                    // Recommendation list
                    ForEach(recommendations, id: \.self) { recommendation in
                        HStack(alignment: .top, spacing: 12) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 18))
                                .foregroundColor(scoreColor)
                            
                            Text(recommendation)
                                .font(.system(size: 16, design: .rounded))
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .padding(.vertical, 4)
                    }
                }
                .padding(20)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(BishopDesign.Colors.cardBackground)
                .cornerRadius(20)
                .padding(.horizontal, 20)
                
                // Recommended induction methods
                VStack(alignment: .leading, spacing: 16) {
                    Text("Recommended Methods")
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .padding(.bottom, 4)
                    
                    // Methods list
                    ForEach(recommendedMethods, id: \.id) { method in
                        NavigationLink(destination: InductionMethodDetailView(method: method)) {
                            HStack(spacing: 12) {
                                Image(systemName: "syringe")
                                    .font(.system(size: 18))
                                    .foregroundColor(scoreColor)
                                
                                Text(method.name)
                                    .font(.system(size: 16, weight: .medium, design: .rounded))
                                    .foregroundColor(.primary)
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 14))
                                    .foregroundColor(.secondary)
                            }
                            .padding(.vertical, 8)
                        }
                    }
                }
                .padding(20)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(BishopDesign.Colors.cardBackground)
                .cornerRadius(20)
                .padding(.horizontal, 20)
                
                // Action buttons
                HStack(spacing: 16) {
                    // Save button
                    Button(action: {
                        dataStore.saveScore(bishopScore)
                        showingSavedConfirmation = true
                    }) {
                        HStack {
                            Image(systemName: "square.and.arrow.down")
                            Text("Save")
                        }
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(BishopDesign.Colors.primary)
                        .foregroundColor(.white)
                        .cornerRadius(16)
                        .shadow(color: BishopDesign.Colors.primary.opacity(0.4), radius: 8, x: 0, y: 4)
                    }
                    
                    // Close button
                    Button(action: {
                        isPresented = false
                    }) {
                        HStack {
                            Image(systemName: "xmark")
                            Text("Close")
                        }
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color(.systemGray5))
                        .foregroundColor(.primary)
                        .cornerRadius(16)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .padding(.bottom, 30)
            }
        }
        .navigationBarTitle("Result", displayMode: .inline)
        .background(BishopDesign.Colors.background.edgesIgnoringSafeArea(.all))
        .onAppear {
            // Animate score on appear
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation {
                    animateScore = true
                }
            }
        }
        .alert(isPresented: $showingSavedConfirmation) {
                Alert(
                    title: Text("Saved"),
                    message: Text("The evaluation has been successfully saved."),
                dismissButton: .default(Text("OK")) {
                    // Close current view
                    isPresented = false
                    
                    // Navigate to Home tab (index 0)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        selectedTabPublisher.send(0)
                    }
                }
            )
        }
    }
    
    // Information row
    private func infoRow(icon: String, title: String, value: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(BishopDesign.Colors.primary)
                .frame(width: 24, height: 24)
            
            Text(title)
                .font(.system(size: 15, design: .rounded))
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text(value)
                .font(.system(size: 16, weight: .medium, design: .rounded))
        }
    }
    
    // Badge for parameters
    private func parameterBadge(title: String, value: String, points: Int) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 14, design: .rounded))
                .foregroundColor(.secondary)
            
            HStack {
                Text(value)
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                
                Spacer()
                
                Text("+\(points)")
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(scoreColor.opacity(0.15))
                    .foregroundColor(scoreColor)
                    .cornerRadius(8)
            }
            
            Rectangle()
                .fill(scoreColor.opacity(0.15))
                .frame(height: 4)
                .cornerRadius(2)
                .overlay(
                    HStack {
                        Rectangle()
                            .fill(scoreColor)
                            .frame(width: getParameterProgress(points: points), height: 4)
                            .cornerRadius(2)
                        
                        Spacer(minLength: 0)
                    }
                )
        }
        .padding(12)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    // Calculate progress for parameter bar
    private func getParameterProgress(points: Int) -> CGFloat {
        let maxPoints = 3 // Máxima puntuación para un parámetro en Bishop Score
        let percentage = CGFloat(points) / CGFloat(maxPoints)
        return max(16, percentage * 100) // Mínimo 16 puntos para que sea visible
    }
    
    // Modifier row
    private func modifierRow(title: String, points: Int) -> some View {
        HStack {
            Image(systemName: points > 0 ? "plus.circle.fill" : "minus.circle.fill")
                .foregroundColor(points > 0 ? BishopDesign.Colors.favorable : BishopDesign.Colors.unfavorable)
            
            Text(title)
                .font(.system(size: 15, design: .rounded))
            
            Spacer()
            
            Text(points > 0 ? "+\(points)" : "\(points)")
                .font(.system(size: 14, weight: .semibold, design: .rounded))
                .foregroundColor(points > 0 ? BishopDesign.Colors.favorable : BishopDesign.Colors.unfavorable)
        }
        .padding(.vertical, 4)
    }
    
    // Computed properties
    
    // Total score with or without modifiers
    private var score: Int {
        bishopScore.calculateTotalScore(applyModifiers: useModifiers)
    }
    
    // Interpretation based on score
    private var interpretation: ScoreInterpretation {
        if score >= 8 {
            return .favorable
        } else if score >= 6 {
            return .moderatelyFavorable
        } else {
            return .unfavorable
        }
    }
    
    // Color based on interpretation
    private var scoreColor: Color {
        switch interpretation {
        case .favorable:
            return BishopDesign.Colors.favorable
        case .moderatelyFavorable:
            return BishopDesign.Colors.moderate
        case .unfavorable:
            return BishopDesign.Colors.unfavorable
        }
    }
    
    // Recommendations based on interpretation
    private var recommendations: [String] {
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
    
    // Recommended induction methods
    private var recommendedMethods: [InductionMethod] {
        InductionMethod.recommendedMethods(for: bishopScore)
    }
}
