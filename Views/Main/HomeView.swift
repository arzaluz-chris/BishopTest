// HomeView.swift
import SwiftUI

struct HomeView: View {
    @AppStorage("userName") private var userName = ""
    @AppStorage("userSpecialty") private var userSpecialty = ""
    @EnvironmentObject var dataStore: DataStore
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: BishopDesign.Layout.sectionSpacing) {
                    // Header with personalized greeting
                    VStack(alignment: .leading, spacing: 8) {
                        if !userName.isEmpty {
                            Text(String.localizedStringWithFormat(NSLocalizedString("Hello, %@", comment: "Personalized greeting"), firstName))
                                .font(.system(size: 28, weight: .bold, design: .rounded))
                                .padding(.top, 12)
                        } else {
                            Text(NSLocalizedString("Welcome", comment: "Generic welcome message"))
                                .font(.system(size: 28, weight: .bold, design: .rounded))
                                .padding(.top, 12)
                        }
                        
                        Text(!userSpecialty.isEmpty ? userSpecialty : NSLocalizedString("Bishop Test", comment: "Default specialty text"))
                            .font(.system(size: 17, design: .rounded))
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 24)
                    
                    // Main card to start evaluation
                    NavigationLink(destination: BishopScoreView()) {
                        HStack(spacing: 20) {
                            // Left part with text
                            VStack(alignment: .leading, spacing: 12) {
                                Text(NSLocalizedString("Evaluation", comment: "Evaluation section title"))
                                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                                    .foregroundColor(.white)
                                
                                Text(NSLocalizedString("Start new Bishop test", comment: "Start test button description"))
                                    .font(.system(size: 15, design: .rounded))
                                    .foregroundColor(.white.opacity(0.9))
                                    .multilineTextAlignment(.leading)
                                
                                Spacer()
                                
                                Text(NSLocalizedString("Start", comment: "Start button text"))
                                    .font(.system(size: 16, weight: .medium, design: .rounded))
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(Color.white.opacity(0.2))
                                    .cornerRadius(20)
                                    .foregroundColor(.white)
                            }
                            
                            Spacer()
                            
                            // Right part with illustration
                            Image(systemName: "stethoscope")
                                .font(.system(size: 54, weight: .regular))
                                .foregroundColor(.white.opacity(0.9))
                                .frame(width: 80, height: 80)
                                .padding(.trailing, 8)
                        }
                        .padding(20)
                        .frame(height: 180)
                        .frame(maxWidth: .infinity)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [BishopDesign.Colors.primary, BishopDesign.Colors.primary.opacity(0.8)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .cornerRadius(24)
                        .shadow(color: BishopDesign.Colors.primary.opacity(0.3), radius: 15, x: 0, y: 10)
                    }
                    .padding(.horizontal, 24)
                    
                    // Quick access section
                    VStack(alignment: .leading, spacing: 16) {
                        Text(NSLocalizedString("Quick Access", comment: "Quick access section title"))
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .padding(.horizontal, 24)
                        
                        // Updated to properly center the cards
                        HStack(spacing: 16) {
                            Spacer()
                            
                            // History - only show badge if there are evaluations
                            QuickAccessCard(
                                title: NSLocalizedString("History", comment: "History quick access title"),
                                icon: "clock.fill",
                                color: .purple,
                                count: dataStore.savedScores.isEmpty ? nil : "\(dataStore.savedScores.count)",
                                destination: AnyView(HistoryView())
                            )
                            
                            // Information
                            QuickAccessCard(
                                title: NSLocalizedString("Information", comment: "Information quick access title"),
                                icon: "info.circle.fill",
                                color: .blue,
                                destination: AnyView(InformationView())
                            )
                            
                            // Methods
                            QuickAccessCard(
                                title: NSLocalizedString("Methods", comment: "Induction methods quick access title"),
                                icon: "list.bullet.clipboard",
                                color: .orange,
                                destination: AnyView(InductionMethodsView())
                            )
                            
                            Spacer()
                        }
                        .padding(.horizontal, 24)
                    }
                    
                    // If there are recent evaluations, show them
                    if !dataStore.savedScores.isEmpty {
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text(NSLocalizedString("Recent Evaluations", comment: "Recent evaluations section title"))
                                    .font(.system(size: 20, weight: .bold, design: .rounded))
                                
                                Spacer()
                                
                                NavigationLink(destination: HistoryView()) {
                                    Text(NSLocalizedString("View All", comment: "View all evaluations button"))
                                        .font(.system(size: 16, weight: .medium, design: .rounded))
                                        .foregroundColor(BishopDesign.Colors.primary)
                                }
                            }
                            .padding(.horizontal, 24)
                            
                            // List of recent evaluations
                            VStack(spacing: 12) {
                                ForEach(Array(dataStore.savedScores.sorted(by: { $0.date > $1.date }).prefix(2))) { score in
                                    NavigationLink(destination: ResultView(bishopScore: score, dataStore: dataStore, isPresented: .constant(false))) {
                                        RecentScoreCard(score: score)
                                    }
                                }
                            }
                            .padding(.horizontal, 24)
                        }
                    } else {
                        // If there are no evaluations, show message
                        VStack(spacing: 20) {
                            Image(systemName: "square.stack.3d.up.slash")
                                .font(.system(size: 40))
                                .foregroundColor(.secondary.opacity(0.6))
                            
                            Text(NSLocalizedString("No saved evaluations", comment: "Message when no evaluations exist"))
                                .font(.system(size: 17, design: .rounded))
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .padding(.vertical, 20)
                    }
                }
                .padding(.vertical, 20)
            }
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarHidden(true)
            .background(BishopDesign.Colors.background.edgesIgnoringSafeArea(.all))
        }
    }
    
    // Extract the first name
    private var firstName: String {
        userName.components(separatedBy: " ").first ?? userName
    }
}

