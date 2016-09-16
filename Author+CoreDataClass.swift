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
        if (Author.exists(author, inContext: context)==false){
            self.init(entity: entity, insertInto: context)
            self.name = author
            self.book = nil
        }else{
            self.init(entity: entity, insertInto: nil)
        }
        
        
        /*
        let fr = NSFetchRequest<Author>(entityName: Author.entityName)
    
        fr.fetchBatchSize = 10
        fr.predicate = NSPredicate(format: "name = [c] %@", author)

        let entity = NSEntityDescription.entity(forEntityName: Author.entityName, in: context)!
 
        do{
            let result = try context.fetch(fr)
            
            if ((result.count)>0){
                self.init(entity: entity, insertInto: nil)
            }else{
                self.init(entity: entity, insertInto: context)
                self.name = author
                self.book = nil

            }
        } catch{
            self.init(entity: entity, insertInto: nil)
        }
        */
    }
    
        
    
}

//MARK - Exists
extension Author {
    static func exists(_ author: String, inContext context: NSManagedObjectContext?) -> Bool {
        let fr = NSFetchRequest<Author>(entityName: Author.entityName)
        fr.fetchLimit = 10
        fr.fetchBatchSize = 10
        fr.predicate = NSPredicate(format: "name == [c] %@", author)
        do{
            let result = try context?.fetch(fr)
            guard let resp = result else{
                return false
            }
            return ((resp.count)>0)
        } catch{
            return false;
        }
        
    }
}
