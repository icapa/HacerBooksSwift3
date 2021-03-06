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
        
        
    }
    
        
    
}

//MARK: - Static class
extension Author {
    static func exists(_ author: String, inContext context: NSManagedObjectContext?) -> Bool {
        let fr = NSFetchRequest<Author>(entityName: Author.entityName)
        fr.fetchLimit = 1
        fr.fetchBatchSize = 1
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
    static func authorForString(_ author: String, inContext context: NSManagedObjectContext?) -> Author?{
        let fr = NSFetchRequest<Author>(entityName: Author.entityName)
        fr.fetchLimit = 1
        fr.fetchBatchSize = 1
        fr.predicate = NSPredicate(format: "name == [c] %@", author)
        do{
            let result = try context?.fetch(fr)
            guard let resp = result else{
                return nil
            }
            if (resp.count>0){
                return resp.first
            }
            else{
                return nil
            }
        } catch{
            return nil
        }

    }
    //MARK: - Presentation
    static func authorsToString(theAuthors: NSSet?)->String{
        var stringAuthors : String = ""
        if (theAuthors==nil){
            return ""
        }
        for each in theAuthors!{
            let oneAuthor = each as! Author
            stringAuthors.append(oneAuthor.name!)
            stringAuthors.append(",")
        }
        let listAutoresString = stringAuthors.trimmingCharacters(in: CharacterSet.init(charactersIn: ","))
        
        return listAutoresString
        
    }

}


