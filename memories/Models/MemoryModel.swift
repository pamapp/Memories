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
            controller = Memory.resultsController(moc: moc, sortDescriptors: sortDescriptors, predicate: NSPredicate(format: "is_in = %@", folder))
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
        
        
        func addtoFavorites(memory: Memory) {
            memory.isFavorite = true
            saveContext()
        }
        
        func removeFromFavorites(memory: Memory) {
            memory.isFavorite = false
            saveContext()
        }
        
        func getMemoryColor(memory: Memory) -> Color {
            let color = memory.color
            switch color {
            case 0: return .cellColor
            case 1: return .pickerGreen
            case 2: return .pickerBlue
            case 3: return .pickerPink
            case 4: return .pickerPurple
            case 5: return .pickerRed
            default:
                return .cellColor
            }
        }
        
        
        func addNewMemory(title: String, place: Location, text: String, date: Date, folder: Folder, image: UIImage?, color: Int) {
            let memory = Memory(context: controller.managedObjectContext)
            memory.content = text
            memory.title = title
            memory.place = place
            memory.date = date
            memory.isFavorite = false
            memory.id = UUID()
            memory.is_in = folder
            memory.color = Int16(color)
            savesImage(Name: memory.id!.uuidString, inputImage: image)
            saveContext()
        }
        
        func editMemory(memory: Memory, text: String, title: String, place: Location, date: Date, folder: Folder, color: Int, image: UIImage?) {
            memory.content = text
            memory.title = title
            memory.place = place
            memory.date = date
            memory.is_in = folder
            memory.color = Int16(color)
            savesImage(Name: memory.id!.uuidString, inputImage: image)
            saveContext()
        }
        
        func removeMemory(memory: Memory) {
            deleteFromDirectory(Name: memory.id!.uuidString)
            controller.managedObjectContext.delete(memory)
            saveContext()
        }
        
        func getMemoryImage(memory: Memory) -> Image {
            if memory.id == nil {
                print("nil")
            }
            else {
                let data = helper.loadImage(imageIdName: memory.id!.uuidString)
                guard let loadedData = data else {
                    return Image("test_photo")
                }
                return Image(uiImage: UIImage(data: loadedData)!)
            }
            return Image("test_photo")
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
        
        func memoriesNumberByMonth(month: Int) -> Int {
            var monthMemoryNum: Int = 0
            for memory in memories {
                if memory.date?.get(.month) == month {
                    monthMemoryNum += 1
                }
            }
            return monthMemoryNum
        }

        func memoriesNumberByDate(month: Int) -> [Int] {
            let lastMonth: Int = month
            var halfYearMemories: [Int] = []

            if lastMonth > 6 {
                for index in (lastMonth - 6..<lastMonth + 1) {
                    halfYearMemories.append(memoriesNumberByMonth(month: index))
                }
            } else if lastMonth == 6 {
                for index in (1..<7) {
                    halfYearMemories.append(memoriesNumberByMonth(month: index))
                }
            } else {
                let lastYearStartMonth: Int = 13 + (lastMonth - 6)
                for index in (lastYearStartMonth..<13) {
                    halfYearMemories.append(memoriesNumberByMonth(month: index))
                }
                for index in (1..<lastMonth+1) {
                    halfYearMemories.append(memoriesNumberByMonth(month: index))
                }
            }

            return halfYearMemories
        }
        
        func monthToStringByDate(month: Int) -> [String] {
            let lastMonth: Int = month
            var monthes: [String] = []
            let ma = Calendar.current.shortMonthSymbols

            if lastMonth > 6 {
                for index in (lastMonth - 6..<lastMonth + 1) {
                    monthes.append(ma[index - 1])
                }
            } else if lastMonth == 6 {
                for index in (1..<7) {
                    monthes.append(ma[index - 1])
                }
            } else {
                let lastYearStartMonth: Int = 13 + (lastMonth - 6)
                for index in (lastYearStartMonth..<13) {
                    monthes.append(ma[index - 1])
                }
                for index in (1..<lastMonth+1) {
                    monthes.append(ma[index - 1])
                }
            }

            return monthes
        }
    }
}
