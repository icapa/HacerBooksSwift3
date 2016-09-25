//
//  BookTag+CoreDataClass.swift
//  HacerBookSwift3
//
//  Created by Iván Cayón Palacio on 15/9/16.
//  Copyright © 2016 KeepCoding. All rights reserved.
//

import Foundation
import CoreData


public class BookTag: NSManagedObject {
    static let entityName = "BookTag"
    
    convenience init (theBook :Book, theTag: Tag, inContext context: NSManagedObjectContext){
        let entity = NSEntityDescription.entity(forEntityName: BookTag.entityName, in: context)!
        self.init(entity: entity, insertInto: context)
        self.book = theBook
        self.tag = theTag
    }
}

extension BookTag{
    static func booksForTag(theTag : Tag,
                            inContext context: NSManagedObjectContext?)->[BookTag]?{
        
        let fr = NSFetchRequest<BookTag>(entityName: BookTag.entityName)
        fr.fetchLimit = 50
        fr.fetchBatchSize = 50
        fr.sortDescriptors = [NSSortDescriptor.init(key: "book", ascending: true)]
        fr.predicate = NSPredicate(format: "tag == %@", theTag)
        
        do{
            let result = try context?.fetch(fr)
            guard let resp = result else{
                return nil
            }
            return resp
        } catch{
            return nil;
        }
    }
    static func tagsForBook(theBook : Book,
                            inContext context: NSManagedObjectContext?)->[BookTag]?{
        let fr = NSFetchRequest<BookTag>(entityName: BookTag.entityName)
        fr.fetchLimit = 50
        fr.fetchBatchSize = 50
        fr.sortDescriptors = [NSSortDescriptor.init(key: "tag", ascending: true)]
        fr.predicate = NSPredicate(format: "book == %@", theBook)
        
        do{
            let result = try context?.fetch(fr)
            guard let resp = result else{
                return nil
            }
            return resp
        } catch{
            return nil;
        }

    }
}
