//
//  HacerBookSwift3Tests.swift
//  HacerBookSwift3Tests
//
//  Created by Iván Cayón Palacio on 15/9/16.
//  Copyright © 2016 KeepCoding. All rights reserved.
//

import XCTest
@testable import HacerBookSwift3
import CoreData

let model = CoreDataStack(modelName: "Model", inMemory: true)!



class HacerBookSwift3Tests: XCTestCase {
    
    
    override func setUp() {
        do{
            try model.dropAllData()
            
        }
        catch{
            print("Test Setup: Error deleting data")
        }
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testInsertAuthor(){
        _ = Author(author: "prueba", inContext: model.context)
        _ = Author(author: "pepito", inContext: model.context)
        _ = Author(author: "prueba", inContext: model.context)

        
        
        XCTAssert(Author.exists("prueba",inContext: model.context)==true,"Prueba must exist!")
        XCTAssert(Author.exists("Juanito",inContext: model.context)==false,"Prueba must exist!")
        XCTAssert(Author.exists("Prueba",inContext: model.context)==true,"Prueba must exist!")
        
    }
    
    func testTagSort(){
        _ = Tag(tag: "Favorite", inContext: model.context)
        _ = Tag(tag: "Programming", inContext: model.context)
        _ = Tag(tag: "CoreData",inContext: model.context)
        _ = Tag(tag: "coredata",inContext: model.context)
        
        // Hago una busqueda ordenada
        
        let fr = NSFetchRequest<Tag>(entityName: Tag.entityName)
        fr.fetchLimit = 10
        fr.fetchBatchSize = 10
        
        fr.sortDescriptors = [NSSortDescriptor.init(key: "tagName", ascending: true)]
        
        
        let result = try! model.context.fetch(fr)
        
        XCTAssertNotNil(result)
        
        XCTAssertEqual(result.count,3,"Tag count should be 3")
        
        
        
           
        let ns = NSFetchedResultsController(fetchRequest: fr,
                                            managedObjectContext: model.context,
                                            sectionNameKeyPath: nil, cacheName: nil)
        try! ns.performFetch()
        
        let f = ns.object(at: IndexPath(row: 0, section: 0)).realTagName
        let c = ns.object(at: IndexPath(row: 1, section: 0)).realTagName
        let p = ns.object(at: IndexPath(row: 2, section: 0)).realTagName
        
        XCTAssertEqual(f, "favorite","First tag should be favorite")
       
        
        XCTAssertEqual(c, "coredata","Second tag should be coredata")
        XCTAssertEqual(p, "programming","Third tag should be programming")

        
        

    }
    
}
