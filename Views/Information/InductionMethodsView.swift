// InductionMethodsView.swift
import SwiftUI

struct InductionMethodsView: View {
    let allMethods = InductionMethod.oxytocin + InductionMethod.prostaglandins + InductionMethod.mechanical
    @State private var searchText = ""
    @State private var selectedCategory: MethodCategory = .all
    
    // Categories of induction methods
    enum MethodCategory: String, CaseIterable, Identifiable {
        case all = "All"
        case oxytocin = "Oxytocin"
        case prostaglandins = "Prostaglandins"
        case mechanical = "Mechanical"
        
        var id: String { self.rawValue }
    }
    
    // Methods filtered by category and search
    var filteredMethods: [InductionMethod] {
        var methodsToDisplay: [InductionMethod]
        
        // Filter by category
        switch selectedCategory {
        case .all:
            methodsToDisplay = allMethods
        case .oxytocin:
            methodsToDisplay = InductionMethod.oxytocin
        case .prostaglandins:
            methodsToDisplay = InductionMethod.prostaglandins
        case .mechanical:
            methodsToDisplay = InductionMethod.mechanical
        }
        
        // Filter by search text
        if searchText.isEmpty {
            return methodsToDisplay
        } else {
            return methodsToDisplay.filter {
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.description.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                BishopDesign.Colors.background.edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 0) {
                    // Filters by category
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(MethodCategory.allCases) { category in
                                Button(action: {
                                    selectedCategory = category
                                }) {
                                    Text(category.rawValue)
                                        .font(.system(size: 14, weight: selectedCategory == category ? .semibold : .medium, design: .rounded))
                                        .padding(.horizontal, 14)
                                        .padding(.vertical, 8)
                                        .background(selectedCategory == category ? BishopDesign.Colors.primary : Color(.systemGray6))
                                        .foregroundColor(selectedCategory == category ? .white : .primary)
                                        .cornerRadius(15)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                    }
                    
                    // Divider
                    Rectangle()
                        .fill(Color(.systemGray5))
                        .frame(height: 1)
                    
                    if filteredMethods.isEmpty {
                        // View for when no results are found
                        VStack(spacing: 20) {
                            Spacer()
                            
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 60))
                                .foregroundColor(.gray.opacity(0.5))
                            
                            Text("No methods found")
                                .font(.system(size: 18, weight: .medium, design: .rounded))
                                .foregroundColor(.secondary)
                            
                            Text("Try another search or category")
                                .font(.system(size: 15, design: .rounded))
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 40)
                            
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                    } else {
                        // List of induction methods
                        ScrollView {
                            LazyVStack(spacing: 16) {
                                ForEach(filteredMethods) { method in
                                    NavigationLink(destination: InductionMethodDetailView(method: method)) {
                                        MethodCard(method: method)
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 16)
                        }
                    }
                }
            }
            .navigationBarTitle("Induction Methods", displayMode: .inline)
            .searchable(text: $searchText, prompt: "Search method")
        }
    }
}

// Card for each induction method
struct MethodCard: View {
    let method: InductionMethod
    
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
    
    var body: some View {
        HStack(spacing: 16) {
            // Method icon
            ZStack {
                Circle()
                    .fill(methodColor.opacity(0.15))
                    .frame(width: 56, height: 56)
                
                Image(systemName: methodIcon)
                    .font(.system(size: 24))
                    .foregroundColor(methodColor)
            }
            
            // Method information
            VStack(alignment: .leading, spacing: 6) {
                Text(method.name)
                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                
                Text(method.description)
                    .font(.system(size: 14, design: .rounded))
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            
            Spacer()
            
            // Arrow to indicate navigation
            Image(systemName: "chevron.right")
                .font(.system(size: 14))
                .foregroundColor(.secondary)
        }
        .padding(16)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}
