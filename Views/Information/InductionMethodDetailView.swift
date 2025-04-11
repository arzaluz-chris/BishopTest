// InductionMethodDetailView.swift
import SwiftUI

struct InductionMethodDetailView: View {
    let method: InductionMethod
    @Environment(\.colorScheme) var colorScheme
    
    // Colors based on method type
    private var methodColor: Color {
        if InductionMethod.oxytocin.contains(where: { $0.id == method.id }) {
            return Color.blue
        } else if InductionMethod.prostaglandins.contains(where: { $0.id == method.id }) {
            return Color.green
        } else {
            return Color.orange
        }
    }
    
    // Icon based on method type
    private var methodIcon: String {
        if InductionMethod.oxytocin.contains(where: { $0.id == method.id }) {
            return "drop.fill"
        } else if InductionMethod.prostaglandins.contains(where: { $0.id == method.id }) {
            return "pill.fill"
        } else {
            return "bandage.fill"
        }
    }
    
    // Determine method type to show category
    private var methodType: String {
        if InductionMethod.oxytocin.contains(where: { $0.id == method.id }) {
            return NSLocalizedString("Oxytocin", comment: "Oxytocin method type")
        } else if InductionMethod.prostaglandins.contains(where: { $0.id == method.id }) {
            return NSLocalizedString("Prostaglandin", comment: "Prostaglandin method type")
        } else {
            return NSLocalizedString("Mechanical method", comment: "Mechanical method type")
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header with icon and name
                VStack(spacing: 16) {
                    // Method icon
                    ZStack {
                        Circle()
                            .fill(methodColor.opacity(0.15))
                            .frame(width: 100, height: 100)
                        
                        Image(systemName: methodIcon)
                            .font(.system(size: 44))
                            .foregroundColor(methodColor)
                    }
                    .padding(.top, 20)
                    
                    // Method type
                    Text(methodType)
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(methodColor.opacity(0.15))
                        .foregroundColor(methodColor)
                        .cornerRadius(12)
                    
                    // Method name
                    Text(method.name)
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .frame(maxWidth: .infinity)
                
                // Description
                VStack(alignment: .leading, spacing: 16) {
                    Text(NSLocalizedString("Description", comment: "Description section title"))
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                    
                    Text(method.description)
                        .font(.system(size: 16, design: .rounded))
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.horizontal, 20)
                
                // Indications section
                SectionCard(
                    title: NSLocalizedString("Indications", comment: "Indications section title"),
                    items: method.indications,
                    iconName: "checkmark.circle.fill",
                    color: .green
                )
                .padding(.horizontal, 20)
                
                // Contraindications section
                SectionCard(
                    title: NSLocalizedString("Contraindications", comment: "Contraindications section title"),
                    items: method.contraindications,
                    iconName: "xmark.circle.fill",
                    color: .red
                )
                .padding(.horizontal, 20)
                
                // Potential risks section
                SectionCard(
                    title: NSLocalizedString("Potential risks", comment: "Potential risks section title"),
                    items: method.risks,
                    iconName: "exclamationmark.triangle.fill",
                    color: .orange
                )
                .padding(.horizontal, 20)
                
                // Additional information section
                VStack(alignment: .leading, spacing: 16) {
                    Text(NSLocalizedString("Additional information", comment: "Additional information section title"))
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                    
                    // Visual indicators about the method
                    HStack(spacing: 20) {
                        // Effectiveness
                        VStack(spacing: 8) {
                            Text(NSLocalizedString("Effectiveness", comment: "Effectiveness rating label"))
                                .font(.system(size: 14, design: .rounded))
                                .foregroundColor(.secondary)
                            
                            RatingView(rating: getEffectivenessRating(), maxRating: 5, color: methodColor)
                        }
                        .frame(maxWidth: .infinity)
                        
                        // Speed of action
                        VStack(spacing: 8) {
                            Text(NSLocalizedString("Speed", comment: "Speed rating label"))
                                .font(.system(size: 14, design: .rounded))
                                .foregroundColor(.secondary)
                            
                            RatingView(rating: getSpeedRating(), maxRating: 5, color: methodColor)
                        }
                        .frame(maxWidth: .infinity)
                        
                        // Risk
                        VStack(spacing: 8) {
                            Text(NSLocalizedString("Risk", comment: "Risk rating label"))
                                .font(.system(size: 14, design: .rounded))
                                .foregroundColor(.secondary)
                            
                            RatingView(rating: getRiskRating(), maxRating: 5, color: .red)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .padding(20)
                .background(colorScheme == .dark ? Color(.systemGray6) : Color(.systemGray6))
                .cornerRadius(16)
                .padding(.horizontal, 20)
                
                // Note about clinical evidence
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Image(systemName: "info.circle.fill")
                            .foregroundColor(.blue)
                        
                        Text(NSLocalizedString("Clinical note", comment: "Clinical note section title"))
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                            .foregroundColor(.blue)
                    }
                    
                    Text(NSLocalizedString("The choice of method should be based on clinical judgment, considering the individual characteristics of each patient and the results of the Bishop Test.", comment: "Clinical note description"))
                        .font(.system(size: 14, design: .rounded))
                        .foregroundColor(.secondary)
                }
                .padding(16)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(12)
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
        }
        .navigationBarTitle("", displayMode: .inline)
        .background(BishopDesign.Colors.background.edgesIgnoringSafeArea(.all))
    }
    
    // Ratings based on method type
    private func getEffectivenessRating() -> Int {
        if InductionMethod.oxytocin.contains(where: { $0.id == method.id }) {
            return 4
        } else if method.name.contains("Misoprostol") {
            return 5
        } else if method.name.contains("Dinoprostona") {
            return 4
        } else {
            return 3
        }
    }
    
    private func getSpeedRating() -> Int {
        if InductionMethod.oxytocin.contains(where: { $0.id == method.id }) {
            return 5
        } else if method.name.contains("Misoprostol") {
            return 3
        } else if method.name.contains("Dinoprostona") {
            return 3
        } else {
            return 2
        }
    }
    
    private func getRiskRating() -> Int {
        if InductionMethod.oxytocin.contains(where: { $0.id == method.id }) {
            return 3
        } else if method.name.contains("Misoprostol") {
            return 4
        } else if method.name.contains("Dinoprostona") {
            return 3
        } else {
            return 2
        }
    }
}

// Card for each section (Indications, Contraindications, Risks)
struct SectionCard: View {
    let title: String
    let items: [String]
    let iconName: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.system(size: 20, weight: .semibold, design: .rounded))
            
            ForEach(items, id: \.self) { item in
                HStack(alignment: .top, spacing: 12) {
                    Image(systemName: iconName)
                        .font(.system(size: 16))
                        .foregroundColor(color)
                        .frame(width: 20, height: 20)
                    
                    Text(item)
                        .font(.system(size: 16, design: .rounded))
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.vertical, 4)
            }
        }
        .padding(20)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

// Rating view with stars
struct RatingView: View {
    let rating: Int
    let maxRating: Int
    let color: Color
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(1...maxRating, id: \.self) { index in
                Image(systemName: index <= rating ? "circle.fill" : "circle")
                    .foregroundColor(index <= rating ? color : .gray.opacity(0.3))
                    .font(.system(size: 10))
            }
        }
    }
}
