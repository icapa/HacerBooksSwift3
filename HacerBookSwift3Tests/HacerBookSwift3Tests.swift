//
//  HacerBookSwift3Tests.swift
//  HacerBookSwift3Tests
//
//  Created by Iván Cayón Palacio on 15/9/16.
//  Copyright © 2016 KeepCoding. All rights reserved.
//

import XCTest
//@testable import HacerBookSwift3

class HacerBookSwift3Tests: XCTestCase {
    
    var model : CoreDataStack?
    
    
    
    override func setUp() {
        model = CoreDataStack(modelName: "Model", inMemory: true)!
        do{
            try model?.dropAllData()
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
        let author = Author(author: "prueba", inContext: model!.context)
        XCTAssert(author.name=="prueba")
        model?.save()
        
        XCTAssert(author.exists("prueba")==true,"Prueba must exist!")
        XCTAssert(author.exists("pepito")==false,"Pepito should not exist!")
        
        
        
        
    }
}
