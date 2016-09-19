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
        
        let nb = fetchedResultsController?.object(at: indexPath) as! Book
        
        // Create cell
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId)
        if cell == nil{
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
        }
        // Configurar la celda
        cell?.textLabel?.text = nb.title
        cell?.detailTextLabel?.text = nb.author?.description
        
        return cell!
    }
}


