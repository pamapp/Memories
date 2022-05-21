//
//  FolderModel.swift
//  memories
//
//  Created by Alina Potapova on 16.08.2021.
//
//

import Foundation
import CoreData
import SwiftUI

extension FoldersView{
    final class FolderModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
        private let controller :  NSFetchedResultsController<Folder>

        public var alert = false
        public var alertMessage = ""
        
        init(moc: NSManagedObjectContext) {
            let sortDescriptors = [NSSortDescriptor(keyPath: \Folder.isFavorite, ascending: false), NSSortDescriptor(keyPath: \Folder.name, ascending: true)]
            controller = Folder.resultsController(moc: moc, sortDescriptors: sortDescriptors)
            super.init()
            
            controller.delegate = self
            do{
                try controller.performFetch()
                alert = false
            }catch{
                alert =  true
                alertMessage = "Saving data error"
            }
        }
        
        var folders: [Folder] {
            return controller.fetchedObjects ?? []
        }
        
        func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            objectWillChange.send()
        }
    
        
        func getDefaultFolder() -> Folder {
            if folders.isEmpty {
                let folder = Folder(context: controller.managedObjectContext)
                folder.name = "Folder"
                folder.isFavorite = false
                folder.id = UUID()
                folder.color = 0
                saveContext()
                return folder
            } else {
                return folders[0]
            }
        }
        
        func getFolderColor(folder: Folder) -> Color {
            let color = folder.color
            switch color {
            case 0: return .defaultFolderColor
            case 1: return .pickerGreen
            case 2: return .pickerBlue
            case 3: return .pickerPink
            case 4: return .pickerPurple
            default:
                return .defaultFolderColor
            }
        }
        
        func addNewFolder(name: String, isFav: Bool, color: Int) {
            let folder = Folder(context: controller.managedObjectContext)
            folder.name = name
            folder.isFavorite = isFav
            folder.id = UUID()
            folder.color = Int16(color)
            saveContext()
        }
        
        func editFolder(folder: Folder, name: String, isFav: Bool, color: Int) {
            folder.name = name
            folder.isFavorite = isFav
            folder.color = Int16(color)
            saveContext()
        }
        
        func addFolderToFavorites(folder: Folder) {
            folder.isFavorite = true
            saveContext()
        }
        
        func removeFolderFromFavorites(folder: Folder) {
            folder.isFavorite = false
            saveContext()
        }
        
        func removeFolder(folder: Folder) {
            controller.managedObjectContext.delete(folder)
            saveContext()
        }

        
        func saveContext() {
            do {
                try controller.managedObjectContext.save()
                alert = false
            } catch {
                alert =  true
                alertMessage = "Saving data error"
            }
        }
        
        func getMemoriesNum() -> Int {
            var memoriesNum: Int = 0
            
            for folder in folders {
                memoriesNum += folder.safeMemoriesNumber
            }
            return memoriesNum
        }
        
        
    }
}
