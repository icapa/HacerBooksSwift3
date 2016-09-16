//
//  HacerBookSwift3Tests.swift
//  HacerBookSwift3Tests
//
//  Created by Iván Cayón Palacio on 15/9/16.
//  Copyright © 2016 KeepCoding. All rights reserved.
//

import XCTest
@testable import HacerBookSwift3

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
    
}
