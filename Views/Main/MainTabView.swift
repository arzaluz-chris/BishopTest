// MainTabView.swift
import SwiftUI
import Combine

struct MainTabView: View {
    @EnvironmentObject var dataStore: DataStore
    @State private var selectedTab = 0
    @Environment(\.selectedTabPublisher) var selectedTabPublisher
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Main content
            TabView(selection: $selectedTab) {
                HomeView()
                    .tag(0)
                
                BishopScoreView()
                    .tag(1)
                
                HistoryView()
                    .tag(2)
                
                InductionMethodsView()
                    .tag(3)
                
                SettingsView()
                    .tag(4)
            }
            .edgesIgnoringSafeArea(.bottom)
            .onReceive(selectedTabPublisher) { newTab in
                selectedTab = newTab
            }
            
            // Custom tab bar
            CustomTabBar(selectedTab: $selectedTab)
        }
    }
}

// Custom and modern tab bar
struct CustomTabBar: View {
    @Binding var selectedTab: Int
    @Environment(\.colorScheme) var colorScheme
    
    // Navigation bar options with localized titles
    private let tabs: [(image: String, selectedImage: String, title: String)] = [
        ("house", "house.fill", NSLocalizedString("Home", comment: "Home tab title")),
        ("clipboard", "clipboard.fill", NSLocalizedString("Test", comment: "Test tab title")),
        ("clock", "clock.fill", NSLocalizedString("History", comment: "History tab title")),
        ("list.bullet.clipboard", "list.bullet.clipboard.fill", NSLocalizedString("Methods", comment: "Methods tab title")),
        ("gearshape", "gearshape.fill", NSLocalizedString("Settings", comment: "Settings tab title"))
    ]
    
    var body: some View {
        HStack(alignment: .center) {
            ForEach(0..<tabs.count, id: \.self) { index in
                Spacer()
                
                // Button for each tab
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedTab = index
                    }
                }) {
                    VStack(spacing: 4) {
                        // Icon with background circle when selected
                        ZStack {
                            if selectedTab == index {
                                Circle()
                                    .fill(colorScheme == .dark ?
                                          BishopDesign.Colors.primary.opacity(0.3) :
                                          BishopDesign.Colors.primary.opacity(0.15))
                                    .frame(width: 40, height: 40)
                            }
                            
                            Image(systemName: selectedTab == index ? tabs[index].selectedImage : tabs[index].image)
                                .font(.system(size: 20))
                                .foregroundColor(selectedTab == index ? BishopDesign.Colors.primary : .gray)
                        }
                        
                        // Text visible only for the selected tab
                        if selectedTab == index {
                            Text(tabs[index].title)
                                .font(.system(size: 11, weight: .semibold, design: .rounded))
                                .foregroundColor(BishopDesign.Colors.primary)
                        }
                    }
                    .frame(height: selectedTab == index ? 55 : 40)
                    .offset(y: selectedTab == index ? -8 : 0)
                }
                
                Spacer()
            }
        }
        .frame(height: 60)
        .background(
            // Tab bar background with shadow
            Rectangle()
                .fill(Color(.systemBackground))
                .cornerRadius(25, corners: [.topLeft, .topRight])
                .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: -3)
                .edgesIgnoringSafeArea(.bottom)
        )
    }
}

// Keep existing environment key code
struct SelectedTabKey: EnvironmentKey {
    static let defaultValue = PassthroughSubject<Int, Never>()
}

extension EnvironmentValues {
    var selectedTabPublisher: PassthroughSubject<Int, Never> {
        get { self[SelectedTabKey.self] }
        set { self[SelectedTabKey.self] = newValue }
    }
}
