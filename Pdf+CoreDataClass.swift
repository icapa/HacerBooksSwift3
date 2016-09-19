//
//  Pdf+CoreDataClass.swift
//  HacerBookSwift3
//
//  Created by Iván Cayón Palacio on 15/9/16.
//  Copyright © 2016 KeepCoding. All rights reserved.
//

import Foundation
import CoreData


public class Pdf: NSManagedObject {
    static let entityName = "Pdf"
    convenience init (withData: NSData, inContext context: NSManagedObjectContext){
        let entity = NSEntityDescription.entity(forEntityName: Pdf.entityName, in: context)!
        self.init(entity: entity, insertInto: context)
        self.pdfData = withData
    }
}
