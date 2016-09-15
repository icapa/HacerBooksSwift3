//
//  Annotation+CoreDataProperties.swift
//  HacerBookSwift3
//
//  Created by Iván Cayón Palacio on 15/9/16.
//  Copyright © 2016 KeepCoding. All rights reserved.
//

import Foundation
import CoreData


extension Annotation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Annotation> {
        return NSFetchRequest<Annotation>(entityName: "Annotation");
    }

    @NSManaged public var title: String?
    @NSManaged public var text: String?
    @NSManaged public var creationDate: NSDate?
    @NSManaged public var modificationDate: NSDate?
    @NSManaged public var book: Book?
    @NSManaged public var photo: Photo?
    @NSManaged public var localization: Localization?

}
