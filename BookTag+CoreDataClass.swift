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
