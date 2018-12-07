//
//  Notebook+extesions.swift
//  Mooskine
//
//  Created by Adarsha Upadhya on 05/12/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation
import CoreData



extension Notebook{
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        creationDate = Date()
    }
}
