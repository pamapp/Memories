//
//  Memory.swift
//  memories
//
//  Created by Alina Potapova on 09.07.2021.
//

import Foundation

struct Memory: Codable, Identifiable, Hashable {
    var id = UUID().uuidString
    var date: Date
//    var image: Date
    var place: String
}

extension Memory {
    static var defaultMemory: [Memory] {
        get {[
            Memory(id: UUID().uuidString, date: Date(), place: "Saint-Petersburg")
        ]}
    }
}
