//
//  Localization+CoreDataProperties.swift
//  HacerBookSwift3
//
//  Created by Iván Cayón Palacio on 8/10/16.
//  Copyright © 2016 KeepCoding. All rights reserved.
//

import Foundation
import CoreData

extension Localization {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Localization> {
        return NSFetchRequest<Localization>(entityName: "Localization");
    }

    @NSManaged public var address: String?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var annotation: NSSet?

}

// MARK: Generated accessors for annotation
extension Localization {

    @objc(addAnnotationObject:)
    @NSManaged public func addToAnnotation(_ value: Annotation)

    @objc(removeAnnotationObject:)
    @NSManaged public func removeFromAnnotation(_ value: Annotation)

    @objc(addAnnotation:)
    @NSManaged public func addToAnnotation(_ values: NSSet)

    @objc(removeAnnotation:)
    @NSManaged public func removeFromAnnotation(_ values: NSSet)

}
