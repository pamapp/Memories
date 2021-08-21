//
//  Memory.swift
//  memories
//
//  Created by Alina Potapova on 09.07.2021.
//

import Foundation
import CoreData

extension Memory {
    convenience init(
        date: Date = Date(),
        id: UUID = UUID(),
        place: String,
        text: String,
        folder: Folder? = nil,
        context: NSManagedObjectContext
    ) {
        self.init(context: context)
        self.date = date
        self.id = id
        self.place = place
        self.text = text
        self.folder = folder
    }
    
    var safeDateContent: Date {
        get { date ?? Date() }
        set { date = newValue }
    }

    var safeTextContent: String {
        get { text ?? "" }
        set { text = newValue }
    }
    
    var safePlaceContent: String {
        get { place ?? "" }
        set { place = newValue }
    }
    
    var safeID: UUID {
        get { id ?? UUID() }
        set { id = newValue }
    }
    
    var safeDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy, EE"
        return formatter.string(from: safeDateContent)
    }
    
    var safeNavDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: safeDateContent)
    }
    
    var safeText: String {
        return safeTextContent != ""
                ? String(safeTextContent.split(whereSeparator: \.isNewline)[0])
                : "Something"
    }
    
    var safePlace: String {
        return safePlaceContent != ""
                ? String(safePlaceContent.split(whereSeparator: \.isNewline)[0])
                : "Somewhere"
    }
    
    var contentWithoutTitle: String {
        let splitContent = safeTextContent.split(whereSeparator: \.isNewline)
        return safeTextContent != ""
                ? splitContent[1..<splitContent.count].joined(separator: "\n")
                : "Add some text"
    }
}
