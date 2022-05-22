//
//  UserModel.swift
//  memories
//
//  Created by Alina Potapova on 07.05.2022.
//

import Foundation
import CoreData
import SwiftUI

extension ProfileView {
    final class UserModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
        private let controller :  NSFetchedResultsController<User>

        public var alert = false
        public var alertMessage = ""
        
        init(moc: NSManagedObjectContext) {
            let sortDescriptors = [NSSortDescriptor(keyPath: \User.name, ascending: false)]
            controller = User.resultsController(moc: moc, sortDescriptors: sortDescriptors)
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
        
        var user: [User] {
            return controller.fetchedObjects ?? []
        }
        
        var userName: String {
            if !user.isEmpty {
                return user.first?.safeName ?? "Username"
            } else {
                return "Username"
            }
    
        }
        
        var userId: UUID {
            if !user.isEmpty {
                return user.first?.id ?? UUID()
            } else {
                return UUID()
            }
        }
        
        func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            objectWillChange.send()
        }
        
        func saveContext(){
            do {
                try controller.managedObjectContext.save()
                alert = false
            } catch {
                alert =  true
                alertMessage = "Saving data error"
            }
        }
        
        func getDefaultUser() -> User {
            if user.isEmpty {
                let user = User(context: controller.managedObjectContext)
                user.name = "User"
                user.id = UUID()
                savesImage(Name: user.id!.uuidString, inputImage: Image("user_logo").asUIImage())
                saveContext()
                return user
            } else {
                return user[0]
            }
        }
        
        func getDefaultUserImage() -> Image {
            if user.isEmpty {
                return Image("user_logo")
            }
            else {
                let data = helper.loadImage(imageIdName: user[0].id!.uuidString)
                guard let loadedData = data else {
                    return Image("user_logo")
                    
                }
                return Image(uiImage: UIImage(data: loadedData)!)
            }
        }
        
        func editUserData(user: User, name: String, image: UIImage?) {
            user.name = name
            savesImage(Name: user.id!.uuidString, inputImage: image)
            saveContext()
        }
        
        func registrated() -> Bool {
            return user.isEmpty
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
        
