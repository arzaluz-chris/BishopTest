// DesignSystem.swift
import SwiftUI

struct BishopDesign {
    // COLORS
    struct Colors {
        static let primary = Color("AppPrimary")
        static let secondary = Color("AppSecondary")
        static let accent = Color("AccentColor")
        static let favorable = Color("FavorableGreen")
        static let moderate = Color("ModerateOrange")
        static let unfavorable = Color("UnfavorableRed")
        
        // Nuevos colores neutros
        static let background = Color(.systemBackground)
        static let secondaryBackground = Color(.secondarySystemBackground)
        static let groupedBackground = Color(.systemGroupedBackground)
        static let cardBackground = Color(.systemGray6)
        static let divider = Color(.separator)
    }
    
    // SIZE AND SPACING
    struct Layout {
        static let cornerRadius: CGFloat = 16
        static let buttonCornerRadius: CGFloat = 25
        static let cardPadding: CGFloat = 16
        static let contentSpacing: CGFloat = 12
        static let sectionSpacing: CGFloat = 24
        static let iconSize: CGFloat = 28
    }
    
    // TYPOGRAPHY
    struct Typography {
        static func heading1() -> some View {
            Text("")
                .font(.system(size: 28, weight: .bold, design: .rounded))
        }
        
        static func heading2() -> some View {
            Text("")
                .font(.system(size: 22, weight: .bold, design: .rounded))
        }
        
        static func heading3() -> some View {
            Text("")
                .font(.system(size: 18, weight: .semibold, design: .rounded))
        }
        
        static func body() -> some View {
            Text("")
                .font(.system(size: 16, weight: .regular, design: .rounded))
        }
        
        static func caption() -> some View {
            Text("")
                .font(.system(size: 14, weight: .regular, design: .rounded))
                .foregroundColor(.secondary)
        }
    }
    
    // COMPONENTS
    struct Components {
        // Primary button
        struct PrimaryButton: View {
            let title: String
            let icon: String?
            let action: () -> Void
            let isDisabled: Bool
            
            init(title: String, icon: String? = nil, isDisabled: Bool = false, action: @escaping () -> Void) {
                self.title = title
                self.icon = icon
                self.action = action
                self.isDisabled = isDisabled
            }
            
            var body: some View {
                Button(action: action) {
                    HStack(spacing: 8) {
                        if let icon = icon {
                            Image(systemName: icon)
                                .font(.system(size: 16, weight: .semibold))
                        }
                        
                        Text(title)
                            .font(.system(size: 17, weight: .semibold, design: .rounded))
                            .frame(maxWidth: .infinity)
                    }
                    .padding(.vertical, 16)
                    .padding(.horizontal, 20)
                    .background(isDisabled ? Color.gray.opacity(0.3) : Colors.primary)
                    .foregroundColor(.white)
                    .cornerRadius(Layout.buttonCornerRadius)
                    .shadow(color: isDisabled ? Color.clear : Colors.primary.opacity(0.4), radius: 8, x: 0, y: 4)
                }
                .disabled(isDisabled)
            }
        }
        
        // Secondary button
        struct SecondaryButton: View {
            let title: String
            let icon: String?
            let action: () -> Void
            
            init(title: String, icon: String? = nil, action: @escaping () -> Void) {
                self.title = title
                self.icon = icon
                self.action = action
            }
            
            var body: some View {
                Button(action: action) {
                    HStack(spacing: 8) {
                        if let icon = icon {
                            Image(systemName: icon)
                                .font(.system(size: 16, weight: .semibold))
                        }
                        
                        Text(title)
                            .font(.system(size: 17, weight: .semibold, design: .rounded))
                            .frame(maxWidth: .infinity)
                    }
                    .padding(.vertical, 16)
                    .padding(.horizontal, 20)
                    .background(Colors.cardBackground)
                    .foregroundColor(.primary)
                    .cornerRadius(Layout.buttonCornerRadius)
                    .overlay(
                        RoundedRectangle(cornerRadius: Layout.buttonCornerRadius)
                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                    )
                }
            }
        }
        
        // Card
        struct Card<Content: View>: View {
            let content: Content
            
            init(@ViewBuilder content: () -> Content) {
                self.content = content()
            }
            
            var body: some View {
                content
                    .padding(Layout.cardPadding)
                    .background(Colors.cardBackground)
                    .cornerRadius(Layout.cornerRadius)
                    .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 2)
            }
        }
        
        // Stylized picker
        struct StylizedPicker<SelectionValue: Hashable, Content: View>: View {
            let selection: Binding<SelectionValue>
            let content: Content
            
            init(selection: Binding<SelectionValue>, @ViewBuilder content: () -> Content) {
                self.selection = selection
                self.content = content()
            }
            
            var body: some View {
                Picker("", selection: selection) {
                    content
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.vertical, 8)
            }
        }
        
        // Score badge (for HistoryView)
        struct ScoreBadge: View {
            let score: Int
            let interpretation: ScoreInterpretation
            
            var body: some View {
                ZStack {
                    Circle()
                        .fill(getColor(for: interpretation).opacity(0.15))
                        .frame(width: 44, height: 44)
                    
                    Circle()
                        .stroke(getColor(for: interpretation), lineWidth: 2)
                        .frame(width: 44, height: 44)
                    
                    Text("\(score)")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(getColor(for: interpretation))
                }
            }
            
            private func getColor(for interpretation: ScoreInterpretation) -> Color {
                switch interpretation {
                case .favorable:
                    return Colors.favorable
                case .moderatelyFavorable:
                    return Colors.moderate
                case .unfavorable:
                    return Colors.unfavorable
                }
            }
        }
    }
}

// Useful extensions
extension View {
    // Styling the shadows and borders
    func bishopCardStyle() -> some View {
        self
            .padding(BishopDesign.Layout.cardPadding)
            .background(BishopDesign.Colors.cardBackground)
            .cornerRadius(BishopDesign.Layout.cornerRadius)
            .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 2)
    }
    
    // Navigation style
    func bishopNavigationStyle(title: String) -> some View {
        self.navigationBarTitle(title, displayMode: .large)
            .navigationBarTitleDisplayMode(.inline)
    }
}
