// SpecialtyPickerView.swift
import SwiftUI

struct SpecialtyPickerView: View {
    @Binding var selectedSpecialty: String
    @State private var searchText = ""
    @Environment(\.presentationMode) var presentationMode
    
    var filteredCategories: [SpecialtyCategory] {
        if searchText.isEmpty {
            return MedicalSpecialties.categories
        } else {
            // Filter specialties that match the search query
            return MedicalSpecialties.categories.compactMap { category in
                let filteredSpecialties = category.specialties.filter { $0.localizedCaseInsensitiveContains(searchText) }
                if filteredSpecialties.isEmpty {
                    return nil
                }
                return SpecialtyCategory(name: category.name, specialties: filteredSpecialties)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(filteredCategories) { category in
                    Section(header: Text(category.name)) {
                        ForEach(category.specialties, id: \.self) { specialty in
                            Button(action: {
                                selectedSpecialty = specialty
                                presentationMode.wrappedValue.dismiss()
                            }) {
                                HStack {
                                    Text(specialty)
                                    Spacer()
                                    if specialty == selectedSpecialty {
                                        Image(systemName: "checkmark")
                                            .foregroundColor(.blue)
                                    }
                                }
                            }
                            .foregroundColor(.primary)
                        }
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .searchable(text: $searchText, prompt: "Search specialty")
            .navigationBarTitle("Specialty", displayMode: .inline)
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}
