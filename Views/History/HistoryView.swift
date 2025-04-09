// HistoryView.swift
import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var dataStore: DataStore
    @State private var showingDeleteAlert = false
    @State private var indexSetToDelete: IndexSet?
    @State private var searchText = ""
    @State private var showFilterSheet = false
    @State private var selectedFilter: ScoreFilter = .all
    
    // Available filters for evaluations
    enum ScoreFilter: String, CaseIterable, Identifiable {
        case all = "All"
        case favorable = "Favorable"
        case moderate = "Moderate"
        case unfavorable = "Unfavorable"
        
        var id: String { self.rawValue }
    }
    
    // Formatter to display dates
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
    
    // Filtered and sorted list of evaluations
    private var filteredScores: [BishopScore] {
        let sorted = dataStore.savedScores.sorted(by: { $0.date > $1.date })
        
        // Filter by search text
        let textFiltered = searchText.isEmpty ? sorted : sorted.filter {
            ($0.patientName ?? "").localizedCaseInsensitiveContains(searchText)
        }
        
        // Filter by category
        switch selectedFilter {
        case .all:
            return textFiltered
        case .favorable:
            return textFiltered.filter { $0.interpretation == .favorable }
        case .moderate:
            return textFiltered.filter { $0.interpretation == .moderatelyFavorable }
        case .unfavorable:
            return textFiltered.filter { $0.interpretation == .unfavorable }
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                BishopDesign.Colors.background.edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 0) {
                    // Filter buttons
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(ScoreFilter.allCases) { filter in
                                Button(action: {
                                    selectedFilter = filter
                                }) {
                                    Text(filter.rawValue)
                                        .font(.system(size: 14, weight: selectedFilter == filter ? .semibold : .medium, design: .rounded))
                                        .padding(.horizontal, 14)
                                        .padding(.vertical, 8)
                                        .background(selectedFilter == filter ? BishopDesign.Colors.primary : Color(.systemGray6))
                                        .foregroundColor(selectedFilter == filter ? .white : .primary)
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
                    
                    if filteredScores.isEmpty {
                        // Empty view
                        VStack(spacing: 20) {
                            Spacer()
                            
                            Image(systemName: "doc.text.magnifyingglass")
                                .font(.system(size: 60))
                                .foregroundColor(.gray.opacity(0.5))
                            
                            Text(searchText.isEmpty && selectedFilter == .all ?
                                "No saved evaluations" :
                                "No evaluations found")
                                .font(.system(size: 18, weight: .medium, design: .rounded))
                                .foregroundColor(.secondary)
                            
                            if searchText.isEmpty && selectedFilter == .all {
                                Text("Your saved evaluations will appear here")
                                    .font(.system(size: 15, design: .rounded))
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 40)
                                
                                NavigationLink(destination: BishopScoreView()) {
                                    HStack {
                                        Image(systemName: "plus.circle")
                                        Text("New Evaluation")
                                    }
                                    .font(.system(size: 16, weight: .medium, design: .rounded))
                                    .foregroundColor(BishopDesign.Colors.primary)
                                    .padding(.top, 8)
                                }
                            }
                            
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                    } else {
                        // List of evaluations
                        ScrollView {
                            LazyVStack(spacing: 16) {
                                ForEach(filteredScores) { score in
                                    HistoryScoreCard(score: score)
                                        .contextMenu {
                                            Button(role: .destructive, action: {
                                                if let index = dataStore.savedScores.firstIndex(where: { $0.id == score.id }) {
                                                    indexSetToDelete = IndexSet([index])
                                                    showingDeleteAlert = true
                                                }
                                            }) {
                                                Label("Delete", systemImage: "trash")
                                            }
                                        }
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 16)
                        }
                    }
                }
            }
            .navigationBarTitle("History", displayMode: .inline)
            .searchable(text: $searchText, prompt: "Search patient")
            .alert(isPresented: $showingDeleteAlert) {
                Alert(
                    title: Text("Delete Evaluation"),
                    message: Text("Are you sure you want to delete this evaluation?"),
                    primaryButton: .destructive(Text("Delete")) {
                        if let indexSet = indexSetToDelete {
                            dataStore.deleteScore(at: indexSet)
                        }
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }
}

// Card for each evaluation in the history
struct HistoryScoreCard: View {
    let score: BishopScore
    @EnvironmentObject var dataStore: DataStore
    
    // Formatter to display the date
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    // Formatter to display the time
    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
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
        NavigationLink(destination: ResultView(bishopScore: score, dataStore: dataStore, isPresented: .constant(false))) {
            HStack(spacing: 16) {
                // Badge with score
                ZStack {
                    Circle()
                        .fill(scoreColor.opacity(0.15))
                        .frame(width: 56, height: 56)
                    
                    Circle()
                        .stroke(scoreColor, lineWidth: 2)
                        .frame(width: 56, height: 56)
                    
                    Text("\(score.totalScore)")
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundColor(scoreColor)
                }
                
                // Patient information and date
                VStack(alignment: .leading, spacing: 4) {
                    if let name = score.patientName, !name.isEmpty {
                        Text(name)
                            .font(.system(size: 17, weight: .semibold, design: .rounded))
                            .lineLimit(1)
                    } else {
                        Text("Unnamed patient")
                            .font(.system(size: 17, weight: .semibold, design: .rounded))
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                    }
                    
                    HStack(spacing: 8) {
                        // Date
                        Label(dateFormatter.string(from: score.date), systemImage: "calendar")
                            .font(.system(size: 14, design: .rounded))
                            .foregroundColor(.secondary)
                        
                        // Small separator
                        Text("•")
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                        
                        // Time
                        Text(timeFormatter.string(from: score.date))
                            .font(.system(size: 14, design: .rounded))
                            .foregroundColor(.secondary)
                    }
                    
                    // Additional information
                    if let age = score.patientAge {
                        Text("\(age) years • \(score.nulliparous ? "Nulliparous" : "Multiparous")")
                            .font(.system(size: 14, design: .rounded))
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                // Interpretation label with distinctive style
                VStack(alignment: .trailing, spacing: 4) {
                    // Type label
                    getInterpretationBadge()
                    
                    // Arrow to indicate navigation
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                        .padding(.trailing, 4)
                }
            }
            .padding(16)
            .background(Color(.systemBackground))
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        }
    }
    
    // Badge to show the type of interpretation
    @ViewBuilder
    private func getInterpretationBadge() -> some View {
        switch score.interpretation {
        case .favorable:
            HStack(spacing: 4) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 12))
                Text("Favorable")
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(BishopDesign.Colors.favorable.opacity(0.15))
            .foregroundColor(BishopDesign.Colors.favorable)
            .cornerRadius(12)
            
        case .moderatelyFavorable:
            HStack(spacing: 4) {
                Image(systemName: "arrow.up.right.circle.fill")
                    .font(.system(size: 12))
                Text("Moderate")
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(BishopDesign.Colors.moderate.opacity(0.15))
            .foregroundColor(BishopDesign.Colors.moderate)
            .cornerRadius(12)
            
        case .unfavorable:
            HStack(spacing: 4) {
                Image(systemName: "exclamationmark.circle.fill")
                    .font(.system(size: 12))
                Text("Unfavorable")
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(BishopDesign.Colors.unfavorable.opacity(0.15))
            .foregroundColor(BishopDesign.Colors.unfavorable)
            .cornerRadius(12)
        }
    }
}
