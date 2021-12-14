//
//  MemoryModel.swift
//  memories
//
//  Created by Alina Potapova on 16.08.2021.
//


import Foundation
import CoreData
import SwiftUI

extension MemoriesView {
    final class MemoryModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate{
        private let controller :  NSFetchedResultsController<Memory>

        public var alert = false
        public var alertMessage = ""
        init(moc: NSManagedObjectContext, folder: Folder) {
            let sortDescriptors = [NSSortDescriptor(keyPath: \Memory.isFavorite, ascending: false), NSSortDescriptor(keyPath: \Memory.date, ascending: false)]
            controller = Memory.resultsController(moc: moc, sortDescriptors: sortDescriptors, predicate: NSPredicate(format: "is_in = %@",folder))
            super.init()
            
            controller.delegate = self
            do{
                try controller.performFetch()
                alert = false
            } catch{
                alert =  true
                alertMessage = "Saving data error"
            }
        }
        
        
        func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            objectWillChange.send()
        }
        
        var memories: [Memory] {
            return controller.fetchedObjects ?? []
        }
        
        func addNewMemory(place: String, text: String, date: Date, folder: Folder, image: UIImage?){

            let memory = Memory(context: controller.managedObjectContext)
            memory.content = text
            memory.place = place
            memory.date = date
            memory.isFavorite = false
            memory.id = UUID()
            memory.is_in = folder
            savesImage(Name: memory.id!.uuidString, inputImage: image)
            
            saveContext()
        }
        
        func removeMemory(memory: Memory) {
            deleteFromDirectory(Name: memory.id!.uuidString)
            controller.managedObjectContext.delete(memory)
            saveContext()
        }
    
        func changeFavStatus(memory: Memory) {
            memory.isFavorite.toggle()
            saveContext()
        }
        
        func saveContext(){
            do{
                try controller.managedObjectContext.save()
                alert = false
            }catch {
                alert =  true
                alertMessage = "Saving data error"
            }
        }
        
        func savesImage(Name: String, inputImage: UIImage?) {
            let fileName = helper.getDocumentsDirectory().appendingPathComponent(Name)
            do {
                if let jpegData = inputImage?.jpegData(compressionQuality: 0.8) {
                    try jpegData.write(to: fileName, options: [.atomicWrite, .completeFileProtection])
                }
            } catch {
                print("Unable to save image")
            }
         }
        
        func deleteFromDirectory(Name: String) {
            let fileName = helper.getDocumentsDirectory().appendingPathComponent(Name)
            let filePath = fileName.path
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: filePath) {
                try? fileManager.removeItem(atPath: filePath)
            } else {
                print("File at path \(filePath) does not exist")
            }
        }
    }
}
