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
        
        //let nb = fetchedResultsController?.object(at: indexPath) as! Book
        
        // Create cell
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId)
        if cell == nil{
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
        }
        // Configurar la celda
        //cell?.textLabel?.text = nb.title
        //cell?.detailTextLabel?.text = nb.author?.description
        
        cell?.textLabel?.text = "probando"
        cell?.detailTextLabel?.text = "probando2"
        
        return cell!
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        //return (fetchedResultsController?.fetchedObjects?.count)!
        return 5
        
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //let indexPat = IndexPath(item: 0, section: section)
        return "Puta Mierda "+section.description
        //return (fetchedResultsController?.object(at: indexPat) as! Tag).tagName
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
}


