//
//  BookTableViewController.swift
//  HacerBookSwift3
//
//  Created by Iván Cayón Palacio on 19/9/16.
//  Copyright © 2016 KeepCoding. All rights reserved.
//

import UIKit

class BookTableViewController: CoreDataTableViewController {

}

//MARK: - DataSource
extension BookTableViewController{
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "HackerBookSwift3"
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = "BookCell"
        /* ESTO ES COMO LO HAGO AHORA <<<<<<
        
        // Look for the tag section
        let tagList = Tag.allTags(fetchedResultsController?.managedObjectContext)
        let tagSection = tagList?[indexPath.section]
        
        // Book list
        let bookList = BookTag.booksForTag(theTag: tagSection!, inContext: fetchedResultsController?.managedObjectContext)
        
        
        // Create cell
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId)
        if cell == nil{
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
        }
        
        cell?.textLabel?.text = bookList?[indexPath.row].book?.title
        cell?.detailTextLabel?.text = Author.authorsToString(theAuthors:
            (bookList?[indexPath.row].book?.author)!)
        
        cell?.imageView?.image = self.downloadCover(ofBook:
            (bookList?[indexPath.row].book)!)
        <<<<<<<<<<<<<<< */
        
        // Esto de prueba
        
        
        
        let theBookTag = fetchedResultsController?.object(at: indexPath) as! BookTag
        let book = theBookTag.book
        
        
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId)
        if cell == nil{
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
        }
        
        cell?.textLabel?.text = book?.title
        cell?.detailTextLabel?.text = Author.authorsToString(theAuthors:
            (book?.author)!)
        
        cell?.imageView?.image = self.downloadCover(ofBook:
            (book)!)

        
       
        
        return cell!
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
               let i = IndexPath(row:0, section: section)
        let p = fetchedResultsController?.object(at: i) as! BookTag
        let titulo = p.tag?.realTagName
        return titulo
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let bookTag = fetchedResultsController?.object(at: indexPath) as! BookTag
        let book = bookTag.book!
        let bookVC = BookViewController(model: book)
        navigationController?.pushViewController(bookVC, animated: true)
    }
    
}


//MARK: - AsyncDataDownload
extension BookTableViewController {
    func downloadCover(ofBook book:Book)->UIImage{
        if (book.cover?.photoData==nil){
            let mainBundle = Bundle.main
            let defaultImage = mainBundle.url(forResource: "book-icon", withExtension: "png")!
            
            // AsyncData
            let theDefaultData = try! Data(contentsOf: defaultImage)
            
            DispatchQueue.global(qos: .default).async {
                let theUrlImage = URL(string: book.imageUrl!)
                let imageData = try? Data(contentsOf: theUrlImage!)
                DispatchQueue.main.async {
                    if (imageData==nil){
                        book.cover?.photoData = nil
                    }
                    else{
                        book.cover?.photoData = imageData as NSData?
                        
                        self.tableView.reloadData()
                        
                        try! book.managedObjectContext?.save()
                        
                    }
                }
            }
            // Hay que mandar que descargue en segundo plano
            return UIImage(data: theDefaultData)!
        }
        else{
            return (book.cover?.image!)!
        }
    }
}


