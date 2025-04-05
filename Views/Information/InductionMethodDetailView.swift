//  InductionMethodDetailView.swift
import SwiftUI

struct InductionMethodDetailView: View {
    let method: InductionMethod
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(method.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 8)
                
                detailSection(title: "Descripción", items: [method.description])
                
                detailSection(title: "Indicaciones", items: method.indications)
                
                detailSection(title: "Contraindicaciones", items: method.contraindications)
                
                detailSection(title: "Riesgos", items: method.risks)
            }
            .padding()
        }
        .navigationBarTitle(method.name, displayMode: .inline)
    }
    
    func detailSection(title: String, items: [String]) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundColor(Color("AccentColor"))
            
            ForEach(items, id: \.self) { item in
                HStack(alignment: .top) {
                    Image(systemName: "circle.fill")
                        .font(.system(size: 8))
                        .foregroundColor(.blue)
                        .padding(.top, 6)
                    
                    Text(item)
                        .font(.body)
                }
                .padding(.vertical, 2)
            }
        }
        .padding()
        .background(Color.blue.opacity(0.05))
        .cornerRadius(10)
    }
}
