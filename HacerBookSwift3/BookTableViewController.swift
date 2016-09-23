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
        //cell?.detailTextLabel?.text = bookList?[indexPath.row].book?.author
        
       
        
        return cell!
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        let tagCount = Tag.count(fetchedResultsController?.managedObjectContext)
        return tagCount
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let tagList = Tag.allTags(fetchedResultsController?.managedObjectContext)
        return tagList?[section].realTagName
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Get the tag
        let tagList = Tag.allTags(fetchedResultsController?.managedObjectContext)
        let theTag = tagList?[section]
        
        // List the 
        let bookTagList = BookTag.booksForTag(theTag: theTag!, inContext: fetchedResultsController?.managedObjectContext)
        return (bookTagList?.count)!
        
    }
    
}


