import SwiftUI

struct SettingsView: View {
    @AppStorage("userName") private var userName = ""
    @AppStorage("userSpecialty") private var userSpecialty = ""
    @AppStorage("useModifiers") private var useModifiers = true
    @AppStorage("darkMode") private var darkMode = false
    @State private var showingResetAlert = false
    @State private var showingOnboarding = false // Nueva variable de estado
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Información del profesional")) {
                    HStack {
                        Text("Nombre")
                        Spacer()
                        Text(userName)
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("Especialidad")
                        Spacer()
                        Text(userSpecialty)
                            .foregroundColor(.secondary)
                    }
                    
                    Button(action: {
                        showingOnboarding = true
                    }) {
                        Text("Editar información personal")
                            .foregroundColor(Color("AppPrimary"))
                    }
                }
                
                Section(header: Text("Preferencias de la aplicación")) {
                    Toggle("Usar modificadores del test", isOn: $useModifiers)
                    Toggle("Modo oscuro", isOn: $darkMode)
                        .onChange(of: darkMode) { newValue in
                            setAppearance(darkMode: newValue)
                        }
                }
                
                Section {
                    Button(action: {
                        showingResetAlert = true
                    }) {
                        Text("Restablecer valores predeterminados")
                            .foregroundColor(.red)
                    }
                }
                
                Section(header: Text("Acerca de")) {
                    HStack {
                        Text("Versión")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                    
                    Link("Fuente: Test de Bishop", destination: URL(string: "https://es.wikipedia.org/wiki/Test_de_Bishop")!)
                    
                    Text("© 2025 BishopTest App")
                        .foregroundColor(.secondary)
                }
            }
            .navigationBarTitle("Ajustes", displayMode: .inline)
            .sheet(isPresented: $showingOnboarding) {
                OnboardingView(showOnboarding: $showingOnboarding)
            }
            .alert(isPresented: $showingResetAlert) {
                Alert(
                    title: Text("Restablecer valores"),
                    message: Text("¿Estás seguro de que deseas restablecer todos los ajustes a sus valores predeterminados?"),
                    primaryButton: .destructive(Text("Restablecer")) {
                        resetSettings()
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }
    
    private func setAppearance(darkMode: Bool) {
        UIApplication.shared.windows.first?.overrideUserInterfaceStyle = darkMode ? .dark : .light
    }
    
    private func resetSettings() {
        userName = ""
        userSpecialty = ""
        useModifiers = true
        darkMode = false
        // Restablecer la bandera de onboarding para que se muestre de nuevo
        UserDefaults.standard.set(false, forKey: "hasCompletedOnboarding")
        setAppearance(darkMode: false)
    }
}
