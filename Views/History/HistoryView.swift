// HistoryView.swift
import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var dataStore: DataStore
    @State private var showingDeleteAlert = false
    @State private var scoreToDelete: BishopScore?
    @State private var searchText = ""
    @State private var selectedFilter: ScoreFilter = .all
    
    // Available filters for evaluations
    enum ScoreFilter: String, CaseIterable, Identifiable {
        case all = "All"
        case favorable = "Favorable"
        case moderate = "Moderate"
        case unfavorable = "Unfavorable"
        
        var id: String { self.rawValue }
        
        // Localized display name
        var localizedName: String {
            switch self {
            case .all: return NSLocalizedString("All", comment: "Filter for all evaluations")
            case .favorable: return NSLocalizedString("Favorable", comment: "Filter for favorable evaluations")
            case .moderate: return NSLocalizedString("Moderate", comment: "Filter for moderately favorable evaluations")
            case .unfavorable: return NSLocalizedString("Unfavorable", comment: "Filter for unfavorable evaluations")
            }
        }
    }
    
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
                                    Text(filter.localizedName)
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
                                NSLocalizedString("No saved evaluations", comment: "Message when no evaluations exist") :
                                NSLocalizedString("No evaluations found", comment: "Message when no evaluations match filter"))
                                .font(.system(size: 18, weight: .medium, design: .rounded))
                                .foregroundColor(.secondary)
                            
                            if searchText.isEmpty && selectedFilter == .all {
                                Text(NSLocalizedString("Your saved evaluations will appear here", comment: "Hint for empty evaluations list"))
                                    .font(.system(size: 15, design: .rounded))
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 40)
                                
                                NavigationLink(destination: BishopScoreView()) {
                                    HStack {
                                        Image(systemName: "plus.circle")
                                        Text(NSLocalizedString("New Evaluation", comment: "Button to start new evaluation"))
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
                        // List with swipe actions
                        List {
                            ForEach(filteredScores) { score in
                                NavigationLink(destination: ResultView(bishopScore: score, dataStore: dataStore, isPresented: .constant(false))) {
                                    RecentScoreCard(score: score)
                                        .padding(.vertical, 5)
                                }
                                .listRowInsets(EdgeInsets())
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                    Button(role: .destructive) {
                                        scoreToDelete = score
                                        showingDeleteAlert = true
                                    } label: {
                                        Label(NSLocalizedString("Delete", comment: "Delete action button"), systemImage: "trash")
                                    }
                                }
                            }
                        }
                        .listStyle(PlainListStyle())
                    }
                }
            }
            .navigationBarTitle(NSLocalizedString("History", comment: "Navigation bar title"), displayMode: .inline)
            .searchable(text: $searchText, prompt: NSLocalizedString("Search patient", comment: "Search bar placeholder"))
            .alert(isPresented: $showingDeleteAlert) {
                Alert(
                    title: Text(NSLocalizedString("Delete Evaluation", comment: "Delete alert title")),
                    message: Text(NSLocalizedString("Are you sure you want to delete this evaluation?", comment: "Delete alert message")),
                    primaryButton: .destructive(Text(NSLocalizedString("Delete", comment: "Confirm delete button"))) {
                        if let score = scoreToDelete,
                           let index = dataStore.savedScores.firstIndex(where: { $0.id == score.id }) {
                            dataStore.deleteScore(at: IndexSet([index]))
                        }
                    },
                    secondaryButton: .cancel(Text(NSLocalizedString("Cancel", comment: "Cancel button")))
                )
            }
        }
    }
}
