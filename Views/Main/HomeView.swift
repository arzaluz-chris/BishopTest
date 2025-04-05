import SwiftUI

struct HomeView: View {
    @AppStorage("userName") private var userName = ""
    @AppStorage("userSpecialty") private var userSpecialty = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Spacer().frame(height: 20)
                
                Image("bishop_score_icon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                
                Text("Test de Bishop")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Sistema de puntuación para valorar el cuello uterino y la probabilidad de éxito en la inducción del parto")
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .foregroundColor(.secondary)
                    .font(.subheadline)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                
                Spacer() // Este Spacer empujará los botones hacia el centro
                
                // Mantenemos todos los botones originales
                NavigationLink(destination: BishopScoreView()) {
                    HStack {
                        Image(systemName: "clipboard.fill")
                        Text("Iniciar Evaluación")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color("AppPrimary"))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding(.horizontal)
                
                NavigationLink(destination: InformationView()) {
                    HStack {
                        Image(systemName: "info.circle.fill")
                        Text("Información Médica")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding(.horizontal)
                
                NavigationLink(destination: InductionMethodsView()) {
                    HStack {
                        Image(systemName: "list.bullet.clipboard")
                        Text("Métodos de Inducción")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding(.horizontal)
                
                NavigationLink(destination: HistoryView()) {
                    HStack {
                        Image(systemName: "clock.fill")
                        Text("Historial")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.purple)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .padding(.vertical)
            .navigationBarTitle("", displayMode: .inline)
        }
    }
}
