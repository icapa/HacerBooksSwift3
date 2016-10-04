//
//  ResourceManager.swift
//  HackerBooks
//
//  Created by Iván Cayón Palacio on 1/7/16.
//  Copyright © 2016 KeepCoding. All rights reserved.
//

import CoreData



// La informacion que tenemos
let jsonFileName = "books_readable.json"
let jsonUrl="https://keepcodigtest.blob.core.windows.net/containerblobstest/"   // Url to get json file
let favoritesFile="favorites.txt"

import Foundation

enum FileSystemDirectory{
    case documentDirectory  // Documentos como por ejemplo json
    case cacheDirectory     // La cache para los recursos
}




//MARK: - User persistence
// Guarda en la persistencia que ya se cargo el json
func markFirstLaunch(to read: Bool){
    let persistencia = UserDefaults.standard
    persistencia.set(read, forKey: "read")
    persistencia.synchronize()
}

// Resetea la persistencia para probar


// Indica si es la primera vez que se ejecutó
func isFirstLaunch()->Bool{
    let persistencia = UserDefaults.standard
    let read = persistencia.object(forKey: "read")
    if let read = read as? Bool{
        return read
    }else{
        return true
    }
}

//MARK: - JSON


// Esto descarga el json
func downloadJSONFile() throws -> NSData {
    
    //let data = NSData(contentsOfURL: NSURL(string: completeJSONUrl())!)

    let data = NSData(contentsOf: NSURL(string: "\(jsonUrl)\(jsonFileName)")! as URL)
    
    guard let dat = data else{
        throw ErrorHackerBooks.urlResourceNotFound
    }
    try! saveJSONFile(withData: dat)
    return dat
}

func loadJSONFile() throws -> NSData{
    var url : URL
    var newUrl : URL
    do{
        try url = getUrlLocalFileSystem(fromPath: .documentDirectory) as URL
        newUrl = url.appendingPathComponent(jsonFileName)
    }catch{
        throw ErrorHackerBooks.urlResourceNotFound
    }
    let datos = NSData(contentsOf: newUrl as URL)
    guard let data = datos else{
        throw ErrorHackerBooks.urlResourceNotFound
    }
    return data
    
}

func downloadJSONifNeeded() throws  {
        // Si es la primera vez
    // Lo truco
    //markFirstLaunch(to: true)
    
    if isFirstLaunch()==true{
        do{
            try _ = downloadJSONFile()
            //markFirstLaunch(to: false)
            
        }catch{
            throw ErrorHackerBooks.urlResourceNotFound
        }
    }
}

// Guarda el fichero
func saveJSONFile(withData data: NSData) throws {
    var url: URL
    var newUrl: URL
    do{
        try url = getUrlLocalFileSystem(fromPath: .documentDirectory) as URL
        newUrl = url.appendingPathComponent(jsonFileName)
    }catch{
        throw ErrorHackerBooks.urlResourceNotFound
    }
    
    
    guard data.write(to: newUrl, atomically: true) else{
        print("No se pudo guardar")
        throw ErrorHackerBooks.urlResourceNotFound
        
    }
    
}






//MARK: Book Resources download
// Global load, remote or local
func loadResource(withUrl url: NSURL) throws -> NSData{
    var data : NSData
    do{
        data = try loadLocalResource(withUrl: url)
        return data
    }catch{
        // No esta en local, descargamos de remoto
        do{
            data = try loadRemoteResource(withUrl: url)
            // Fue bien asi que guardamos en disco
            try saveResource(withUrl: url, andData: data)
            return data
        }
        catch{
            throw ErrorHackerBooks.urlResourceNotFound
        }
    }
    
}

// Load resource from local
func loadLocalResource(withUrl remoteUrl: NSURL) throws -> NSData{
    do{
        
        let path = try getUrlLocalFileSystem(fromPath: .cacheDirectory)
        guard let fileName = remoteUrl.lastPathComponent else{
            throw ErrorHackerBooks.wrongLocalResource
        }
        
        let newUrl = path.appendingPathComponent(fileName)
        let data = NSData(contentsOf: newUrl!)
        guard let losDatos = data else{
            throw ErrorHackerBooks.wrongLocalResource
        }
        return losDatos
    }
    catch{
        throw ErrorHackerBooks.wrongLocalResource
    }
}

// Load Remote resource
func loadRemoteResource(withUrl url: NSURL) throws -> NSData{
    let data = NSData(contentsOf: url as URL)
    guard let dat = data else{
        throw ErrorHackerBooks.urlResourceNotFound
    }
    return dat
}
    
   
 // Save resource
func saveResource(withUrl url: NSURL, andData data: NSData) throws {
    var newUrl: URL
    let path = try! getUrlLocalFileSystem(fromPath: .cacheDirectory)
    newUrl = (path.appendingPathComponent(url.lastPathComponent!))!
    guard data.write(to: newUrl as URL, atomically: true) else{
        print("No se pudo guardar")
        throw ErrorHackerBooks.urlResourceNotFound
    }
}

//MARK: - Favorites

func loadFavoritesFile() -> Set<String> {
    var elSet = Set<String>()
    var url : URL
    var newUrl : URL
    
    try! url = getUrlLocalFileSystem(fromPath: .documentDirectory) as URL
    newUrl = url.appendingPathComponent(favoritesFile)
    
    
    let elArray = NSArray(contentsOf: newUrl as URL)     // Si no hay nada devuelvo vacio el set
    guard let a = elArray else{
        return elSet
    }
    for b in a{
        elSet.insert(b as! String)
    }
    return elSet
}

func saveFavoritesFile(withFile file: Set<String>){
    var listaStrings = [String]()
    for i in file{
        listaStrings.append(i)
    }
    var url: URL
    var newUrl : URL
    try! url = getUrlLocalFileSystem(fromPath: .documentDirectory) as URL
    newUrl = url.appendingPathComponent(favoritesFile)
    let elArray : NSArray = listaStrings as NSArray
    elArray.write(to: newUrl as URL, atomically: true)
}





    
//MARK: - Utils
func getUrlLocalFileSystem(fromPath path: FileSystemDirectory) throws -> NSURL{
    let fm = FileManager.default
    
    var url: URL?
    switch path {
    case .cacheDirectory:
         url = fm.urls(for: FileManager.SearchPathDirectory.cachesDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).last
        
    case .documentDirectory:
        url = fm.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).last
    }
       guard let laUrl = url else{
        throw ErrorHackerBooks.urlResourceNotFound
    }
    return laUrl as NSURL
}

//MARK: - Actual Book
let BOOK_SAVED = "BookSaved"

func saveIdObjectInDefaults(withModel model: Book){
    let uri = model.objectID.uriRepresentation()
    let deb = uri.absoluteString
    UserDefaults.standard.set(deb,forKey: BOOK_SAVED)
}

func loadIdObjectDefaults(inContext context : NSManagedObjectContext?)->Book?{
        
    if (UserDefaults.standard.value(forKey: BOOK_SAVED) == nil){
        return nil
    }
    let myObjectUrl = NSURL(string: UserDefaults.standard.value(forKey: BOOK_SAVED) as! String)
    if (myObjectUrl == nil){
        return nil
    }
    let myObjectId = context?.persistentStoreCoordinator?.managedObjectID(forURIRepresentation: myObjectUrl as! URL)
    if (myObjectId == nil){
        return nil
    }
    do{
        let myObject = try context?.existingObject(with: myObjectId!)
        let theBook = myObject as? Book
        return theBook
    }
    catch{
        return nil
    }
}
