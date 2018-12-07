//
//  UpdateToAttributedStringsPolicy.swift
//  Mooskine
//
//  Created by Adarsha Upadhya on 06/12/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation
import CoreData


class UpdateToAttributedStringsPolicy: NSEntityMigrationPolicy {
    
    override func createDestinationInstances(forSource sInstance: NSManagedObject, in mapping: NSEntityMapping, manager: NSMigrationManager) throws {
        
        try super.createDestinationInstances(forSource: sInstance, in: mapping, manager: manager)
        
        guard let destination = manager.destinationInstances(forEntityMappingName: mapping.name, sourceInstances: [sInstance]).first else{
            return
        }
        
        if let text = sInstance.value(forKey: "text") as? String{
            destination.setValue(NSAttributedString(string: text), forKey: "attributedText")
        }
        
        
    }
    
    
}
