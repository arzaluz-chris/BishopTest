import SwiftUI
import Combine

@main
struct BishopTestApp: App {
    @StateObject private var dataStore = DataStore()
    private let selectedTabPublisher = PassthroughSubject<Int, Never>()
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding: Bool = false
    @AppStorage("darkMode") private var darkMode: Bool = false
    @State private var showOnboarding = false
    @State private var showSplash = true // State to control the display of the splash screen
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                // Apply the theme according to the user's preference
                Color(.systemBackground)
                    .edgesIgnoringSafeArea(.all)
                    .onAppear {
                        // Configure appearance at launch
                        setAppearance(darkMode: darkMode)
                        
                        // Set up UI appearance
                        configureUIAppearance()
                    }
                
                if showSplash {
                    // Show splash screen
                    SplashView()
                        .onAppear {
                            // Hide the splash screen after a delay
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                withAnimation(.easeOut(duration: 0.3)) {
                                    showSplash = false
                                    
                                    // Show onboarding after the splash screen if necessary
                                    if !hasCompletedOnboarding {
                                        showOnboarding = true
                                    }
                                }
                            }
                        }
                } else {
                    // Main application content
                    MainTabView()
                        .environmentObject(dataStore)
                        .environment(\.selectedTabPublisher, selectedTabPublisher)
                    
                    // Show onboarding if necessary
                    if showOnboarding {
                        OnboardingView(showOnboarding: $showOnboarding)
                            .transition(.opacity)
                            .zIndex(1)
                    }
                }
            }
            .animation(.easeInOut, value: showOnboarding)
            .animation(.easeOut, value: showSplash)
        }
    }
    
    // Method to set the appearance (light/dark mode)
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
    
    // Set up the global UI appearance
    private func configureUIAppearance() {
        // Configure the appearance of the navigation bar
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 18, weight: .semibold)]
        appearance.largeTitleTextAttributes = [.font: UIFont.systemFont(ofSize: 32, weight: .bold)]
        
        // Make the navigation bar cleaner with subtle backgrounds
        appearance.shadowColor = .clear
        appearance.backgroundColor = UIColor.systemBackground
        
        // Apply the appearance to all navigation bars
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        
        // Configure the appearance of the tab bar
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = UIColor.systemBackground
        tabBarAppearance.shadowColor = .clear
        
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        
        // Configure the appearance of segments (pickers)
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(named: "AppPrimary")
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.label], for: .normal)
    }
}
