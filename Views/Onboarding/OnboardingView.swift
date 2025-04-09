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
            title: "Welcome to BishopTest",
            subtitle: "The modern tool for labor induction assessment",
            image: "chart.bar.doc.horizontal",
            color: BishopDesign.Colors.primary
        ),
        OnboardingPage(
            title: "Accurate Assessment",
            subtitle: "Evidence-based clinical tool for informed decision-making",
            image: "checkmark.shield",
            color: BishopDesign.Colors.favorable
        ),
        OnboardingPage(
            title: "Clinical Decisions",
            subtitle: "Receive personalized recommendations based on the Bishop score",
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
                    TabView(selection: $currentPage) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            OnboardingPageView(page: pages[index])
                                .tag(index)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                    .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                    .frame(height: 400)
                } else {
                    // Personal information page
                    VStack(spacing: BishopDesign.Layout.contentSpacing) {
                        Image("bishop_score_icon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120, height: 120)
                            .padding(.bottom, 20)
                        
                        Text("Customize your experience")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .multilineTextAlignment(.center)
                        
                        Text("Help us tailor the app to your professional profile")
                            .font(.system(size: 17, design: .rounded))
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                            .padding(.bottom, 30)
                        
                        VStack(spacing: 16) {
                            // Name field
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Name")
                                    .font(.system(size: 15, weight: .medium, design: .rounded))
                                    .foregroundColor(.secondary)
                                
                                TextField("Your name", text: $name)
                                    .font(.system(size: 17, design: .rounded))
                                    .padding()
                                    .background(Color(.systemGray6))
                                    .cornerRadius(12)
                            }
                            
                            // Specialty selector
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Medical Specialty")
                                    .font(.system(size: 15, weight: .medium, design: .rounded))
                                    .foregroundColor(.secondary)
                                
                                Button(action: {
                                    showingSpecialtyPicker = true
                                }) {
                                    HStack {
                                        Text(specialty.isEmpty ? "Select your specialty" : specialty)
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
                            title: "Continue",
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
                            Text("Skip")
                                .font(.system(size: 17, weight: .medium, design: .rounded))
                                .foregroundColor(.secondary)
                        }
                    } else {
                        BishopDesign.Components.PrimaryButton(
                            title: "Start",
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

// Model for onboarding pages
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
