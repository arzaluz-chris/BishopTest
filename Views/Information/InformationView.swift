// InformationView.swift
import SwiftUI

struct InformationView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 12) {
                    Text("Bishop Score Test")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                    
                    Text("Scoring system to assess labor induction")
                        .font(.system(size: 16, design: .rounded))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .padding(.top, 16)
                
                // Section selector
                Picker("", selection: $selectedTab) {
                    Text("Information").tag(0)
                    Text("Parameters").tag(1)
                    Text("Interpretation").tag(2)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal, 20)
                
                // Content based on selected tab
                Group {
                    if selectedTab == 0 {
                        generalInfoView()
                    } else if selectedTab == 1 {
                        parametersInfoView()
                    } else {
                        interpretationInfoView()
                    }
                }
                .padding(.bottom, 30)
            }
        }
        .navigationBarTitle("Information", displayMode: .inline)
        .background(BishopDesign.Colors.background.edgesIgnoringSafeArea(.all))
    }
    
    // General information view
    private func generalInfoView() -> some View {
        VStack(spacing: 20) {
            // Description
            InfoCard(
                title: "What is the Bishop Score Test?",
                content: "The Bishop score test is a scoring system that assesses the cervix during labor and helps predict whether labor induction will be needed. It was developed by Dr. Edward Bishop and published in 1964.",
                icon: "doc.text.magnifyingglass",
                color: .blue
            )
            
            // Clinical utility
            InfoCard(
                title: "Clinical Utility",
                content: "• Assess the state of the cervix before induction\n• Estimate the probability of success in induction\n• Determine the need for cervical ripening beforehand\n• Help choose the most appropriate method of induction",
                icon: "waveform.path.ecg",
                color: .green
            )
            
            // History
            InfoCard(
                title: "History",
                content: "Dr. Edward Bishop developed this scoring system in 1964 to evaluate the inducibility of the cervix. It originally included only 5 components, but subsequently, modifiers have been added to improve its predictive accuracy.",
                icon: "clock.arrow.circlepath",
                color: .orange
            )
            
            // Importance
            InfoCard(
                title: "Importance",
                content: "An adequate score allows:\n• Reduce unnecessary cesareans\n• Optimize induction outcomes\n• Decrease maternal and fetal complications\n• Improve the birth experience",
                icon: "heart.text.square",
                color: .red
            )
        }
        .padding(.horizontal, 20)
    }
    
    // Parameters information view
    private func parametersInfoView() -> some View {
        VStack(spacing: 20) {
            // Scoring table
            VStack(alignment: .leading, spacing: 16) {
                Text("Evaluated Parameters")
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                
                // Scoring table
                VStack(spacing: 0) {
                    // Headers
                    HStack {
                        Text("Parameter")
                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                            .frame(width: 100, alignment: .leading)
                        
                        Text("0 points")
                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                            .frame(maxWidth: .infinity)
                        
                        Text("1 point")
                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                            .frame(maxWidth: .infinity)
                        
                        Text("2 points")
                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                            .frame(maxWidth: .infinity)
                        
                        Text("3 points")
                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                            .frame(maxWidth: .infinity)
                    }
                    .padding(.vertical, 10)
                    .background(Color(.systemGray5).opacity(0.7))
                    
                    Divider()
                    
                    // Dilation
                    parameterRow(
                        name: "Dilation",
                        values: ["0 cm", "1-2 cm", "3-4 cm", "≥5 cm"]
                    )
                    
                    Divider()
                    
                    // Effacement
                    parameterRow(
                        name: "Effacement",
                        values: ["0-30%", "40-50%", "60-70%", "≥80%"]
                    )
                    
                    Divider()
                    
                    // Consistency
                    parameterRow(
                        name: "Consistency",
                        values: ["Firm", "Medium", "Soft", "-"]
                    )
                    
                    Divider()
                    
                    // Position
                    parameterRow(
                        name: "Position",
                        values: ["Posterior", "Medium", "Anterior", "-"]
                    )
                    
                    Divider()
                    
                    // Station
                    parameterRow(
                        name: "Station",
                        values: ["-3", "-2", "-1/0", "+1/+2"]
                    )
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
            }
            .padding(20)
            .background(Color(.systemBackground))
            .cornerRadius(16)
            
            // Modifiers
            InfoCard(
                title: "Score Modifiers",
                content: "**Add 1 point for:**\n• Preeclampsia\n• Each previous vaginal delivery\n\n**Subtract 1 point for:**\n• Post-term pregnancy\n• Nulliparity\n• Premature rupture of membranes",
                icon: "plus.forwardslash.minus",
                color: .purple
            )
            
            // Cervical assessment explanation
            InfoCard(
                title: "Cervical Assessment",
                content: "Cervical assessment should be performed via vaginal examination by a trained professional. It is recommended that serial evaluations be conducted by the same examiner for greater consistency in results.",
                icon: "hand.point.up.left",
                color: .blue
            )
        }
        .padding(.horizontal, 20)
    }
    
    // Interpretation information view
    private func interpretationInfoView() -> some View {
        VStack(spacing: 20) {
            // Interpretation of results
            VStack(alignment: .leading, spacing: 20) {
                Text("Interpretation of Results")
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                
                // Favorable cervix
                interpretationCard(
                    title: "Favorable Cervix",
                    subtitle: "Score ≥ 8",
                    description: "High probability of success in induction, comparable to spontaneous labor. No cervical ripening is required.",
                    color: BishopDesign.Colors.favorable
                )
                
                // Moderately favorable cervix
                interpretationCard(
                    title: "Moderately Favorable Cervix",
                    subtitle: "Score 6-7",
                    description: "Induction possible, especially in multiparous women. In nulliparous women, consider cervical ripening based on clinical judgment.",
                    color: BishopDesign.Colors.moderate
                )
                
                // Unfavorable cervix
                interpretationCard(
                    title: "Unfavorable Cervix",
                    subtitle: "Score ≤ 5",
                    description: "Low probability of success in direct induction. Cervical ripening with pharmacological or mechanical methods is recommended.",
                    color: BishopDesign.Colors.unfavorable
                )
            }
            .padding(20)
            .background(Color(.systemBackground))
            .cornerRadius(16)
            
            // Recommendations based on score
            InfoCard(
                title: "Guidelines Based on Score",
                content: "• **Score ≥ 8:** Induction with oxytocin, consider amniotomy\n• **Score 6-7:** In multiparous women, oxytocin. In nulliparous women, evaluate cervical ripening\n• **Score ≤ 5:** Cervical ripening with prostaglandins or mechanical methods",
                icon: "list.clipboard",
                color: .green
            )
            
            // Indications for induction
            InfoCard(
                title: "Indications for Induction",
                content: "• Chronologically prolonged gestation (>41.0 weeks)\n• Maternal pathologies (Preeclampsia, Diabetes)\n• Fetal indications (IUGR, intrauterine fetal demise)\n• Obstetric causes (PROM, EVP)",
                icon: "exclamationmark.triangle",
                color: .red
            )
            
            // Final note
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Image(systemName: "info.circle.fill")
                        .foregroundColor(.blue)
                    
                    Text("Clinical Note")
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundColor(.blue)
                }
                
                Text("The Bishop Score Test is a decision-support tool, but it should always be assessed in the complete clinical context and considering the individual characteristics of each patient.")
                    .font(.system(size: 14, design: .rounded))
                    .foregroundColor(.secondary)
            }
            .padding(16)
            .background(Color.blue.opacity(0.1))
            .cornerRadius(12)
        }
        .padding(.horizontal, 20)
    }
    
    // Row for parameters table
    private func parameterRow(name: String, values: [String]) -> some View {
        HStack {
            Text(name)
                .font(.system(size: 14, design: .rounded))
                .frame(width: 100, alignment: .leading)
            
            ForEach(0..<values.count, id: \.self) { index in
                Text(values[index])
                    .font(.system(size: 14, design: .rounded))
                    .frame(maxWidth: .infinity)
                    .foregroundColor(values[index] == "-" ? .secondary : .primary)
            }
        }
        .padding(.vertical, 10)
    }
    
    // Card for each interpretation
    private func interpretationCard(title: String, subtitle: String, description: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Circle()
                    .fill(color)
                    .frame(width: 12, height: 12)
                
                Text(title)
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundColor(color)
                
                Spacer()
                
                Text(subtitle)
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(color.opacity(0.15))
                    .foregroundColor(color)
                    .cornerRadius(8)
            }
            
            Text(description)
                .font(.system(size: 14, design: .rounded))
                .foregroundColor(.secondary)
        }
        .padding(12)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

// Card for information
struct InfoCard: View {
    let title: LocalizedStringKey
    let content: LocalizedStringKey
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(color)
                    .frame(width: 24, height: 24)
                
                Text(title)
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundColor(color)
            }
            
            Text(content)
                .font(.system(size: 15, design: .rounded))
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}
