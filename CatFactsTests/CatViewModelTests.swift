import XCTest
@testable import CatFacts

final class CatViewModelTests: XCTestCase {
    var viewModel: CatViewModel!
    var mockNetworkManager: MockNetworkManager!

    override func setUp() async throws {
        try await super.setUp()
        mockNetworkManager = MockNetworkManager()
        viewModel = await CatViewModel(networkManager: mockNetworkManager)
    }

    override func tearDown() async throws {
        mockNetworkManager = nil
        viewModel = nil
        try await super.tearDown()
    }

    func testFetchCatFactSuccess() async throws {
        // Arrange
        let fact = RandomCatFacts(data: ["Cats sleep for 70% of their lives."])
        mockNetworkManager.mockData = try JSONEncoder().encode(fact)

        // Act
        await viewModel.fetchCatFact()

        // Assert
        guard case let .loaded(loadedFact) = await viewModel.catFactViewState else {
            XCTFail("Expected view state to be .loaded, but got \(await viewModel.catFactViewState)")
            return
        }
        XCTAssertEqual(loadedFact, fact, "The loaded fact should match the mocked fact.")
    }

    func testFetchCatImageSuccess() async throws {
        // Arrange
        let image = [RandomCatImage(id: "", url: "https://example.com/cat.jpg", width: 100, height: 100)]
        mockNetworkManager.mockData = try JSONEncoder().encode(image)

        // Act
        await viewModel.fetchCatImage()

        // Assert
        guard case let .loaded(loadedImage) = await viewModel.catImageViewState else {
            XCTFail("Expected view state to be .loaded, but got \(await viewModel.catImageViewState)")
            return
        }
        XCTAssertEqual(loadedImage, image, "The loaded image should match the mocked image.")
    }
}
