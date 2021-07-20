//
//  MemoryData.swift
//  memories
//
//  Created by Alina Potapova on 09.07.2021.
//

import Foundation
import Combine

final class MemoryData: ObservableObject {
    let didChange = PassthroughSubject<MemoryData, Never>()
    @UserDefault(key: "Memories", defaultValue: Memory.defaultMemory)
    
    var memories: [Memory] {
        didSet {
            didChange.send(self)
        }
    }

    // MARK: - Managing Memories

    func add(_ memory: Memory) {
        if let index = memories.firstIndex(where: { $0.date > memory.date }) {
            memories.insert(memory, at: index)
        } else {
            memories.append(memory)
        }
    }
    
    func delete(_ memory: Memory) {
        if let index = memories.firstIndex(where: { $0.id == memory.id }) {
            memories.remove(at: index)
        }
    }
}
