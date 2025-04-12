// SettingsView.swift
import SwiftUI

struct SettingsView: View {
    @AppStorage("userName") private var userName = ""
    @AppStorage("userSpecialty") private var userSpecialty = ""
    @AppStorage("useModifiers") private var useModifiers = true
    @AppStorage("darkMode") private var darkMode = false
    @State private var showingResetAlert = false
    @State private var showingOnboarding = false
    @State private var animationAmount: CGFloat = 1
    
    var body: some View {
        NavigationView {
            ZStack {
                BishopDesign.Colors.background.edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Profile card
                        VStack(spacing: 20) {
                            // Avatar
                            ZStack {
                                Circle()
                                    .fill(BishopDesign.Colors.primary.opacity(0.15))
                                    .frame(width: 90, height: 90)
                                
                                Text(userInitials)
                                    .font(.system(size: 36, weight: .semibold, design: .rounded))
                                    .foregroundColor(BishopDesign.Colors.primary)
                            }
                            .padding(.top, 20)
                            
                            // User information
                            VStack(spacing: 4) {
                                Text(userName.isEmpty ? NSLocalizedString("Medical Professional", comment: "Default user title") : userName)
                                    .font(.system(size: 20, weight: .bold, design: .rounded))
                                
                                Text(userSpecialty.isEmpty ? NSLocalizedString("Medical level not specified", comment: "Default specialty text") : userSpecialty)
                                    .font(.system(size: 16, design: .rounded))
                                    .foregroundColor(.secondary)
                            }
                            
                            // Edit button
                            Button(action: {
                                showingOnboarding = true
                            }) {
                                HStack {
                                    Image(systemName: "pencil")
                                    Text(NSLocalizedString("Edit Information", comment: "Edit profile button"))
                                }
                                .font(.system(size: 15, weight: .medium, design: .rounded))
                                .foregroundColor(BishopDesign.Colors.primary)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(BishopDesign.Colors.primary.opacity(0.12))
                                .cornerRadius(20)
                            }
                        }
                        .padding(.vertical, 16)
                        .frame(maxWidth: .infinity)
                        .background(Color(.systemBackground))
                        .cornerRadius(20)
                        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
                        .padding(.horizontal, 20)
                        .padding(.top, 16)
                        
                        // App preferences
                        VStack(alignment: .leading, spacing: 20) {
                            Text(NSLocalizedString("App Preferences", comment: "Settings section title"))
                                .font(.system(size: 18, weight: .semibold, design: .rounded))
                                .padding(.horizontal, 20)
                            
                            // Use modifiers
                            preferenceToggleRow(
                                title: NSLocalizedString("Use test modifiers", comment: "Toggle for using test modifiers"),
                                icon: "plus.circle.fill",
                                color: .purple,
                                isOn: $useModifiers,
                                description: NSLocalizedString("Apply score adjustments based on clinical factors", comment: "Description for test modifiers toggle")
                            )
                            
                            Divider()
                                .padding(.horizontal, 20)
                            
                            // Dark mode
                            preferenceToggleRow(
                                title: NSLocalizedString("Dark Mode", comment: "Toggle for dark mode"),
                                icon: "moon.fill",
                                color: .indigo,
                                isOn: $darkMode,
                                description: NSLocalizedString("Change the visual appearance of the app", comment: "Description for dark mode toggle")
                            )
                            .onChange(of: darkMode) { newValue in
                                setAppearance(darkMode: newValue)
                            }
                        }
                        .padding(.vertical, 16)
                        .background(Color(.systemBackground))
                        .cornerRadius(20)
                        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
                        .padding(.horizontal, 20)
                        
                        // About
                        VStack(alignment: .leading, spacing: 20) {
                            Text(NSLocalizedString("About", comment: "About section title"))
                                .font(.system(size: 18, weight: .semibold, design: .rounded))
                                .padding(.horizontal, 20)
                            
                            // Version
                            infoRow(
                                title: NSLocalizedString("Version", comment: "Version label"),
                                icon: "number",
                                color: .blue,
                                value: Constants.appVersion
                            )
                            
                            Divider()
                                .padding(.horizontal, 20)
                            
                            // Information
                            Link(destination: URL(string: "https://es.wikipedia.org/wiki/Test_de_Bishop")!) {
                                HStack {
                                    infoIcon(
                                        icon: "info.circle.fill",
                                        color: .blue
                                    )
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(NSLocalizedString("More information", comment: "More info button"))
                                            .font(.system(size: 16, weight: .medium, design: .rounded))
                                        
                                        Text(NSLocalizedString("Bishop Score on Wikipedia", comment: "Wikipedia link description"))
                                            .font(.system(size: 14, design: .rounded))
                                            .foregroundColor(.secondary)
                                    }
                                    
                                    Spacer()
                                    
                                    Image(systemName: "arrow.up.right")
                                        .font(.system(size: 14))
                                        .foregroundColor(.secondary)
                                }
                                .padding(.horizontal, 20)
                                .padding(.vertical, 8)
                            }
                            
                            Divider()
                                .padding(.horizontal, 20)
                            
                            // Copyright
                            infoRow(
                                title: Constants.appCopyright,
                                icon: "c.circle.fill",
                                color: .gray,
                                value: ""
                            )
                        }
                        .padding(.vertical, 16)
                        .background(Color(.systemBackground))
                        .cornerRadius(20)
                        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
                        .padding(.horizontal, 20)
                        
                        // Reset button
                        Button(action: {
                            showingResetAlert = true
                        }) {
                            HStack {
                                Image(systemName: "arrow.counterclockwise")
                                Text(NSLocalizedString("Reset to default values", comment: "Reset settings button"))
                            }
                            .font(.system(size: 16, weight: .medium, design: .rounded))
                            .foregroundColor(.red)
                            .padding(.vertical, 16)
                            .frame(maxWidth: .infinity)
                            .background(Color(.systemBackground))
                            .cornerRadius(16)
                            .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 8)
                    }
                    .padding(.bottom, 30)
                }
            }
            .navigationBarTitle(NSLocalizedString("Settings", comment: "Navigation bar title"), displayMode: .large)
            .sheet(isPresented: $showingOnboarding) {
                OnboardingView(showOnboarding: $showingOnboarding)
            }
            .alert(isPresented: $showingResetAlert) {
                Alert(
                    title: Text(NSLocalizedString("Reset settings", comment: "Reset alert title")),
                    message: Text(NSLocalizedString("Are you sure you want to reset all settings to their default values?", comment: "Reset confirmation message")),
                    primaryButton: .destructive(Text(NSLocalizedString("Reset", comment: "Confirm reset button"))) {
                        withAnimation {
                            resetSettings()
                        }
                    },
                    secondaryButton: .cancel(Text(NSLocalizedString("Cancel", comment: "Cancel button")))
                )
            }
        }
    }
    
    // Info row
    private func infoRow(title: String, icon: String, color: Color, value: String) -> some View {
        HStack {
            infoIcon(
                icon: icon,
                color: color
            )
            
            Text(title)
                .font(.system(size: 16, weight: .medium, design: .rounded))
            
            Spacer()
            
            if !value.isEmpty {
                Text(value)
                    .font(.system(size: 16, design: .rounded))
                    .foregroundColor(.secondary)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 8)
    }
    
    // Icon for info
    private func infoIcon(icon: String, color: Color) -> some View {
        ZStack {
            Circle()
                .fill(color.opacity(0.15))
                .frame(width: 36, height: 36)
            
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(color)
        }
    }
    
    // Toggle row for preferences
    private func preferenceToggleRow(title: String, icon: String, color: Color, isOn: Binding<Bool>, description: String) -> some View {
        Button(action: {
            withAnimation {
                isOn.wrappedValue.toggle()
                
                // Custom switch
                animationAmount = 1.2
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    animationAmount = 1
                }
            }
        }) {
            HStack {
                infoIcon(
                    icon: icon,
                    color: color
                )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundColor(.primary)
                    
                    Text(description)
                        .font(.system(size: 14, design: .rounded))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Custom switch
                ZStack {
                    Capsule()
                        .fill(isOn.wrappedValue ? BishopDesign.Colors.primary : Color.gray.opacity(0.3))
                        .frame(width: 50, height: 30)
                        .scaleEffect(animationAmount)
                        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: animationAmount)
                    
                    Circle()
                        .fill(Color.white)
                        .frame(width: 26, height: 26)
                        .shadow(radius: 1)
                        .offset(x: isOn.wrappedValue ? 10 : -10)
                        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isOn.wrappedValue)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 8)
        }
    }
    
    // Get initials for avatar
    private var userInitials: String {
        if userName.isEmpty {
            return "DR"
        }
        
        let components = userName.components(separatedBy: " ")
        if components.count >= 2, let first = components.first?.first, let last = components.last?.first {
            return String(first) + String(last)
        } else if let first = components.first?.first {
            return String(first)
        }
        
        return "U"
    }
    
    // Toggle appearance mode
    private func setAppearance(darkMode: Bool) {
        // Updated method for iOS 15+
        if #available(iOS 15.0, *) {
            // Get all application scenes
            for scene in UIApplication.shared.connectedScenes {
                if let windowScene = scene as? UIWindowScene {
                    // Apply the theme to all windows of each scene
                    for window in windowScene.windows {
                        window.overrideUserInterfaceStyle = darkMode ? .dark : .light
                    }
                }
            }
        } else {
            // Fallback for iOS 14 and earlier versions
            #if swift(>=5.1)
            // This code uses a deprecated API but is necessary for iOS 14
            UIApplication.shared.windows.first?.overrideUserInterfaceStyle = darkMode ? .dark : .light
            #endif
        }
    }
    
    // Reset values
    private func resetSettings() {
        userName = ""
        userSpecialty = ""
        useModifiers = true
        darkMode = false
        // Reset the onboarding flag to show it again
        UserDefaults.standard.set(false, forKey: "hasCompletedOnboarding")
        setAppearance(darkMode: false)
    }
}