// Component for quick access cards
struct QuickAccessCard<Destination: View>: View {
    let title: String
    let icon: String
    let color: Color
    var count: String? = nil
    let destination: Destination
    
    var body: some View {
        NavigationLink(destination: destination) {
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.15))
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: icon)
                        .font(.system(size: 26, weight: .medium))
                        .foregroundColor(color)
                    
                    // Badge for count if it exists
                    if let count = count {
                        ZStack {
                            Circle()
                                .fill(Color.red)
                                .frame(width: 22, height: 22)
                            
                            Text(count)
                                .font(.system(size: 13, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                        }
                        .offset(x: 22, y: -22)
                    }
                }
                
                Text(title)
                    .font(.system(size: 15, weight: .medium, design: .rounded))
                    .foregroundColor(.primary)
            }
            .frame(width: 100, height: 120)
            .background(BishopDesign.Colors.cardBackground)
            .cornerRadius(20)
        }
    }
}

// Component for recent evaluation cards
struct RecentScoreCard: View {
    let score: BishopScore
    
    // Formatter to display the date
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
    
    // Color based on interpretation
    private var scoreColor: Color {
        switch score.interpretation {
        case .favorable:
            return BishopDesign.Colors.favorable
        case .moderatelyFavorable:
            return BishopDesign.Colors.moderate
        case .unfavorable:
            return BishopDesign.Colors.unfavorable
        }
    }
    
    var body: some View {
        HStack(spacing: 16) {
            // Badge with score
            ZStack {
                Circle()
                    .fill(scoreColor.opacity(0.15))
                    .frame(width: 50, height: 50)
                
                Text("\(score.totalScore)")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(scoreColor)
            }
            
            // Middle section with patient details
            VStack(alignment: .leading, spacing: 4) {
                Text(score.patientName ?? NSLocalizedString("Patient without name", comment: "Default patient name"))
                    .font(.system(size: 17, weight: .medium, design: .rounded))
                    .foregroundColor(.blue)
                    .lineLimit(1)
                
                Text(dateFormatter.string(from: score.date))
                    .font(.system(size: 14, design: .rounded))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Interpretation badge
            HStack(spacing: 4) {
                let interpretationText = getInterpretationText(score.interpretation)
                let interpretationIcon = getInterpretationIcon(score.interpretation)
                
                Image(systemName: interpretationIcon)
                    .font(.system(size: 12))
                
                Text(interpretationText)
                    .font(.system(size: 13, weight: .medium, design: .rounded))
                    .lineLimit(1)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(scoreColor.opacity(0.15))
            .foregroundColor(scoreColor)
            .cornerRadius(16)
        }
        .padding(16)
        .background(BishopDesign.Colors.cardBackground)
        .cornerRadius(16)
    }
    
    // Helper functions to get interpretation text and icon
    private func getInterpretationText(_ interpretation: ScoreInterpretation) -> String {
        switch interpretation {
        case .favorable:
            return NSLocalizedString("Favorable", comment: "Favorable interpretation")
        case .moderatelyFavorable:
            return NSLocalizedString("Moderate", comment: "Moderate interpretation")
        case .unfavorable:
            return NSLocalizedString("Unfavorable", comment: "Unfavorable interpretation")
        }
    }
    
    private func getInterpretationIcon(_ interpretation: ScoreInterpretation) -> String {
        switch interpretation {
        case .favorable:
            return "checkmark.circle.fill"
        case .moderatelyFavorable:
            return "arrow.up.right.circle.fill"
        case .unfavorable:
            return "exclamationmark.circle.fill"
        }
    }
}
