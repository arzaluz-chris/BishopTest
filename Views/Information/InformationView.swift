//  InformationView.swift
import SwiftUI

struct InformationView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                infoSection(
                    title: "Test de Bishop",
                    content: "El test de Bishop es un sistema de puntuación que valora el cuello uterino en el trabajo de parto y ayuda a predecir si será requerida inducción del parto. Fue desarrollado por el Dr. Edward Bishop y publicado en 1964.",
                    color: .blue
                )
                
                infoSection(
                    title: "Parámetros evaluados",
                    content: "• Dilatación cervical\n• Borramiento cervical\n• Consistencia cervical\n• Posición cervical\n• Altura de la presentación",
                    color: .green
                )
                
                infoSection(
                    title: "Interpretación de resultados",
                    content: "• Puntuación ≤ 6: Cérvix desfavorable, se recomienda maduración cervical\n• Puntuación > 6: Cérvix favorable en multíparas\n• Puntuación > 8: Cérvix favorable en nulíparas, probabilidad de éxito similar al parto espontáneo",
                    color: .orange
                )
                
                infoSection(
                    title: "Modificadores del score",
                    content: "Sumar 1 punto por:\n• Preeclampsia\n• Cada parto vaginal previo\n\nRestar 1 punto por:\n• Embarazo postérmino\n• Nuliparidad\n• Rotura prematura de membranas",
                    color: .purple
                )
                
                infoSection(
                    title: "Indicaciones para inducción",
                    content: "• Gestación cronológicamente prolongada (>41.0 semanas)\n• Patologías maternas (Preeclampsia, Diabetes)\n• Indicaciones fetales (CIR, muerte fetal intrauterina)\n• Causas obstétricas (EVP, RPM)",
                    color: .red
                )
            }
            .padding()
        }
        .navigationBarTitle("Información", displayMode: .inline)
    }
    
    func infoSection(title: String, content: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.headline)
                .foregroundColor(color)
            
            Text(content)
                .font(.body)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(color.opacity(0.1))
        .cornerRadius(10)
    }
}
