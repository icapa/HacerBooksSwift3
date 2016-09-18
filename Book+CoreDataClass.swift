//
//  Book+CoreDataClass.swift
//  HacerBookSwift3
//
//  Created by Iván Cayón Palacio on 15/9/16.
//  Copyright © 2016 KeepCoding. All rights reserved.
//

import Foundation
import CoreData

/*
 @NSManaged public var imageUrl: String?
 @NSManaged public var isFavorite: Bool
 @NSManaged public var pdfUrl: String?
 @NSManaged public var title: String?
 
 @NSManaged public var annotation: NSSet?
 @NSManaged public var author: NSSet?
 @NSManaged public var bookTag: NSSet?
 @NSManaged public var cover: Cover?
 @NSManaged public var pdf: Pdf?
*/


public class Book: NSManagedObject {
    static let entityName = "Book"
    
    convenience init (title: String, inContext context: NSManagedObjectContext){
        let entity = NSEntityDescription.entity(forEntityName: Book.entityName, in: context)!
        if (Book.exists(title, inContext: context) == false){
            self.init(entity: entity, insertInto: context)
            self.title = title
            self.pdfUrl = nil
            self.imageUrl = nil
            
        }
        else{
            self.init(entity: entity, insertInto: nil)
        }
        
    }

}

extension Book{
    static func exists(_ title: String, inContext context: NSManagedObjectContext?) -> Bool {
        let fr = NSFetchRequest<Book>(entityName: Book.entityName)
        fr.fetchLimit = 1
        fr.fetchBatchSize = 1
        fr.predicate = NSPredicate(format: "title CONTAINS [cd] %@", title)
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
