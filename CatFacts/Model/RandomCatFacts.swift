//
//  RandomCatFacts.swift
//  CatFacts
//
//  Created by ANSK Vivek on 15/01/25.
//

import Foundation

// MARK: - RandomCatFacts
struct RandomCatFacts: Codable, Hashable, Equatable {
    let data: [String]
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(data)
    }
}
