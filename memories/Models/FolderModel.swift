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
            let sortDescriptors = [NSSortDescriptor(keyPath: \Folder.isFavorite, ascending: false)]
            controller = Folder.resultsController(moc: moc, sortDescriptors: sortDescriptors)
            super.init()
            
            controller.delegate = self
            do{
                try controller.performFetch()
                alert = false
            }catch{
                alert =  true
                alertMessage = "Upload error"
            }
        }
        
        func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            objectWillChange.send()
        }

        func addNewFolder(name: String){
            if(name.count > 0) {
                let folder = Folder(context: controller.managedObjectContext)
                folder.name = name
                folder.isFavorite = false
                saveContext()
            }
        }
        
        func favToggle(folder: Folder) {
            folder.isFavorite.toggle()
            saveContext()
        }
      
        func removeFolder(folder: Folder){
            controller.managedObjectContext.delete(folder)
            saveContext()
        }
        
        func saveContext(){
            do{
                try controller.managedObjectContext.save()
                alert = false
            }catch {
                alert =  true
                alertMessage = "Upload error"
            }
        }
        
        func getMemoriesNum(folder: Folder) -> Int {
            return folder.safeMemoriesNumber
        }
        
        var folders: [Folder] {
            return controller.fetchedObjects ?? []
        }
        
    }
}

