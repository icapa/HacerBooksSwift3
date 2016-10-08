//
//  Pdf+CoreDataProperties.swift
//  HacerBookSwift3
//
//  Created by Iván Cayón Palacio on 8/10/16.
//  Copyright © 2016 KeepCoding. All rights reserved.
//

import Foundation
import CoreData
 

extension Pdf {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Pdf> {
        return NSFetchRequest<Pdf>(entityName: "Pdf");
    }

    @NSManaged public var pdfData: NSData?
    @NSManaged public var book: Book?

}
