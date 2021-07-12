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
    
    var alarms: [Memory] {
        didSet {
            didChange.send(self)
        }
    }
}
