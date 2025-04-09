//  DataStore.swift
import Foundation
import Combine

class DataStore: ObservableObject {
    @Published var savedScores: [BishopScore] = []
    
    private let savePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("BishopScores.json")
    
    init() {
        loadScores()
    }
    
    func saveScore(_ score: BishopScore) {
        savedScores.append(score)
        saveScores()
    }
    
    func deleteScore(at indexSet: IndexSet) {
        savedScores.remove(atOffsets: indexSet)
        saveScores()
    }
    
    private func saveScores() {
        do {
            let data = try JSONEncoder().encode(savedScores)
            try data.write(to: savePath)
        } catch {
            print("Error saving scores: \(error.localizedDescription)")
        }
    }
    
    private func loadScores() {
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: savePath.path) {
            do {
                let data = try Data(contentsOf: savePath)
                savedScores = try JSONDecoder().decode([BishopScore].self, from: data)
            } catch {
                print("Error decoding saved scores: \(error.localizedDescription)")
                savedScores = []
            }
        } else {
            print("No previously saved scores found.")
            savedScores = []
        }
    }
}
