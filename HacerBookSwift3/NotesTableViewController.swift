//
//  NotesTableViewController.swift
//  HacerBookSwift3
//
//  Created by Iván Cayón Palacio on 3/10/16.
//  Copyright © 2016 KeepCoding. All rights reserved.
//

import UIKit

class NotesTableViewController: CoreDataTableViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Añado un botón para que cargue e
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Map", style: .done, target: self, action: #selector(loadMap))

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
}

//MARK - Actions
extension NotesTableViewController{
    func loadMap(){
        let mapVc = MapViewController(model: self.fetchedResultsController!)
        self.navigationController?.pushViewController(mapVc, animated: true)
        
    }
}

//MARK: - Data Source
extension NotesTableViewController{
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellId = "NoteCell"
        
        let theNote = fetchedResultsController?.object(at: indexPath) as! Annotation
        
        
        
        
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId)
        if cell == nil{
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
        }
        
        cell?.textLabel?.text = theNote.title
        let fmt = DateFormatter()
        fmt.dateStyle = .medium
        
        cell?.detailTextLabel?.text = fmt.string(from: theNote.modificationDate as! Date)
        
        if (theNote.photo?.photoData != nil){
            let imgResize = theNote.photo?.image?.resizeWith(width: 100.0)
            cell?.imageView?.image = imgResize
        }
        
        
        return cell!

    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let theNote = fetchedResultsController?.object(at: indexPath) as! Annotation
        
        let nVC = NotesViewController(model: theNote)
        self.navigationController?.pushViewController(nVC, animated: true)
        
    }
}

//MARK: - Row deleting
extension NotesTableViewController{
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete){
            let elObjeto = fetchedResultsController?.object(at: indexPath) as! Annotation
            elObjeto.managedObjectContext?.delete(elObjeto)
            tableView.reloadData()
        }
    }
}


