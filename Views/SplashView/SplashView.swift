// SplashView.swift
import SwiftUI

struct SplashView: View {
    @State private var isActive = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    // Eliminada la línea: @State private var rotation = 0.0
    @State private var isLogoVisible = false
    @State private var isTextVisible = false
    
    var body: some View {
        ZStack {
            // Background with gradient
            LinearGradient(
                gradient: Gradient(colors: [BishopDesign.Colors.primary, BishopDesign.Colors.primary.opacity(0.8)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                // Central logo
                ZStack {
                    // Outer pulsing circle
                    Circle()
                        .stroke(Color.white.opacity(0.2), lineWidth: 2)
                        .frame(width: 130, height: 130)
                        .scaleEffect(isLogoVisible ? 1.1 : 0.9)
                        .animation(
                            Animation.easeInOut(duration: 1.5)
                                .repeatForever(autoreverses: true),
                            value: isLogoVisible
                        )
                    
                    // Inner circle with logo
                    Circle()
                        .fill(Color.white)
                        .frame(width: 110, height: 110)
                        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                        .overlay(
                            Image("bishop_score_icon")
                                .font(.system(size: 50))
                                .foregroundColor(BishopDesign.Colors.primary)
                                // Eliminada la línea: .rotationEffect(.degrees(rotation))
                        )
                        .scaleEffect(isLogoVisible ? 1.0 : 0.6)
                        .opacity(isLogoVisible ? 1.0 : 0.0)
                }
                .onAppear {
                    withAnimation(.spring(response: 0.8, dampingFraction: 0.6)) {
                        isLogoVisible = true
                    }
                    
                    // Eliminado el bloque de animación de rotación:
                    // withAnimation(
                    //     Animation.easeInOut(duration: 1.2)
                    //         .delay(0.4)
                    // ) {
                    //     rotation = 20
                    // }
                }
                
                // App text
                VStack(spacing: 10) {
                    Text(NSLocalizedString("BishopTest", comment: "App name in splash screen"))
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text(NSLocalizedString("Precise obstetric evaluation", comment: "App tagline in splash screen"))
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                        .foregroundColor(.white.opacity(0.8))
                }
                .offset(y: isTextVisible ? 0 : 20)
                .opacity(isTextVisible ? 1 : 0)
                .onAppear {
                    withAnimation(
                        Animation.easeOut(duration: 0.8)
                            .delay(0.4)
                    ) {
                        isTextVisible = true
                    }
                }
            }
            
            // Loading indicator at the bottom
            VStack {
                Spacer()
                
                HStack(spacing: 5) {
                    ForEach(0..<3) { index in
                        Circle()
                            .fill(Color.white)
                            .frame(width: 8, height: 8)
                            .scaleEffect(isLogoVisible ? 1.0 : 0.5)
                            .opacity(isLogoVisible ? 1.0 : 0.3)
                            .animation(
                                Animation.easeInOut(duration: 0.5)
                                    .delay(Double(index) * 0.2)
                                    .repeatForever(autoreverses: true),
                                value: isLogoVisible
                            )
                    }
                }
                .padding(.bottom, 50)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation {
                    self.isActive = true
                }
            }
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
