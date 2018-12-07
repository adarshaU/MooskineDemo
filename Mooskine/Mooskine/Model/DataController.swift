//
//  DataController.swift
//  Mooskine
//
//  Created by Adarsha Upadhya on 04/12/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation
import CoreData


class DataController {
    
    let persistentContainer:NSPersistentContainer
    var viewContext:NSManagedObjectContext{
        
        return persistentContainer.viewContext
        
    }
    
    init(modelName:String) {
        persistentContainer = NSPersistentContainer(name: modelName)
        
    }
    
    func load(completion:(()->Void)? = nil){
        
        persistentContainer.loadPersistentStores { (storeDescription, error) in
            guard error == nil else{
                fatalError()
            }

            self.autoSaveViewContext()
            completion?()
            
        }
    }
}



extension DataController{
    
    func autoSaveViewContext(interval:TimeInterval = 3){
        print("Auto save \(interval)")
        guard interval > 0 else{
            return
        }
        
        if viewContext.hasChanges{
        try? viewContext.save()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
            self.autoSaveViewContext(interval: interval)
        }
    }
    
}
