//
//  Memory.swift
//  memories
//
//  Created by Alina Potapova on 09.07.2021.
//

import SwiftUI
import Foundation
import Combine

let imageTest: UIImage = UIImage(imageLiteralResourceName: "test_photo")

struct ImageTest: Codable {
    let imageData: Data?
    
    init(withImage image: UIImage) {
        self.imageData = image.pngData()
    }

    func getImage() -> UIImage? {
        guard let imageData = self.imageData else {
            return nil
        }
        let image = UIImage(data: imageData)
        
        return image
    }
}


struct Memory: Codable, Identifiable {
    
    static func == (lhs: Memory, rhs: Memory) -> Bool {
        return lhs.id == rhs.id
    }
    
    var id = UUID().uuidString
    var date: Date
    var text: String
    var image: ImageTest
    var place: String
}


extension Memory {
    static var defaultMemory: [Memory] {
        get {[
            Memory(id: UUID().uuidString, date: Date(), text: "Something", image: ImageTest(withImage: imageTest), place: "Saint-Petersburg")
        ]}
    }
}

extension Memory {
    var timeFormat: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy, HH:mm"
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
