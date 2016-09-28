//
//  Book+CoreDataClass.swift
//  HacerBookSwift3
//
//  Created by Iván Cayón Palacio on 15/9/16.
//  Copyright © 2016 KeepCoding. All rights reserved.
//

import Foundation
import CoreData
import UIKit

/*
 @NSManaged public var imageUrl: String?
 @NSManaged public var isFavorite: Bool
 @NSManaged public var pdfUrl: String?
 @NSManaged public var title: String?
 
 @NSManaged public var annotation: NSSet?
 @NSManaged public var author: NSSet?
 @NSManaged public var bookTag: NSSet?
 @NSManaged public var cover: Cover?
 @NSManaged public var pdf: Pdf?
*/


public class Book: NSManagedObject {
    static let entityName = "Book"
    public var listOfTags : String = ""
    
    
    convenience init (title: String, imgUrl: String, pdfUrl: String, inContext context: NSManagedObjectContext){
        let entity = NSEntityDescription.entity(forEntityName: Book.entityName, in: context)!
        if (Book.exists(title, inContext: context) == false){
            self.init(entity: entity, insertInto: context)
            self.title = title
            self.pdfUrl = pdfUrl
            self.imageUrl = imgUrl
            self.isFavorite = false
            // Imagen vacia
            self.cover = Cover(book: self, inContext: context)
        }
        else{
            self.init(entity: entity, insertInto: nil)
        }
    }
    
    
    

}
//MARK: -- Favorite managemente
extension Book{
    func favoriteSwitch(){
        if (self.isFavorite == false){
            // Mark favorite the model
            self.isFavorite = true
            // Create a "favorite" tag
            
            var favTag = Tag.tagForString("favorite", inContext: self.managedObjectContext)
            if (favTag==nil){
                // No existe el tag hay que crearlo
                favTag = Tag(tag: "favorite", inContext: self.managedObjectContext!)
            }
            // Associate Book
            _ = BookTag(theBook: self,
                                 theTag: favTag!,
                                 inContext: self.managedObjectContext!)
            
            //try! self.managedObjectContext?.save()
            
        
        }else{
            self.isFavorite=false
            
            let theBookTag = BookTag.favoriteBookTag(ofBook: self,inContext: self.managedObjectContext)
            
            self.managedObjectContext?.delete(theBookTag!)
            
            //try! self.managedObjectContext?.save()
            
            
        }
    }
}
//MARK: -- Static functions
extension Book{
    class  func exists(_ title: String, inContext context: NSManagedObjectContext?) -> Bool {
        let fr = NSFetchRequest<Book>(entityName: Book.entityName)
        fr.fetchLimit = 1
        fr.fetchBatchSize = 1
        fr.predicate = NSPredicate(format: "title == [c] %@", title)
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
    
    class func filterByTitle(title t: String, inContext context: NSManagedObjectContext) -> [Book]? {
        
        let query = NSFetchRequest<Book>(entityName: Book.entityName)
        
        query.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        query.predicate = NSPredicate(format: "title CONTAINS [cd] %@", t)
        
        do {
            let res = try context.fetch(query) as [Book]
            return res
            
        } catch {
            return nil
        }
    }

}
