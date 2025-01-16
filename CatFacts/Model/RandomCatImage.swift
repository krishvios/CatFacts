//
//  RandomCatImage.swift
//  CatFacts
//
//  Created by ANSK Vivek on 14/01/25.
//

import Foundation

// MARK: - CatImage
struct RandomCatImage: Codable, Hashable, Equatable {
    let id: String
    let url: String
    let width, height: Int
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(url)
        hasher.combine(width)
        hasher.combine(height)
    }
}

typealias CatImage = [RandomCatImage]
