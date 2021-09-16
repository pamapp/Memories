//
//  Folder.swift
//  memories
//
//  Created by Alina Potapova on 12.08.2021.
//

import Foundation
import CoreData

extension Folder {
    
    convenience init(name: String, isFavorite: Bool, context: NSManagedObjectContext) {
        self.init(context: context)
        self.name = name
        self.isFavorite = isFavorite
    }
    
    var safeNameContent: String {
        get { name ?? "Unnamed Folder" }
        set { name = newValue }
    }
    
    var safeIsFavorite: Bool {
        get { isFavorite }
        set { isFavorite = newValue }
    }
    
    var safeName: String {
        return safeNameContent != ""
                ? String(safeNameContent.split(whereSeparator: \.isNewline)[0])
                : "Folder"
    }
    
    var safeNotes: Set<Memory> {
        get { memories as? Set<Memory> ?? [] }
        set { memories = newValue as NSSet }
    }
}
