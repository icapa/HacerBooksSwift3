//
//  BookTag+CoreDataProperties.swift
//  HacerBookSwift3
//
//  Created by Iván Cayón Palacio on 15/9/16.
//  Copyright © 2016 KeepCoding. All rights reserved.
//

import Foundation
import CoreData


extension BookTag {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BookTag> {
        return NSFetchRequest<BookTag>(entityName: "BookTag");
    }

    @NSManaged public var name: String?
    @NSManaged public var book: Book?
    @NSManaged public var tag: Tag?

}