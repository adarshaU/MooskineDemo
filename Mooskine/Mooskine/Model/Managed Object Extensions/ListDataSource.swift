//
//  ListDataSource.swift
//  Mooskine
//
//  Created by Adarsha Upadhya on 05/12/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation
import CoreData
import UIKit


class ListDataSource<ObjectType:NSManagedObject,CellType:UITableViewCell,EntityType:Notebook>:NSObject,UITableViewDataSource,NSFetchedResultsControllerDelegate{
    
    var fetchResultController:NSFetchedResultsController<EntityType>!
  
    
    init(tableView:UITableView,managedObjectContext:NSManagedObjectContext,fetchRequest:NSFetchRequest<EntityType>,configure:@escaping (CellType,EntityType)->Void){
      
        super.init()
        
        fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchResultController.delegate = self
        
        try? fetchResultController.performFetch()
        
        
    }
    
    
    // -------------------------------------------------------------------------
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchResultController.sections?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchResultController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let aNotebook = fetchResultController.object(at: indexPath)
        
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: NotebookCell.defaultReuseIdentifier, for: indexPath) as! NotebookCell
        
        // Configure cell
        cell.nameLabel.text = aNotebook.name
        
        if let count = aNotebook.notes?.count{
            
            let pageString = count == 1 ? "page" : "pages"
            cell.pageCountLabel.text = "\(count) \(pageString)"
            
        }
        
        return cell
    }
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        switch editingStyle {
//        case .delete: deleteNotebook(at: indexPath)
//        default: () // Unsupported
//        }
//    }
    
}
