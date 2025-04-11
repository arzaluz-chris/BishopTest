// BishopScoreView.swift
import SwiftUI

struct BishopScoreView: View {
    @EnvironmentObject var dataStore: DataStore
    @State private var bishopScore = BishopScore()
    @State private var showingResult = false
    @AppStorage("useModifiers") private var useModifiers = true
    
    // To control the stepper animation
    @State private var animateDeliveries = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: BishopDesign.Layout.sectionSpacing) {
                // Header
                VStack(spacing: 10) {
                    Text(NSLocalizedString("Bishop Score Test", comment: "Main title of Bishop Score Test"))
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                    
                    Text(NSLocalizedString("Complete all fields to calculate the score", comment: "Subtitle instruction"))
                        .font(.system(size: 17, design: .rounded))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .padding(.top, 20)
                .padding(.bottom, 10)
                
                // Patient information section (previously localized)
                VStack(alignment: .leading, spacing: 20) {
                    // Section title
                    HStack {
                        Image(systemName: "person.fill")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(BishopDesign.Colors.primary)
                        
                        Text(NSLocalizedString("Patient Information", comment: "Section title for patient info"))
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                    }
                    
                    // Name (optional)
                    VStack(alignment: .leading, spacing: 8) {
                        Text(NSLocalizedString("Name (optional)", comment: "Label for patient name input"))
                            .font(.system(size: 15, weight: .medium, design: .rounded))
                            .foregroundColor(.secondary)
                        
                        TextField(NSLocalizedString("Patient's name", comment: "Placeholder for patient name"), text: Binding(
                            get: { bishopScore.patientName ?? "" },
                            set: { bishopScore.patientName = $0.isEmpty ? nil : $0 }
                        ))
                        .font(.system(size: 17, design: .rounded))
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    }
                    
                    // Age and Previous Deliveries sections (previously localized)
                    // ... [These sections remain the same as in the previous artifact]
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 20)
                .background(BishopDesign.Colors.cardBackground)
                .cornerRadius(20)
                .padding(.horizontal, 20)
                
                // Bishop Test Parameters
                VStack(alignment: .leading, spacing: 24) {
                    // Section title
                    HStack {
                        Image(systemName: "waveform.path.ecg")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(BishopDesign.Colors.primary)
                        
                        Text(NSLocalizedString("Test Parameters", comment: "Section title for test parameters"))
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                    }
                    .padding(.bottom, 8)
                    
                    // Dilation
                    parameterView(
                        title: NSLocalizedString("Dilation", comment: "Parameter name for dilation"),
                        icon: "circle.dashed",
                        options: Dilation.allCases,
                        selection: $bishopScore.dilation
                    )
                    
                    // Effacement
                    parameterView(
                        title: NSLocalizedString("Effacement", comment: "Parameter name for effacement"),
                        icon: "percent",
                        options: Effacement.allCases,
                        selection: $bishopScore.effacement
                    )
                    
                    // Consistency
                    parameterView(
                        title: NSLocalizedString("Consistency", comment: "Parameter name for consistency"),
                        icon: "hand.tap",
                        options: Consistency.allCases,
                        selection: $bishopScore.consistency
                    )
                    
                    // Position
                    parameterView(
                        title: NSLocalizedString("Position", comment: "Parameter name for position"),
                        icon: "arrow.up.and.down",
                        options: Position.allCases,
                        selection: $bishopScore.position
                    )
                    
                    // Station (Pelvic Position)
                    parameterView(
                        title: NSLocalizedString("Station (Pelvic Position)", comment: "Parameter name for station"),
                        icon: "ruler",
                        options: Station.allCases,
                        selection: $bishopScore.station
                    )
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 20)
                .background(BishopDesign.Colors.cardBackground)
                .cornerRadius(20)
                .padding(.horizontal, 20)
                
                // Conditional modifiers
                if useModifiers {
                    VStack(alignment: .leading, spacing: 20) {
                        // Section title
                        HStack {
                            Image(systemName: "plus.circle")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(BishopDesign.Colors.primary)
                            
                            Text(NSLocalizedString("Modifiers", comment: "Section title for modifiers"))
                                .font(.system(size: 18, weight: .semibold, design: .rounded))
                        }
                        
                        // Toggles for modifiers
                        modifierToggle(
                            title: NSLocalizedString("Preeclampsia", comment: "Modifier for preeclampsia"),
                            icon: "waveform.path.ecg.rectangle",
                            isOn: $bishopScore.preeclampsia
                        )
                        modifierToggle(
                            title: NSLocalizedString("Post-term pregnancy", comment: "Modifier for post-term pregnancy"),
                            icon: "calendar.badge.clock",
                            isOn: $bishopScore.postdatePregnancy
                        )
                        modifierToggle(
                            title: NSLocalizedString("Premature rupture of membranes", comment: "Modifier for premature rupture"),
                            icon: "drop",
                            isOn: $bishopScore.prematureRupture
                        )
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 20)
                    .background(BishopDesign.Colors.cardBackground)
                    .cornerRadius(20)
                    .padding(.horizontal, 20)
                }
                
                // Calculate button
                VStack {
                    BishopDesign.Components.PrimaryButton(
                        title: LocalizedStringKey("Calculate Score"),
                        icon: "arrow.right",
                        action: {
                            showingResult = true
                        }
                    )
                }
                .padding(.horizontal, 24)
                .padding(.top, 10)
                .padding(.bottom, 30)
            }
        }
        .navigationBarTitle(NSLocalizedString("Evaluation", comment: "Navigation bar title"), displayMode: .inline)
        .background(BishopDesign.Colors.background.edgesIgnoringSafeArea(.all))
        .sheet(isPresented: $showingResult) {
            ResultView(bishopScore: getScoreWithModifiers(), dataStore: dataStore, isPresented: $showingResult)
        }
    }
    
    // View for each parameter with option selection
    private func parameterView<T: Identifiable>(
        title: String,
        icon: String,
        options: [T],
        selection: Binding<T>
    ) -> some View where T: Hashable, T: CustomStringConvertible {
        VStack(alignment: .leading, spacing: 12) {
            // Parameter title
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 15))
                    .foregroundColor(BishopDesign.Colors.primary)
                
                Text(title)
                    .font(.system(size: 16, weight: .medium, design: .rounded))
            }
            
            // Options as horizontal segments
            HStack(spacing: 0) {
                ForEach(options) { option in
                    Button(action: {
                        selection.wrappedValue = option
                    }) {
                        Text(option.description)
                            .font(.system(size: 14, design: .rounded))
                            .lineLimit(1)
                            .minimumScaleFactor(0.7)
                            .padding(.vertical, 12)
                            .frame(maxWidth: .infinity)
                            .background(selection.wrappedValue.hashValue == option.hashValue ?
                                        BishopDesign.Colors.primary : Color.clear)
                            .foregroundColor(selection.wrappedValue.hashValue == option.hashValue ?
                                           .white : .primary)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray.opacity(0.2), lineWidth: selection.wrappedValue.hashValue == option.hashValue ? 0 : 1)
                            )
                            .animation(.easeInOut(duration: 0.2), value: selection.wrappedValue.hashValue)
                    }
                }
            }
            .background(Color(.systemGray6))
            .cornerRadius(10)
        }
    }
    
    // Custom toggle for modifiers
    private func modifierToggle(title: String, icon: String, isOn: Binding<Bool>) -> some View {
        Button(action: {
            isOn.wrappedValue.toggle()
        }) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundColor(isOn.wrappedValue ? BishopDesign.Colors.primary : .secondary)
                
                Text(title)
                    .font(.system(size: 16, design: .rounded))
                    .foregroundColor(.primary)
                
                Spacer()
                
                // Custom switch
                ZStack {
                    Capsule()
                        .fill(isOn.wrappedValue ? BishopDesign.Colors.primary : Color.gray.opacity(0.3))
                        .frame(width: 50, height: 30)
                    
                    Circle()
                        .fill(Color.white)
                        .frame(width: 26, height: 26)
                        .shadow(radius: 1)
                        .offset(x: isOn.wrappedValue ? 10 : -10)
                }
                .animation(.spring(), value: isOn.wrappedValue)
            }
            .padding(.vertical, 10)
        }
    }
    
    // Function to apply modifiers based on settings
    private func getScoreWithModifiers() -> BishopScore {
        var score = bishopScore
        
        // If modifiers are disabled, reset them
        if !useModifiers {
            score.preeclampsia = false
            score.postdatePregnancy = false
            score.prematureRupture = false
        }
        
        return score
    }
}
