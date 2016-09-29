//
//  Book+CoreDataProperties.swift
//  HacerBookSwift3
//
//  Created by Iván Cayón Palacio on 29/9/16.
//  Copyright © 2016 KeepCoding. All rights reserved.
//

import Foundation
import CoreData


extension Book {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Book> {
        return NSFetchRequest<Book>(entityName: "Book");
    }

    @NSManaged public var imageUrl: String?
    @NSManaged public var isFavorite: Bool
    @NSManaged public var pdfUrl: String?
    @NSManaged public var title: String?
    @NSManaged public var annotation: NSSet?
    @NSManaged public var author: NSSet?
    @NSManaged public var bookTag: NSSet?
    @NSManaged public var cover: Cover?
    @NSManaged public var pdf: Pdf?

}

// MARK: Generated accessors for annotation
extension Book {

    @objc(addAnnotationObject:)
    @NSManaged public func addToAnnotation(_ value: Annotation)

    @objc(removeAnnotationObject:)
    @NSManaged public func removeFromAnnotation(_ value: Annotation)

    @objc(addAnnotation:)
    @NSManaged public func addToAnnotation(_ values: NSSet)

    @objc(removeAnnotation:)
    @NSManaged public func removeFromAnnotation(_ values: NSSet)

}

// MARK: Generated accessors for author
extension Book {

    @objc(addAuthorObject:)
    @NSManaged public func addToAuthor(_ value: Author)

    @objc(removeAuthorObject:)
    @NSManaged public func removeFromAuthor(_ value: Author)

    @objc(addAuthor:)
    @NSManaged public func addToAuthor(_ values: NSSet)

    @objc(removeAuthor:)
    @NSManaged public func removeFromAuthor(_ values: NSSet)

}

// MARK: Generated accessors for bookTag
extension Book {

    @objc(addBookTagObject:)
    @NSManaged public func addToBookTag(_ value: BookTag)

    @objc(removeBookTagObject:)
    @NSManaged public func removeFromBookTag(_ value: BookTag)

    @objc(addBookTag:)
    @NSManaged public func addToBookTag(_ values: NSSet)

    @objc(removeBookTag:)
    @NSManaged public func removeFromBookTag(_ values: NSSet)

}
