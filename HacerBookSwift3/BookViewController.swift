//
//  BookViewController.swift
//  HacerBookSwift3
//
//  Created by Iván Cayón Palacio on 26/9/16.
//  Copyright © 2016 KeepCoding. All rights reserved.
//

import UIKit

class BookViewController: UIViewController {

    var _model: Book
    
    init(model: Book){
        _model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    @IBOutlet weak var buttonFavorite: UIButton!
    @IBAction func changeFavoritu(_ sender: AnyObject) {
        _model.isFavorite = !_model.isFavorite
        syncModelWithView()
    }
    @IBAction func readPdf(_ sender: AnyObject) {
        let pdfVC = PdfViewController(model: _model)
        navigationController?.pushViewController(pdfVC, animated: true)
    }
    
    @IBOutlet weak var tagsLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
       
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var imageBook: UIImageView!
    
   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK: Init
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Sync
    func syncModelWithView(){
        self.tagsLabel.text = _model.listOfTags
        self.authorLabel.text = Author.authorsToString(theAuthors: _model.author!)
        self.titleLabel.text = _model.title!
        
        if (_model.isFavorite == true){
            
            let fav = UIImage(named: "favorito.jpeg")
            self.buttonFavorite.setBackgroundImage(fav,
                                                   for: .normal)
        }
        else{
            let nofav = UIImage(named: "no_favorito.png")
            self.buttonFavorite.setBackgroundImage(
                nofav,
                for: .normal)
        }
        self.imageBook.image = downloadCover(ofBook: _model)
        
    }
    
    
    //MARK: - LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        syncModelWithView()
    }
    
}
// Download cover in case
extension BookViewController {
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
                        
                        
                        try! book.managedObjectContext?.save()
                        self.imageBook.image = book.cover?.image
                        
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

