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
            name: "Training",
            specialties: [
                "Undergraduate Medical Intern",
                "Social Service Medical Intern",
                "Resident Physician",
                "General Practitioner"
            ]
        ),
        SpecialtyCategory(
            name: "Basic Medical Specialties",
            specialties: [
                "Internal Medicine",
                "General Surgery",
                "Pediatrics",
                "Gynecology and Obstetrics",
                "Anesthesiology"
            ]
        ),
        SpecialtyCategory(
            name: "Internal Medicine Subspecialties",
            specialties: [
                "Cardiology",
                "Pulmonology",
                "Gastroenterology",
                "Endocrinology",
                "Hematology",
                "Nephrology",
                "Rheumatology",
                "Infectious Diseases",
                "Geriatrics",
                "Medical Oncology"
            ]
        ),
        SpecialtyCategory(
            name: "General Surgery Subspecialties",
            specialties: [
                "Oncologic Surgery",
                "Advanced Laparoscopic Surgery",
                "Hepatobiliary Surgery",
                "Colon and Rectal Surgery",
                "Thoracic Surgery",
                "Cardiovascular Surgery",
                "Peripheral Vascular Surgery",
                "Transplant Surgery"
            ]
        ),
        SpecialtyCategory(
            name: "Other Surgical Specialties",
            specialties: [
                "Orthopedics and Traumatology",
                "Neurosurgery",
                "Plastic and Reconstructive Surgery",
                "Maxillofacial Surgery",
                "Otorhinolaryngology",
                "Urology",
                "Ophthalmology"
            ]
        ),
        SpecialtyCategory(
            name: "Diagnostic and Support Specialties",
            specialties: [
                "Radiology and Imaging",
                "Nuclear Medicine",
                "Anatomical Pathology",
                "Clinical Pathology / Clinical Laboratory",
                "Rehabilitation Medicine",
                "Medical Genetics"
            ]
        ),
        SpecialtyCategory(
            name: "Emergency and Critical Care Specialties",
            specialties: [
                "Emergency Medicine",
                "Intensive Care / Critical Care Medicine",
                "Palliative Care",
                "Clinical Toxicology"
            ]
        ),
        SpecialtyCategory(
            name: "Psychiatric and Behavioral Specialties",
            specialties: [
                "Psychiatry",
                "Clinical Psychology",
                "Neurology",
                "Neuropsychiatry"
            ]
        ),
        SpecialtyCategory(
            name: "Pediatric Specialties",
            specialties: [
                "Neonatology",
                "Pediatric Intensive Care",
                "Pediatric Cardiology",
                "Pediatric Surgery",
                "Pediatric Nephrology",
                "Pediatric Neurology"
            ]
        ),
        SpecialtyCategory(
            name: "Other Specialties",
            specialties: [
                "Pain Medicine",
                "Sports Medicine",
                "Occupational Medicine / Labor Medicine",
                "Family and Community Medicine",
                "Legal and Forensic Medicine",
                "Clinical Epidemiology",
                "Public Health / Preventive Medicine",
                "Allergology and Clinical Immunology"
            ]
        )
    ]
    
    // Flat list of all specialties for search
    static var allSpecialties: [String] {
        categories.flatMap { $0.specialties }
    }
}
