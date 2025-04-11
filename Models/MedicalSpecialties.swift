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
            name: "Medical Level",
            specialties: [
                "Student",
                "Undergraduate Medical Intern",
                "Social Service Medical Intern",
                "Nurse",
                "General Practitioner",
                "Resident Physician",
                "Specialist"
            ]
        )
    ]
    
    // Flat list of all specialties for search
    static var allSpecialties: [String] {
        categories.flatMap { $0.specialties }
    }
}
