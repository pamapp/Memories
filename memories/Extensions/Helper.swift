//
//  Helper.swift
//  memories
//
//  Created by Alina Potapova on 11.08.2021.
//

import Foundation
import SwiftUI

class helper {
    
    static func getDocumentsDirectory() -> URL {
        // find all possible documents directories for this user
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

        // just send back the first one, which ought to be the only one
        return paths[0]
    }
    
    static  func loadImage(imageIdName: String) -> Data? {
            let fileName = getDocumentsDirectory().appendingPathComponent(imageIdName)
            do {
                let data = try Data(contentsOf: fileName)
                return data
            } catch {
                print("Unable to load image")
            }
            return nil
        }
}
