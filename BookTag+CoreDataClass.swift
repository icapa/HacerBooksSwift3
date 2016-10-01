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
    static func isBookInFavororites(theBook: Book,
                                    theTags tag: Tag,
                                    inContext context: NSManagedObjectContext?)->Bool{
        let fr = NSFetchRequest<BookTag>(entityName: BookTag.entityName)
        fr.fetchLimit = 1
        fr.fetchBatchSize = 1
        
        fr.predicate = NSPredicate(format: "tag == %@ AND book == %@", tag, theBook)
        
        do{
            let result = try context?.fetch(fr)
            guard let resp = result else{
                return false
            }
            if (resp.count>0){
                return true
            }
            else{
                return false
            }
        } catch{
            return false
        }

    }
    static func tagsForBook(theBook : Book,
                            inContext context: NSManagedObjectContext?)->[BookTag]?{
        let fr = NSFetchRequest<BookTag>(entityName: BookTag.entityName)
        fr.sortDescriptors = [NSSortDescriptor.init(key: "tag", ascending: true)]
        //fr.predicate = NSPredicate(format: "book == %@", theBook)
        
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
    static func favoriteBookTag(ofBook book:Book,
                                inContext context: NSManagedObjectContext?)->BookTag?{
        let fr = NSFetchRequest<BookTag>(entityName: BookTag.entityName)
        fr.fetchLimit = 1
        fr.fetchBatchSize = 1
        fr.sortDescriptors = [NSSortDescriptor.init(key: "tag", ascending: true)]
        fr.predicate = NSPredicate(format: "book == %@ and tag.tagName == '0favorite'", book)
        
        do{
            let result = try context?.fetch(fr)
            guard let resp = result else{
                return nil
            }
            return resp.first
        } catch{
            return nil;
        }

    }
}
