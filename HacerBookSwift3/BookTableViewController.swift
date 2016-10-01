//
//  BookTableViewController.swift
//  HacerBookSwift3
//
//  Created by Iván Cayón Palacio on 19/9/16.
//  Copyright © 2016 KeepCoding. All rights reserved.
//

import UIKit
import CoreData

class BookTableViewController: CoreDataTableViewController, UISearchControllerDelegate {
    //let model = CoreDataStack(modelName: "Model", inMemory: false)
    let searchController = UISearchController(searchResultsController: nil)
}

//MARK: - DataSource
extension BookTableViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "HackerBookSwift3"
        // Search controller
        
        
        self.searchController.searchResultsUpdater = self
        self.searchController.dimsBackgroundDuringPresentation = false
        self.searchController.definesPresentationContext = true
        
        self.searchController.searchBar.sizeToFit()
        self.searchController.hidesNavigationBarDuringPresentation = false
        //self.searchController.searchBar.scopeButtonTitles = ["Titulo", "Tag", "Autor"]
        self.searchController.searchBar.delegate = self
        self.tableView.tableHeaderView = searchController.searchBar
        
        
        
        // Fetch request por BookTag
        /*
        let fr = NSFetchRequest<BookTag>(entityName: BookTag.entityName)
        fr.fetchBatchSize = 50
        fr.sortDescriptors = [(NSSortDescriptor(key: "tag.proxyForSorting",ascending: true)),
                              (NSSortDescriptor(key: "book.title",ascending: true))]
        let fc = NSFetchedResultsController(fetchRequest: fr, managedObjectContext: (model?.context)!, sectionNameKeyPath: "tag.tagName", cacheName: nil)
        self.fetchedResultsController? = fc as! NSFetchedResultsController<NSFetchRequestResult>
        */
        let model_contex = self.fetchedResultsController?.managedObjectContext
        let fr = NSFetchRequest<BookTag>(entityName: BookTag.entityName)
        fr.fetchBatchSize = 50
        fr.sortDescriptors = [NSSortDescriptor(key: "tag.tagName",ascending: true),
                              NSSortDescriptor(key: "book.title",ascending: true)]
        
        let fc = NSFetchedResultsController(fetchRequest: fr, managedObjectContext: (model_contex)!, sectionNameKeyPath: "tag.tagName", cacheName: nil)
        self.fetchedResultsController? = fc as!
        NSFetchedResultsController<NSFetchRequestResult>
        
        
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = "BookCell"
        
        
        
        let theBookTag = fetchedResultsController?.object(at: indexPath) as! BookTag
        let book = theBookTag.book
        
        
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId)
        if cell == nil{
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
        }
        
        cell?.textLabel?.text = book?.title
        cell?.detailTextLabel?.text = Author.authorsToString(theAuthors:
            (book?.author))
        
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
//MARK: Searching Bar
extension BookTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController){
        //filterContentForSearchText(searchText: searchController.searchBar.text!)
        
        // Hay que cambiar el fetch request
        let busqueda = searchController.searchBar.text
        
        let fr = NSFetchRequest<BookTag>(entityName: BookTag.entityName)
        fr.fetchBatchSize = 50
        fr.sortDescriptors = [NSSortDescriptor(key: "tag.tagName",ascending: true),
                              NSSortDescriptor(key: "book.title",ascending: true)]
        if (busqueda! != ""){
            let bookPredicate = NSPredicate(format: "book.title CONTAINS [cd] %@",busqueda!)
            let tagPredicate = NSPredicate(format: "tag.tagName CONTAINS [cd] %@",busqueda!)
            let tagAuthor = NSPredicate(format: "book.author.name CONTAINS [cd] %@",busqueda!)
            let predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [bookPredicate,tagPredicate,tagAuthor])
            fr.predicate = predicate
        }
        
        let model_context = self.fetchedResultsController?.managedObjectContext
        
        let fc = NSFetchedResultsController(fetchRequest: fr, managedObjectContext: (model_context)!, sectionNameKeyPath: "tag.tagName", cacheName: nil)
        self.fetchedResultsController? = fc as!
            NSFetchedResultsController<NSFetchRequestResult>
        self.tableView.reloadData()
        
    }
    /*
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        
        self.filteredBooks.removeAll()
        
        switch (scope){
        case "Titulo":
            if let booksByTitle = Book.filterByTitle(title: searchText, inContext: (self.model?.context)!) {
                self.filteredBooks.append(contentsOf: booksByTitle)
            }
            break
        case "Tag":
            if let booksByTag = Tag.filterByTag(tag: searchText, inContext: (self.model?.context)!) {
                self.filteredBooks.append(contentsOf: booksByTag)
            }
            break
            //        case "Autor":
            //            if let booksByAuthor = Author.filterByAuthor(author: searchText, inContext: (self.model?.context)!) {
            //            }
        //            break
        default:
            break
        }
        
        self.tableView.reloadData()
    }
    */
}

extension BookTableViewController: UISearchBarDelegate {
    private func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        /*filterContentForSearchText(searchText: searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
        */
    }
}



