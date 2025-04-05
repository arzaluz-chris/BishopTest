//  HistoryView.swift
import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var dataStore: DataStore
    @State private var showingDeleteAlert = false
    @State private var indexSetToDelete: IndexSet?
    
    var body: some View {
        NavigationView {
            List {
                if dataStore.savedScores.isEmpty {
                    Text("No hay evaluaciones guardadas")
                        .foregroundColor(.secondary)
                        .padding()
                } else {
                    ForEach(dataStore.savedScores.sorted(by: { $0.date > $1.date })) { score in
                        NavigationLink(destination: ResultView(bishopScore: score, dataStore: dataStore, isPresented: .constant(false))) {
                            HStack {
                                ZStack {
                                    Circle()
                                        .fill(getColor(for: score.interpretation).opacity(0.2))
                                        .frame(width: 40, height: 40)
                                    
                                    Text("\(score.totalScore)")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(getColor(for: score.interpretation))
                                }
                                
                                VStack(alignment: .leading) {
                                    Text(score.patientName ?? "Paciente sin nombre")
                                        .font(.headline)
                                    
                                    Text(dateFormatter.string(from: score.date))
                                        .font(.subheadline)
                                        .foregroundColor(Color("AppSecondary"))
                                }
                                .padding(.leading, 8)
                                
                                Spacer()
                                
                                Text(score.interpretation.rawValue)
                                    .font(.caption)
                                    .padding(6)
                                    .background(getColor(for: score.interpretation).opacity(0.1))
                                    .foregroundColor(getColor(for: score.interpretation))
                                    .cornerRadius(5)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    .onDelete { indexSet in
                        indexSetToDelete = indexSet
                        showingDeleteAlert = true
                    }
                }
            }
            .navigationBarTitle("Historial", displayMode: .inline)
            .alert(isPresented: $showingDeleteAlert) {
                Alert(
                    title: Text("Eliminar evaluación"),
                    message: Text("¿Estás seguro de que deseas eliminar esta evaluación?"),
                    primaryButton: .destructive(Text("Eliminar")) {
                        if let indexSet = indexSetToDelete {
                            dataStore.deleteScore(at: indexSet)
                        }
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }
    
    func getColor(for interpretation: ScoreInterpretation) -> Color {
        switch interpretation {
        case .favorable:
            return Color("FavorableGreen")
        case .moderatelyFavorable:
            return Color("ModerateOrange")
        case .unfavorable:
            return Color("UnfavorableRed")
        }
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
}
