import SwiftUI

struct BishopScoreView: View {
    @EnvironmentObject var dataStore: DataStore
    @State private var bishopScore = BishopScore()
    @State private var showingResult = false
    @AppStorage("useModifiers") private var useModifiers = true
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Información del paciente")) {
                    TextField("Nombre (opcional)", text: Binding(
                        get: { bishopScore.patientName ?? "" },
                        set: { bishopScore.patientName = $0.isEmpty ? nil : $0 }
                    ))
                    
                    HStack {
                        Text("Edad:")
                        Spacer()
                        
                        // Picker con números del 14 al 60
                        Picker("", selection: Binding(
                            get: { bishopScore.patientAge ?? 25 },
                            set: { bishopScore.patientAge = $0 }
                        )) {
                            ForEach(14...60, id: \.self) { age in
                                Text("\(age) años").tag(age)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(width: 150, height: 80)
                        .clipped()
                    }
                    
                    Stepper(value: Binding(
                        get: { bishopScore.previousDeliveries },
                        set: {
                            bishopScore.previousDeliveries = $0
                            bishopScore.nulliparous = $0 == 0
                        }
                    ), in: 0...10) {
                        Text("Partos previos: \(bishopScore.previousDeliveries)")
                    }
                }
                
                Section(header: Text("Dilatación")) {
                    Picker("Seleccione", selection: $bishopScore.dilation) {
                        ForEach(Dilation.allCases) { dilation in
                            Text(dilation.description).tag(dilation)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("Borramiento")) {
                    Picker("Seleccione", selection: $bishopScore.effacement) {
                        ForEach(Effacement.allCases) { effacement in
                            Text(effacement.description).tag(effacement)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("Consistencia")) {
                    Picker("Seleccione", selection: $bishopScore.consistency) {
                        ForEach(Consistency.allCases) { consistency in
                            Text(consistency.description).tag(consistency)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("Posición")) {
                    Picker("Seleccione", selection: $bishopScore.position) {
                        ForEach(Position.allCases) { position in
                            Text(position.description).tag(position)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("Altura (Plano)")) {
                    Picker("Seleccione", selection: $bishopScore.station) {
                        ForEach(Station.allCases) { station in
                            Text(station.description).tag(station)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                // Modificadores condicionales
                if useModifiers {
                    Section(header: Text("Modificadores")) {
                        Toggle("Preeclampsia", isOn: $bishopScore.preeclampsia)
                        Toggle("Embarazo postérmino", isOn: $bishopScore.postdatePregnancy)
                        Toggle("Ruptura prematura de membranas", isOn: $bishopScore.prematureRupture)
                    }
                }
                
                Section {
                    Button(action: {
                        showingResult = true
                    }) {
                        Text("Calcular Puntuación")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color("AppPrimary"))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
            }
            .navigationBarTitle("Test de Bishop", displayMode: .inline)
            .sheet(isPresented: $showingResult) {
                ResultView(bishopScore: getScoreWithModifiers(), dataStore: dataStore, isPresented: $showingResult)
            }
        }
    }
    
    // Función para aplicar modificadores según la configuración
    private func getScoreWithModifiers() -> BishopScore {
        var score = bishopScore
        
        // Si los modificadores están desactivados, resetearlos
        if !useModifiers {
            score.preeclampsia = false
            score.postdatePregnancy = false
            score.prematureRupture = false
        }
        
        return score
    }
}
