//
//  Operations.swift
//  IniNotesV3
//
//  Created by IndratS on 23/09/20.
//  Copyright © 2020 IndratSaputra. All rights reserved.
//

import Foundation
import CoreData
import UIKit

struct Operations {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func loadData() -> [Notes]? {
        let data: [Notes]?
        
        do {
            data = try context.fetch(Notes.fetchRequest())
            return data
        }catch{
            return nil
        }
    }
}
