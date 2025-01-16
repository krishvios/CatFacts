//
//  CatFactsApp.swift
//  CatFacts
//
//  Created by ANSK Vivek on 15/01/25.
//

import Foundation
import SwiftUI

enum CatFactViewState {
    case loading
    case loaded(RandomCatFacts)
    case failure(Error)
}

enum CatImageViewState {
    case loading
    case loaded(CatImage)
    case failure(Error)
}

@MainActor
class CatViewModel: ObservableObject {
    
    @Published private(set) var catFactViewState: CatFactViewState = .loading
    @Published private(set) var catImageViewState: CatImageViewState = .loading
    @Published var catFacts: RandomCatFacts?
    @Published var catImages: CatImage = []

    private var networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }
    
    
    func fetchCatFact() async {
        catFactViewState = .loading
        do {
            let catFacts = try await networkManager.getData(urlString: Constants.randomCatFactURL, type: RandomCatFacts.self)
            catFactViewState = .loaded(catFacts)
        } catch {
            catFactViewState = .failure(error)
        }
    }
    
    func fetchCatImage() async {
        catImageViewState = .loading
        do {
            let catImages = try await networkManager.getData(urlString: Constants.randomCatImageURL, type: CatImage.self)
            catImageViewState = .loaded(catImages)
        } catch {
            catImageViewState = .failure(error)
        }
    }
    
    func fetchCatData() async {
        Task {
            await fetchCatFact()
        }
        Task {
            await fetchCatImage()
        }
    }
    
}

