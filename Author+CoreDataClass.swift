//
//  Author+CoreDataClass.swift
//  HacerBookSwift3
//
//  Created by Iván Cayón Palacio on 15/9/16.
//  Copyright © 2016 KeepCoding. All rights reserved.
//

import Foundation
import CoreData


public class Author: NSManagedObject {

    static let entityName = "Author"
    
    convenience init(author: String, inContext context: NSManagedObjectContext){
        let entity = NSEntityDescription.entity(forEntityName: Author.entityName, in: context)!
        self.init(entity: entity, insertInto: context)
        self.name = author
        self.book = nil
    }
    
}
//MARK - Exists
extension Author {
    func exists(_ author: String) -> Bool {
        let fr = NSFetchRequest<Author>(entityName: Author.entityName)
        fr.fetchLimit = 1
        fr.fetchBatchSize = 1
        fr.predicate = NSPredicate(format: "name == %@", author)
        
        
        do{
            let result = try self.managedObjectContext?.fetch(fr)
            return ((result?.count)!>0)
        } catch{
            return false;
        }
        
    }

}
