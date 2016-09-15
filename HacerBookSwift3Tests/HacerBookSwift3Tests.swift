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
        let author = Author(author: "prueba", inContext: (model.context))
        let author3 = Author(author: "JUANITO", inContext: (model.context))
        let author2 = Author(author: "prueba", inContext: (model.context))

        //let _ = Author(author: "juanito", inContext: model!.context)
        
        //model?.save()
        
        XCTAssert(author.exists("prueba")==true,"Prueba must exist!")
        //XCTAssert(author.exists("pepito")==false,"Pepito should not exist!")
        XCTAssert(author3.exists("Prueba")==true,"Prueba must exist!")
        XCTAssert(author2.exists("JuAnItO")==true,"Prueba must exist!")
        
        
        
    }
}
