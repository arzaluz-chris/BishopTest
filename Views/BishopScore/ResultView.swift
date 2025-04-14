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
                            
                            Text(NSLocalizedString("points", comment: "Score points label"))
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
                        Text(NSLocalizedString("Patient Information", comment: "Patient information section title"))
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                            .padding(.bottom, 4)
                        
                        // Information card content
                        VStack(alignment: .leading, spacing: 12) {
                            if let name = bishopScore.patientName, !name.isEmpty {
                                infoRow(
                                    icon: "person.fill",
                                    title: NSLocalizedString("Patient", comment: "Patient label"),
                                    value: name
                                )
                            }
                            
                            if let age = bishopScore.patientAge {
                                infoRow(
                                    icon: "calendar",
                                    title: NSLocalizedString("Age", comment: "Age label"),
                                    value: String.localizedStringWithFormat(NSLocalizedString("%d years", comment: "Age in years"), age)
                                )
                            }
                            
                            infoRow(
                                icon: "figure.2",
                                title: NSLocalizedString("Previous births", comment: "Previous births label"),
                                value: "\(bishopScore.previousDeliveries)"
                            )
                            
                            infoRow(
                                icon: "clock.fill",
                                title: NSLocalizedString("Date", comment: "Date label"),
                                value: dateFormatter.string(from: bishopScore.date)
                            )
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
                    Text(NSLocalizedString("Parameters", comment: "Parameters section title"))
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .padding(.bottom, 4)
                    
                    // Parameter grid
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        parameterBadge(
                            title: NSLocalizedString("Dilation", comment: "Parameter name for dilation"),
                            value: bishopScore.dilation.description,
                            points: bishopScore.dilation.rawValue
                        )
                        
                        parameterBadge(
                            title: NSLocalizedString("Effacement", comment: "Parameter name for effacement"),
                            value: bishopScore.effacement.description,
                            points: bishopScore.effacement.rawValue
                        )
                        
                        parameterBadge(
                            title: NSLocalizedString("Consistency", comment: "Parameter name for consistency"),
                            value: bishopScore.consistency.description,
                            points: bishopScore.consistency.rawValue
                        )
                        
                        parameterBadge(
                            title: NSLocalizedString("Position", comment: "Parameter name for position"),
                            value: bishopScore.position.description,
                            points: bishopScore.position.rawValue
                        )
                        
                        parameterBadge(
                            title: NSLocalizedString("Station", comment: "Parameter name for station"),
                            value: bishopScore.station.description,
                            points: bishopScore.station.rawValue
                        )
                    }
                    
                    // Modifiers if enabled
                    if useModifiers && (bishopScore.preeclampsia || bishopScore.postdatePregnancy || bishopScore.prematureRupture || bishopScore.nulliparous || bishopScore.previousDeliveries > 0) {
                        Divider()
                            .padding(.vertical, 8)
                        
                        Text(NSLocalizedString("Applied Modifiers", comment: "Applied modifiers section title"))
                            .font(.system(size: 16, weight: .medium, design: .rounded))
                            .padding(.bottom, 8)
                        
                        // Active modifiers list
                        VStack(alignment: .leading, spacing: 8) {
                            if bishopScore.preeclampsia {
                                modifierRow(title: NSLocalizedString("Preeclampsia", comment: "Preeclampsia modifier"), points: 1)
                            }
                            
                            if bishopScore.previousDeliveries > 0 {
                                modifierRow(
                                    title: String.localizedStringWithFormat(
                                        NSLocalizedString("Previous births (%d)", comment: "Previous births modifier with count"),
                                        bishopScore.previousDeliveries
                                    ),
                                    points: bishopScore.previousDeliveries
                                )
                            }
                            
                            if bishopScore.postdatePregnancy {
                                modifierRow(title: NSLocalizedString("Post-term pregnancy", comment: "Post-term pregnancy modifier"), points: -1)
                            }
                            
                            if bishopScore.nulliparous {
                                modifierRow(title: NSLocalizedString("Nulliparity", comment: "Nulliparity modifier"), points: -1)
                            }
                            
                            if bishopScore.prematureRupture {
                                modifierRow(title: NSLocalizedString("Premature rupture of membranes", comment: "Premature rupture modifier"), points: -1)
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
                    Text(NSLocalizedString("Recommendations", comment: "Recommendations section title"))
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
                    Text(NSLocalizedString("Recommended Methods", comment: "Recommended methods section title"))
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
                            Text(NSLocalizedString("Save", comment: "Save button title"))
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
                            Text(NSLocalizedString("Close", comment: "Close button title"))
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
        .navigationBarTitle(NSLocalizedString("Result", comment: "Navigation bar title"), displayMode: .inline)
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
                title: Text(NSLocalizedString("Saved", comment: "Alert title for saved evaluation")),
                message: Text(NSLocalizedString("The evaluation has been successfully saved.", comment: "Alert message for saved evaluation")),
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
        let maxPoints = 3 // Maximum score for a Bishop Score parameter
        let percentage = CGFloat(points) / CGFloat(maxPoints)
        return max(16, percentage * 100) // Minimum width of 16 to ensure visibility
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
                NSLocalizedString("No cervical ripening required", comment: "Recommendation for favorable cervix"),
                NSLocalizedString("Induction with oxytocin", comment: "Recommendation for favorable cervix"),
                NSLocalizedString("Consider amniotomy", comment: "Recommendation for favorable cervix")
            ]
        case .moderatelyFavorable:
            if bishopScore.nulliparous && useModifiers {
                return [
                    NSLocalizedString("In nulliparous women, consider cervical ripening", comment: "Recommendation for moderately favorable cervix in nulliparous"),
                    NSLocalizedString("Evaluate the need for prostaglandins", comment: "Recommendation for moderately favorable cervix in nulliparous"),
                    NSLocalizedString("Continuous monitoring during induction", comment: "Recommendation for moderately favorable cervix in nulliparous")
                ]
            } else {
                return [
                    NSLocalizedString("In multiparous women, start induction with oxytocin", comment: "Recommendation for moderately favorable cervix in multiparous"),
                    NSLocalizedString("Consider amniotomy if possible", comment: "Recommendation for moderately favorable cervix in multiparous"),
                    NSLocalizedString("Continuous monitoring during induction", comment: "Recommendation for moderately favorable cervix in multiparous")
                ]
            }
        case .unfavorable:
            return [
                NSLocalizedString("Pharmacological cervical ripening with prostaglandins", comment: "Recommendation for unfavorable cervix"),
                NSLocalizedString("Consider mechanical methods (balloon)", comment: "Recommendation for unfavorable cervix"),
                NSLocalizedString("Reevaluate after cervical ripening", comment: "Recommendation for unfavorable cervix")
            ]
        }
    }
    
    // Recommended induction methods
    private var recommendedMethods: [InductionMethod] {
        InductionMethod.recommendedMethods(for: bishopScore)
    }
}
