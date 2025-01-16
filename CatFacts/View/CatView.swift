
import SwiftUI

struct CatView: View {
    @ObservedObject var viewModel: CatViewModel

    var body: some View {
        ZStack {
            // Background Gradient
            LinearGradient(
                gradient: Gradient(colors: [Color.pink.opacity(0.6), Color.orange.opacity(0.4)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)

            VStack {
                headingView()
                imageView
                factView
                InstructionsFooterView()
            }
            .padding()
        }
    }

    private var factView: some View {
        VStack(spacing: 20) {
            factContent()
        }
        .onTapGesture {
            Task {
                await viewModel.fetchCatFact()
            }
        }
    }

    private var imageView: some View {
        ZStack {
            Circle()
                .fill(Color.white.opacity(0.8))
                .shadow(radius: 10)

            imageContent()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
        .onTapGesture {
            Task {
                await viewModel.fetchCatImage()
            }
        }
    }

    @ViewBuilder
    func headingView(with titleString: String = "Cat Facts") -> some View {
        Text(titleString)
            .font(.largeTitle)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .multilineTextAlignment(.center)
            .padding()
    }

    @ViewBuilder
    func imageRow(for catImages: CatImage) -> some View {
        VStack {
            if let catImage = catImages.first, let imageUrl = URL(string: catImage.url) {
                AsyncCachedImage(url: imageUrl) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    Image(systemName: "cat")
                        .resizable()
                        .scaledToFit()
                }
            }
        }
    }
        
    @ViewBuilder
    private func factContent() -> some View {
        switch viewModel.catFactViewState {
        case .loading:
            LoadingView()
        case .loaded(let randomCatFact):
            if let fact = randomCatFact.data.first {
                Text(fact)
                    .modifier(FactTextModifier())
            }
        case .failure(let error):
            Text(error.localizedDescription)
                .font(.body)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
    }

    @ViewBuilder
    private func imageContent() -> some View {
        switch viewModel.catImageViewState {
        case .loading:
            LoadingView()
        case .loaded(let catImage):
            imageRow(for: catImage)
                .modifier(CircularImageModifier())
        case .failure(let error):
            Text(error.localizedDescription)
                .font(.body)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
    }
}

// MARK: - View modifiers

struct FactTextModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.headline)
            .multilineTextAlignment(.center)
            .padding()
            .background(Color.white.opacity(0.8))
            .cornerRadius(10)
            .shadow(radius: 5)
            .frame(maxWidth: .infinity, minHeight: 100) // Stabilizes size
    }
}

struct CircularImageModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.white, lineWidth: 4))
            .shadow(radius: 10)
    }
}

// MARK: - Subviews

struct LoadingView: View {
    var body: some View {
        ProgressView()
            .frame(width: 100, height: 100, alignment: .center)
    }
}

struct InstructionsFooterView: View {
    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 10) {
                Image(systemName: "info.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.gray)

                Text("Tap the image or fact to learn more about cats.")
                    .foregroundColor(.gray)
                    .font(.footnote)
                    .multilineTextAlignment(.leading)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.horizontal, 16)
        }
        .frame(maxWidth: .infinity, alignment: .bottom)
        .padding(.vertical, 10)
    }
}


#Preview {
    CatView(viewModel: CatViewModel())
}
