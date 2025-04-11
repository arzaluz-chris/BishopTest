// MedicalSpecialties.swift
import Foundation

struct SpecialtyCategory: Identifiable {
    var id = UUID()
    var name: String
    var specialties: [String]
}

struct MedicalSpecialties {
    static let categories = [
        SpecialtyCategory(
            name: NSLocalizedString("Medical Level", comment: "Category name for medical levels"),
            specialties: [
                NSLocalizedString("Student", comment: "Medical level"),
                NSLocalizedString("Undergraduate Medical Intern", comment: "Medical level"),
                NSLocalizedString("Social Service Medical Intern", comment: "Medical level"),
                NSLocalizedString("Nurse", comment: "Medical level"),
                NSLocalizedString("General Practitioner", comment: "Medical level"),
                NSLocalizedString("Resident Physician", comment: "Medical level"),
                NSLocalizedString("Specialist", comment: "Medical level")
            ]
        )
    ]
    
    // Flat list of all specialties for search
    static var allSpecialties: [String] {
        categories.flatMap { $0.specialties }
    }
}
