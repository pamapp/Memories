//
//  Memory.swift
//  memories
//
//  Created by Alina Potapova on 09.07.2021.
//

import SwiftUI
import Foundation

struct Memory: Codable, Identifiable, Hashable {
    var id = UUID().uuidString
    var date: Date
    var text: String
    var image: String
    var place: String
}

extension Memory {
    static var defaultMemory: [Memory] {
        get {[
            Memory(id: UUID().uuidString, date: Date(), text: "Something", image: "test_photo", place: "Saint-Petersburg")
        ]}
    }
}

extension Memory {
    var timeFormat: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: self.date)
    }
}

struct IndexedCollection<Base: RandomAccessCollection>: RandomAccessCollection {
    typealias Index = Base.Index
    typealias Element = (index: Index, element: Base.Element)

    let base: Base

    var startIndex: Index { base.startIndex }

    var endIndex: Index { base.endIndex }

    func index(after i: Index) -> Index {
        base.index(after: i)
    }

    func index(before i: Index) -> Index {
        base.index(before: i)
    }

    func index(_ i: Index, offsetBy distance: Int) -> Index {
        base.index(i, offsetBy: distance)
    }

    subscript(position: Index) -> Element {
        (index: position, element: base[position])
    }
}

extension RandomAccessCollection {
    func indexed() -> IndexedCollection<Self> {
        IndexedCollection(base: self)
    }
}
