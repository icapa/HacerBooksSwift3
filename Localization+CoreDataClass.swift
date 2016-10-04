//
//  Localization+CoreDataClass.swift
//  HacerBookSwift3
//
//  Created by Iván Cayón Palacio on 15/9/16.
//  Copyright © 2016 KeepCoding. All rights reserved.
//

import Foundation
import CoreData
import CoreLocation


public class Localization: NSManagedObject {
    static let entityName = "Localization"
    let model = CoreDataStack.defaultStack(modelName: "Model", inMemory: false)!
    
    //MARK: - Convenience Init
    
    convenience init (withPosition position: CLLocation,
                      inContext context: NSManagedObjectContext){
        let ent = NSEntityDescription.entity(forEntityName: Localization.entityName,
                                             in: context)!
        self.init(entity: ent, insertInto: context)
        self.latitude = position.coordinate.latitude
        self.longitude = position.coordinate.longitude
    }
}

extension Localization{
    class func exists(position: CLLocation, inContext context: NSManagedObjectContext?)->Localization?{
        let fr = NSFetchRequest<Localization>(entityName: Localization.entityName)
        fr.fetchLimit = 1
        fr.fetchBatchSize = 1
        let latitude = NSPredicate(format: "abs(latitude) - abs(%lf) < 0.001", position.coordinate.latitude)
        let longitude = NSPredicate(format: "abs(longitude) - abs(%lf) < 0.001", position.coordinate.longitude)
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [latitude,longitude])
        
        fr.predicate = predicate
        do{
            let result = try context?.fetch(fr)
            guard let resp = result else{
                return nil
            }
            if (resp.count>0){
                return resp.first
            }
            else{
                return nil
            }
        } catch{
            return nil
        }
    }
}
