//  InductionMethodsView.swift
import SwiftUI

struct InductionMethodsView: View {
    let allMethods = InductionMethod.oxytocin + InductionMethod.prostaglandins + InductionMethod.mechanical
    @State private var searchText = ""
    
    var filteredMethods: [InductionMethod] {
        if searchText.isEmpty {
            return allMethods
        } else {
            return allMethods.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(filteredMethods) { method in
                    NavigationLink(destination: InductionMethodDetailView(method: method)) {
                        Text(method.name)
                    }
                }
            }
            .navigationBarTitle("Métodos de Inducción", displayMode: .inline)
            .searchable(text: $searchText, prompt: "Buscar método")
        }
    }
}
