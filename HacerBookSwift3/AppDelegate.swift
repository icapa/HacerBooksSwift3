
//
//  AppDelegate.swift
//  HacerBookSwift3
//
//  Created by Iván Cayón Palacio on 15/9/16.
//  Copyright © 2016 KeepCoding. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    
    
    let model = CoreDataStack(modelName: "Model", inMemory: false)!
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // For testing 
        try! model.dropAllData()
        
        
        
        // JSON File is load in main queue, it's a small file
        // it should be put also 
        
        do{
            try downloadJSONifNeeded()
        }catch{
            fatalError("Data couldn't be load")
        }
        
        // Process JSON File and fill CoreData, backgound
        //if (isFirstLaunch()==true){
        //    markFirstLaunch(to: false)
            
            do{
                let jsonData = try loadJSONFile()
                let jsonDicts = try JSONSerialization.jsonObject(with: jsonData as Data, options: .allowFragments) as? JSONArray
                
                for oneDict in jsonDicts!{
                    do{
                        let bookValues =  try decodeForCoreData(book: oneDict)
                        let title = bookValues.4
                        let authors = bookValues.0
                        let imageUrl = bookValues.1
                        let pdfUrl = bookValues.2
                        let tags = bookValues.3
                        
                        
                        
                        // Add book to core data
                        let oneBook = Book(title: title, imgUrl: imageUrl.absoluteString, pdfUrl: pdfUrl.absoluteString, inContext: model.context)
                        // Add tags to core data
                        for sTag in tags{
                            var theTag : Tag?
                            oneBook.listOfTags.append(sTag)
                            oneBook.listOfTags.append(" ")
                            theTag = Tag.tagForString(sTag, inContext: model.context)
                            if (theTag == nil){
                                theTag = Tag(tag: sTag, inContext: model.context)
                            }
                            // Add the relation between tags and books
                            _ = BookTag(theBook: oneBook, theTag: theTag!, inContext: model.context)
                        }
                       
                        
                        for sAuthor in authors{
                            var theAuthor : Author?
                            
                            theAuthor = Author.authorForString(sAuthor, inContext: model.context)

                            if (theAuthor == nil){
                                  theAuthor = Author(author: sAuthor, inContext: model.context)
                            }
                            theAuthor?.addToBook(oneBook)
                        }
                        
                    }
                }
            
            }catch{
                fatalError("Json File is not downloaded")
            }
            model.save()
        //}
        // Fetch request
        
        let fr = NSFetchRequest<BookTag>(entityName: BookTag.entityName)
        fr.fetchBatchSize = 50
        fr.sortDescriptors = [NSSortDescriptor(key: "tag.tagName",ascending: true),
                              NSSortDescriptor(key: "book",ascending: true)]
        
        let fc = NSFetchedResultsController(fetchRequest: fr, managedObjectContext: model.context, sectionNameKeyPath: "tag.tagName", cacheName: nil)
        
        // Create viewController
        
        let nVC = BookTableViewController(fetchedResultsController: fc as! NSFetchedResultsController<NSFetchRequestResult>, style: .plain)
        
        
        // Creamos el navegador
        let navVC = UINavigationController(rootViewController: nVC)
        
        // La window
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navVC
        window?.makeKeyAndVisible()
        
        
        
        
        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    
    

}

