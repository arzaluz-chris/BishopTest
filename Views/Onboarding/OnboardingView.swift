// OnboardingView.swift
import SwiftUI

struct OnboardingView: View {
    @Binding var showOnboarding: Bool
    @AppStorage("userName") private var name = ""
    @AppStorage("userSpecialty") private var specialty = ""
    @State private var showingSpecialtyPicker = false
    @State private var currentPage = 0
    
    let pages = [
        OnboardingPage(
            title: NSLocalizedString("Welcome to BishopTest", comment: "First onboarding page title"),
            subtitle: NSLocalizedString("The modern tool for labor induction assessment", comment: "First onboarding page subtitle"),
            image: "chart.bar.doc.horizontal",
            color: BishopDesign.Colors.primary
        ),
        OnboardingPage(
            title: NSLocalizedString("Accurate Assessment", comment: "Second onboarding page title"),
            subtitle: NSLocalizedString("Evidence-based clinical tool for informed decision-making", comment: "Second onboarding page subtitle"),
            image: "checkmark.shield",
            color: BishopDesign.Colors.favorable
        ),
        OnboardingPage(
            title: NSLocalizedString("Clinical Decisions", comment: "Third onboarding page title"),
            subtitle: NSLocalizedString("Receive personalized recommendations based on the Bishop score", comment: "Third onboarding page subtitle"),
            image: "heart.text.square",
            color: BishopDesign.Colors.moderate
        )
    ]
    
    var body: some View {
        ZStack {
            BishopDesign.Colors.background.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                // Pagination
                if currentPage < pages.count {
                    // Content with TabView
                    VStack {
                        TabView(selection: $currentPage) {
                            ForEach(0..<pages.count, id: \.self) { index in
                                OnboardingPageView(page: pages[index])
                                    .tag(index)
                            }
                        }
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never)) // Hide default indicator
                        .frame(height: 400)
                        
                        // Custom pagination indicator
                        HStack(spacing: 8) {
                            ForEach(0..<pages.count, id: \.self) { index in
                                Circle()
                                    .fill(currentPage == index ? BishopDesign.Colors.primary : Color.gray.opacity(0.3))
                                    .frame(width: 8, height: 8)
                            }
                        }
                        .padding(.top, 10)
                    }
                } else {
                    // Personal information page
                    VStack(spacing: BishopDesign.Layout.contentSpacing) {
                        Image("bishop_score_icon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120, height: 120)
                            .padding(.bottom, 20)
                        
                        Text(NSLocalizedString("Customize your experience", comment: "Personalization page title"))
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .multilineTextAlignment(.center)
                        
                        Text(NSLocalizedString("Help us tailor the app to your professional profile", comment: "Personalization page subtitle"))
                            .font(.system(size: 17, design: .rounded))
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                            .padding(.bottom, 30)
                        
                        VStack(spacing: 16) {
                            // Name field
                            VStack(alignment: .leading, spacing: 8) {
                                Text(NSLocalizedString("Name", comment: "Name input label"))
                                    .font(.system(size: 15, weight: .medium, design: .rounded))
                                    .foregroundColor(.secondary)
                                
                                TextField(NSLocalizedString("Your name", comment: "Name input placeholder"), text: $name)
                                    .font(.system(size: 17, design: .rounded))
                                    .padding()
                                    .background(Color(.systemGray6))
                                    .cornerRadius(12)
                            }
                            
                            // Specialty selector
                            VStack(alignment: .leading, spacing: 8) {
                                Text(NSLocalizedString("Medical Level", comment: "Medical level input label"))
                                    .font(.system(size: 15, weight: .medium, design: .rounded))
                                    .foregroundColor(.secondary)
                                
                                Button(action: {
                                    showingSpecialtyPicker = true
                                }) {
                                    HStack {
                                        Text(specialty.isEmpty ?
                                            NSLocalizedString("Select your medical level", comment: "Medical level placeholder") :
                                            specialty)
                                            .font(.system(size: 17, design: .rounded))
                                            .foregroundColor(specialty.isEmpty ? .secondary : .primary)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        
                                        Image(systemName: "chevron.down")
                                            .foregroundColor(.secondary)
                                    }
                                    .padding()
                                    .background(Color(.systemGray6))
                                    .cornerRadius(12)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.top, 20)
                }
                
                Spacer()
                
                // Navigation buttons
                VStack {
                    if currentPage < pages.count {
                        BishopDesign.Components.PrimaryButton(
                            title: LocalizedStringKey("Continue"),
                            icon: "arrow.right",
                            action: {
                                withAnimation {
                                    currentPage += 1
                                }
                            }
                        )
                        .padding(.bottom, 8)
                        
                        Button(action: {
                            currentPage = pages.count
                        }) {
                            Text(NSLocalizedString("Skip", comment: "Skip onboarding button"))
                                .font(.system(size: 17, weight: .medium, design: .rounded))
                                .foregroundColor(.secondary)
                        }
                    } else {
                        BishopDesign.Components.PrimaryButton(
                            title: LocalizedStringKey("Start"),
                            icon: "checkmark",
                            isDisabled: name.isEmpty || specialty.isEmpty,
                            action: {
                                UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
                                showOnboarding = false
                            }
                        )
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
        .sheet(isPresented: $showingSpecialtyPicker) {
            SpecialtyPickerView(selectedSpecialty: $specialty)
        }
    }
}

// Model for onboarding pages remains the same
struct OnboardingPage {
    let title: String
    let subtitle: String
    let image: String
    let color: Color
}

// Individual view for each page
struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            // Icon image
            ZStack {
                Circle()
                    .fill(page.color.opacity(0.15))
                    .frame(width: 150, height: 150)
                
                Image(systemName: page.image)
                    .font(.system(size: 60, weight: .medium))
                    .foregroundColor(page.color)
            }
            .padding(.bottom, 32)
            
            // Texts
            Text(page.title)
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .multilineTextAlignment(.center)
            
            Text(page.subtitle)
                .font(.system(size: 17, design: .rounded))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal, 24)
            
            Spacer()
        }
        .padding(.top, 40)
    }
}
