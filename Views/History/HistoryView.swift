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
                        // List with swipe actions - using native SwiftUI functionality
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
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                            }
                        }
                        .listStyle(PlainListStyle())
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
                        if let score = scoreToDelete,
                           let index = dataStore.savedScores.firstIndex(where: { $0.id == score.id }) {
                            dataStore.deleteScore(at: IndexSet([index]))
                        }
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }
}
