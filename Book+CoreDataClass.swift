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
            
            //
            
        }
        else{
            self.init(entity: entity, insertInto: nil)
        }
    }
    public override func prepareForDeletion() {
        tearDownKVO()
    }
    
}
//MARK: -- Favorite managemente
extension Book{
    func favoriteSwitch(){
        if (self.isFavorite == true){
            // Create a "favorite" tag
            
            var favTag = Tag.tagForString("favorite", inContext: self.managedObjectContext)
            if (favTag==nil){
                // No existe el tag hay que crearlo
                favTag = Tag(tag: "favorite", inContext: self.managedObjectContext!)
            }
            // Test if register already exists
            
            // Associate Book
            if (BookTag.isBookInFavororites(theBook: self,
                                            theTags: favTag!,
                                            inContext: self.managedObjectContext)==false){
                _ = BookTag(theBook: self,
                            theTag: favTag!,
                            inContext: self.managedObjectContext!)
            
                try! self.managedObjectContext?.save()
            }
            
        
        }else{
            
            let theBookTag = BookTag.favoriteBookTag(ofBook: self,inContext: self.managedObjectContext)
            if (theBookTag != nil){
                
                theBookTag?.tag=nil
                theBookTag?.book=nil
                //theBookTag?.tag?.removeFromBookTag(theBookTag!)
                
                try! self.managedObjectContext?.save()
            }
            
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
}
//MARK: - KVO
extension Book{
    //@nonobjc static let observableKeys = ["text","photo.photoData"]
    static func observableKeys() -> [String] {return ["isFavorite"]};
    func setupKVO(){
        // alta en las notificaciones
        // para algunas propiedades
        // Deberes: Usar una la funcion map
        for key in Book.observableKeys(){
            self.addObserver(self,
                             forKeyPath: key,
                             options: [],
                             context: nil)
        }
    }
    
    func tearDownKVO(){
        // Baja en todas las notificaciones
        for key in Book.observableKeys(){
            self.removeObserver(self, forKeyPath: key)
        }
    }
    
    public override func observeValue(forKeyPath keyPath: String?,
                                      of object: Any?,
                                      change: [NSKeyValueChangeKey : Any]?,
                                      context: UnsafeMutableRawPointer?) {
        
        self.favoriteSwitch()
    }
    
}
//MARK: - Serialization object
extension Book{
    func archiveURIRepresentation() -> NSData? {
        let uri = self.objectID.uriRepresentation()
        return NSKeyedArchiver.archivedData(withRootObject: uri) as NSData?
    }
           
}



