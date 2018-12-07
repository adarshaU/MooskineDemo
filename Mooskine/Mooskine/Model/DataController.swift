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
    
    var backgroundContext:NSManagedObjectContext!
    
    init(modelName:String) {
        persistentContainer = NSPersistentContainer(name: modelName)
        
    }
    
    func load(completion:(()->Void)? = nil){
        
        persistentContainer.loadPersistentStores { (storeDescription, error) in
            guard error == nil else{
                fatalError()
            }

            //context on private queue
            //1.let backgroundContext = persistentContainer.newBackgroundContext()
//
            //2. always run on private queue
//            self.persistentContainer.performBackgroundTask({ (context) in
//                //long running task
//                try? context.save()
//            })
            
            
//           //3.async on context to dispatch asyncronously to correct queue either on main or private queue
//            self.backgroundContext.perform {
//               // doSomework()
//            }
//            //4.dispatch syncronously to correct queue on main or private depending on the context runing on
//            self.viewContext.performAndWait {
//                //do some long running
//            }
   
            //5. Flag in schema arguments to identify the: Identifying any code running on wrong queue
 //-com.apple.CoreData.ConcurrencyDebug 1
            
            
            self.autoSaveViewContext()
            self.configureContext()
            completion?()
            
        }
    }
    
    
    func configureContext(){
        
        backgroundContext = persistentContainer.newBackgroundContext()
        
        backgroundContext.automaticallyMergesChangesFromParent = true
        viewContext.automaticallyMergesChangesFromParent = true
        
        backgroundContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        viewContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
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
