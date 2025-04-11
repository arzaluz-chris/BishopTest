// SpecialtyPickerView.swift
import SwiftUI

struct SpecialtyPickerView: View {
    @Binding var selectedSpecialty: String
    @State private var searchText = ""
    @Environment(\.presentationMode) var presentationMode
    
    var filteredSpecialties: [String] {
        if searchText.isEmpty {
            // Return all specialties when no search text
            return MedicalSpecialties.allSpecialties
        } else {
            // Filter specialties that match the search query
            return MedicalSpecialties.allSpecialties.filter {
                $0.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.secondary)
                    
                    TextField(NSLocalizedString("Search specialty", comment: "Placeholder for specialty search"), text: $searchText)
                        .font(.system(size: 16, design: .rounded))
                }
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal, 16)
                .padding(.bottom, 12)
                .padding(.top, 8)
                
                // List of specialties
                List {
                    // Empty text view to create spacing
                    Text("")
                        .listRowBackground(Color.clear)
                        .listRowInsets(EdgeInsets())
                        .frame(height: 8)
                        .hidden()
                    
                    ForEach(filteredSpecialties, id: \.self) { specialty in
                        Button(action: {
                            selectedSpecialty = specialty
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            HStack {
                                Text(specialty)
                                    .font(.system(size: 17, design: .rounded))
                                
                                Spacer()
                                
                                if specialty == selectedSpecialty {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(BishopDesign.Colors.primary)
                                }
                            }
                        }
                        .foregroundColor(.primary)
                        .padding(.vertical, 4)
                    }
                }
                .listStyle(InsetGroupedListStyle())
            }
            .navigationBarTitle(NSLocalizedString("Specialty", comment: "Navigation bar title for specialty selection"), displayMode: .inline)
            .navigationBarItems(trailing: Button(NSLocalizedString("Cancel", comment: "Cancel button")) {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}
