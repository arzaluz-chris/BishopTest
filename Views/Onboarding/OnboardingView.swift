import SwiftUI

struct OnboardingView: View {
    @Binding var showOnboarding: Bool
    @AppStorage("userName") private var name = ""
    @AppStorage("userSpecialty") private var specialty = ""
    @State private var showingSpecialtyPicker = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                Spacer()
                
                Image("bishop_score_icon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                
                Text("Bienvenido a BishopTest")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                
                Text("Por favor, dinos quién eres para personalizar tu experiencia")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                VStack(spacing: 20) {
                    TextField("Tu nombre", text: $name)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .padding(.horizontal)
                    
                    Button(action: {
                        showingSpecialtyPicker = true
                    }) {
                        HStack {
                            Text(specialty.isEmpty ? "Selecciona tu especialidad" : specialty)
                                .foregroundColor(specialty.isEmpty ? .secondary : .primary)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .padding(.horizontal)
                    }
                }
                
                Spacer()
                
                Button(action: {
                    // Ya no necesitamos guardar explícitamente porque estamos usando @AppStorage
                    UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
                    showOnboarding = false
                }) {
                    Text(UserDefaults.standard.bool(forKey: "hasCompletedOnboarding") ? "Guardar cambios" : "Comenzar")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(name.isEmpty || specialty.isEmpty ? Color.gray : Color("AppPrimary"))
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .disabled(name.isEmpty || specialty.isEmpty)
                .padding(.bottom, 50)
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showingSpecialtyPicker) {
                SpecialtyPickerView(selectedSpecialty: $specialty)
            }
        }
    }
}
