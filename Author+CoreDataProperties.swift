//
//  Author+CoreDataProperties.swift
//  HacerBookSwift3
//
//  Created by Iván Cayón Palacio on 16/9/16.
//  Copyright © 2016 KeepCoding. All rights reserved.
//

import Foundation
import CoreData

extension Author {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Author> {
        return NSFetchRequest<Author>(entityName: "Author");
    }

    @NSManaged public var name: String?
    @NSManaged public var book: NSSet?

}

// MARK: Generated accessors for book
extension Author {

    @objc(addBookObject:)
    @NSManaged public func addToBook(_ value: Book)

    @objc(removeBookObject:)
    @NSManaged public func removeFromBook(_ value: Book)

    @objc(addBook:)
    @NSManaged public func addToBook(_ values: NSSet)

    @objc(removeBook:)
    @NSManaged public func removeFromBook(_ values: NSSet)

}
