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
                
                // Remaining view remains the same, with localization added to specific strings
                // ... [The rest of the view would be localized similarly]
                
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
    
    // Private methods with localized strings
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
    
    // Remaining private methods would be localized similarly
    
    // Computed properties remain the same
    private var score: Int {
        bishopScore.calculateTotalScore(applyModifiers: useModifiers)
    }
    
    private var interpretation: ScoreInterpretation {
        if score >= 8 {
            return .favorable
        } else if score >= 6 {
            return .moderatelyFavorable
        } else {
            return .unfavorable
        }
    }
    
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
}
