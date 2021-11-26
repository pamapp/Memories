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
                alertMessage = "Saving data error"
            }
        }
        
        var folders: [Folder] {
            return controller.fetchedObjects ?? []
        }
        
        func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            objectWillChange.send()
        }

        func addNewFolder(name: String, image: UIImage?){
//            if(name.count > 0) {
            let folder = Folder(context: controller.managedObjectContext)
            folder.name = name
            folder.isFavorite = false
            folder.id = UUID()
//            }
            savesImage(Name: folder.id!.uuidString, inputImage: image)
            saveContext()
        }
        
        
        func editFolder(folder: Folder, name: String, image: UIImage?){
            folder.name = name
//            deleteFromDirectory(Name: folder.id!.uuidString)
            savesImage(Name: folder.id!.uuidString, inputImage: image)
            saveContext()
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
                alertMessage = "Saving data error"
            }
        }
        
        func getMemoriesNum(folder: Folder) -> String {
            let memoriesNum = folder.safeMemoriesNumber
            if memoriesNum == 1 {
                return "\(memoriesNum) memory"
            } else if memoriesNum > 1 {
                return "\(memoriesNum) memories"
            }
            return "No memories"
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
