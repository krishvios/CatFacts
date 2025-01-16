import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    @State private var opacity = 0.0
    @StateObject var viewModel = CatViewModel()
    
    var body: some View {
        if isActive {
            CatView(viewModel: viewModel) // Navigate to your main app view
        } else {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.pink.opacity(0.6), Color.orange.opacity(0.4)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Image(systemName: "pawprint.circle.fill") // Replace with your app's logo or image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .foregroundColor(.white)
                    
                    Text("Cat Facts")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top, 20)
                }
                .opacity(opacity)
                .onAppear {
                    withAnimation(.easeIn(duration: 1.5)) {
                        opacity = 1.0
                    }
                }
            }
            .onAppear {
                // Preload data during splash screen
                Task {
                    await viewModel.fetchCatData()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) { // Minimum splash duration
                    withAnimation {
                        isActive = true
                    }
                }
            }
        }
    }
}

#Preview {
    SplashScreenView()
}
