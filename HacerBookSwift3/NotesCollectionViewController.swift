//
//  NotesCollectionViewController.swift
//  HacerBookSwift3
//
//  Created by Iván Cayón Palacio on 5/10/16.
//  Copyright © 2016 KeepCoding. All rights reserved.
//

import UIKit

class NotesCollectionViewController: CoreDataCollectionViewController {
    
    static let cellId = "NoteCellId"
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Map", style: .done, target: self, action: #selector(loadMap))

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.registerNib()
        
        self.collectionView?.backgroundColor = UIColor(white: 0.95, alpha: 1)
        self.title = "Notas"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //MARK: - Xib registration
    func registerNib(){
        let nib = UINib(nibName: "NoteCollectionViewCell", bundle: nil)
        self.collectionView?.register(nib, forCellWithReuseIdentifier: NotesCollectionViewController.cellId)
    }
    
    //MARK: - Data source
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Obtener el objeto
        let nota = self.fetchedResultsController?.object(at: indexPath) as! Annotation
        
        // Obtener una celda
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NotesCollectionViewController.cellId, for: indexPath) as! NoteViewCollectionViewCell
        
        // Configurar una celda
        cell.labelTitle.text = nota.title
        
        if (nota.photo?.image != nil){
            let resize = nota.photo?.image!.resizeWith(width: cell.imageViewCell.bounds.width)

            cell.imageViewCell.image = resize
        }else{
            let resize = UIImage(named: "nota_vacia.png")?.resizeWith(width: cell.imageViewCell.bounds.width)
            cell.imageViewCell.image = resize
        }
        
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 6;
        
        
        let fmt = DateFormatter()
        fmt.dateStyle = .medium
        cell.labelDate.text = fmt.string(from: nota.modificationDate as! Date)
        
        // Devolverla
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let nota = self.fetchedResultsController?.object(at: indexPath) as! Annotation
        let notaVc = NotesViewController(model: nota)
        self.navigationController?.pushViewController(notaVc, animated: true)
        
    }
    
   
}
//MARK: Actions
extension NotesCollectionViewController{
    func loadMap(){
        let mapVc = MapViewController(model: self.fetchedResultsController!)
        self.navigationController?.pushViewController(mapVc, animated: true)
        
    }

}
