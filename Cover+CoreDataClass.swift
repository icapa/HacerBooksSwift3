//
//  Cover+CoreDataClass.swift
//  HacerBookSwift3
//
//  Created by Iván Cayón Palacio on 15/9/16.
//  Copyright © 2016 KeepCoding. All rights reserved.
//

import Foundation
import CoreData
import UIKit


public class Cover: NSManagedObject {
    static let entityName = "Cover"
    
    
    var image : UIImage?{
        get{
            guard let data = photoData else{
                return nil
            }
            return UIImage(data: data as Data)!
        }
        
        set{
            guard let img = newValue else{
                photoData = nil
                return
            }
            photoData = UIImageJPEGRepresentation(img, 0.9) as NSData!
        }
        
    }
    
    
    convenience init (book: Book,
                      image: UIImage,
                      inContext context: NSManagedObjectContext){
        let ent = NSEntityDescription.entity(forEntityName: Cover.entityName,
                                                in: context)!
        self.init(entity: ent, insertInto: context)
        self.book = book
        self.image = image
    }
    
    convenience init (book: Book, inContext context: NSManagedObjectContext){
        let ent = NSEntityDescription.entity(forEntityName: Cover.entityName, in: context)!
        self.init(entity: ent, insertInto: context)
        self.book = book
        self.image = nil
        // Default image from disk
               

        
    }
    
}

