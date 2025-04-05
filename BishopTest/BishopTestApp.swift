import SwiftUI
import Combine

@main
struct BishopTestApp: App {
    @StateObject private var dataStore = DataStore()
    private let selectedTabPublisher = PassthroughSubject<Int, Never>()
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding: Bool = false
    @State private var showOnboarding = false
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                MainTabView()
                    .environmentObject(dataStore)
                    .environment(\.selectedTabPublisher, selectedTabPublisher)
                    .onAppear {
                        if !hasCompletedOnboarding {
                            showOnboarding = true
                        }
                    }
                
                if showOnboarding {
                    OnboardingView(showOnboarding: $showOnboarding)
                        .transition(.opacity)
                        .zIndex(1)
                }
            }
            .animation(.easeInOut, value: showOnboarding)
        }
    }
}
