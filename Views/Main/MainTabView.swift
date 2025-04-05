import SwiftUI
import Combine

struct MainTabView: View {
    @EnvironmentObject var dataStore: DataStore
    @State private var selectedTab = 0
    
    @Environment(\.selectedTabPublisher) var selectedTabPublisher
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label("Inicio", systemImage: "house")
                }
                .tag(0)
            
            BishopScoreView()
                .tabItem {
                    Label("Evaluación", systemImage: "list.bullet.clipboard")
                }
                .tag(1)
            
            HistoryView()
                .tabItem {
                    Label("Historial", systemImage: "clock")
                }
                .tag(2)
                
            InductionMethodsView()
                .tabItem {
                    Label("Métodos", systemImage: "doc.text")
                }
                .tag(3)
            
            SettingsView()
                .tabItem {
                    Label("Ajustes", systemImage: "gear")
                }
                .tag(4)
        }
        .onReceive(selectedTabPublisher) { newTab in
            selectedTab = newTab
        }
    }
}

// Código de environment key sin cambios
struct SelectedTabKey: EnvironmentKey {
    static let defaultValue = PassthroughSubject<Int, Never>()
}

extension EnvironmentValues {
    var selectedTabPublisher: PassthroughSubject<Int, Never> {
        get { self[SelectedTabKey.self] }
        set { self[SelectedTabKey.self] = newValue }
    }
}
