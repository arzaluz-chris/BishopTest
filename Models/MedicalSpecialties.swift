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
            name: "Formación",
            specialties: [
                "Médico interno de Pregrado",
                "Médico Pasante del Servicio Social",
                "Médico Residente",
                "Médico General"
            ]
        ),
        SpecialtyCategory(
            name: "Especialidades Médicas Básicas",
            specialties: [
                "Medicina Interna",
                "Cirugía General",
                "Pediatría",
                "Ginecología y Obstetricia",
                "Anestesiología"
            ]
        ),
        SpecialtyCategory(
            name: "Subespecialidades de Medicina Interna",
            specialties: [
                "Cardiología",
                "Neumología",
                "Gastroenterología",
                "Endocrinología",
                "Hematología",
                "Nefrología",
                "Reumatología",
                "Infectología",
                "Geriatría",
                "Oncología médica"
            ]
        ),
        SpecialtyCategory(
            name: "Subespecialidades de Cirugía General",
            specialties: [
                "Cirugía Oncológica",
                "Cirugía Laparoscópica avanzada",
                "Cirugía Hepatobiliar",
                "Cirugía de Colon y Recto",
                "Cirugía de Tórax",
                "Cirugía Cardiovascular",
                "Cirugía Vascular periférica",
                "Cirugía de Trasplantes"
            ]
        ),
        SpecialtyCategory(
            name: "Otras especialidades quirúrgicas",
            specialties: [
                "Ortopedia y Traumatología",
                "Neurocirugía",
                "Cirugía Plástica y Reconstructiva",
                "Cirugía Maxilofacial",
                "Otorrinolaringología",
                "Urología",
                "Oftalmología"
            ]
        ),
        SpecialtyCategory(
            name: "Especialidades diagnósticas y de apoyo",
            specialties: [
                "Radiología e Imagen",
                "Medicina Nuclear",
                "Patología Anatómica",
                "Patología Clínica / Laboratorio clínico",
                "Medicina de Rehabilitación",
                "Genética médica"
            ]
        ),
        SpecialtyCategory(
            name: "Especialidades de urgencias y cuidados críticos",
            specialties: [
                "Medicina de Urgencias",
                "Terapia Intensiva / Medicina Crítica",
                "Cuidados Paliativos",
                "Toxicología clínica"
            ]
        ),
        SpecialtyCategory(
            name: "Especialidades psiquiátricas y del comportamiento",
            specialties: [
                "Psiquiatría",
                "Psicología clínica",
                "Neurología",
                "Neuropsiquiatría"
            ]
        ),
        SpecialtyCategory(
            name: "Especialidades pediátricas",
            specialties: [
                "Neonatología",
                "Pediatría Intensiva",
                "Cardiología pediátrica",
                "Cirugía pediátrica",
                "Nefrología pediátrica",
                "Neuropediatría"
            ]
        ),
        SpecialtyCategory(
            name: "Otras especialidades",
            specialties: [
                "Medicina del Dolor",
                "Medicina del Deporte",
                "Medicina del Trabajo / Medicina Laboral",
                "Medicina Familiar y Comunitaria",
                "Medicina Legal y Forense",
                "Epidemiología clínica",
                "Salud Pública / Medicina Preventiva",
                "Alergología e Inmunología clínica"
            ]
        )
    ]
    
    // Lista plana de todas las especialidades para búsqueda
    static var allSpecialties: [String] {
        categories.flatMap { $0.specialties }
    }
}
