//
//  Annotation+CoreDataClass.swift
//  HacerBookSwift3
//
//  Created by Iván Cayón Palacio on 15/9/16.
//  Copyright © 2016 KeepCoding. All rights reserved.
//

import Foundation
import CoreData


public class Annotation: NSManagedObject {
    static let entityName = "Annotation"
    
    //MARK: - Init
    // Vacio
    convenience init(withBook book: Book, inContext context: NSManagedObjectContext){
        let entity = NSEntityDescription.entity(forEntityName: Annotation.entityName, in: context)!
        
        self.init(entity: entity, insertInto: context)
        
        // Asignamos el libro
        self.book = book
        self.title = book.title
        self.text = ""
        self.creationDate = NSDate()
        self.modificationDate = NSDate()
        
    }
}
